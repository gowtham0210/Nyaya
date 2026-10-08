import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/auth/data/auth_api_client.dart';
import 'package:nyaya/features/auth/data/auth_repository.dart';
import 'package:nyaya/features/auth/data/auth_token_store.dart';

/// Spec 044: the session survives an app restart.
void main() {
  late MemoryTokenVault vault;

  setUp(() {
    vault = MemoryTokenVault();
    AuthTokenStore.vault = vault;
    AuthTokenStore.clear();
  });

  tearDown(() => AuthTokenStore.vault = MemoryTokenVault());

  /// Forgets the in-memory tokens, as an app restart does.
  void restart() {
    AuthTokenStore.accessToken = null;
    AuthTokenStore.refreshToken = null;
    AuthTokenStore.refreshTokenExpiresAt = null;
  }

  final expiry = DateTime.utc(2026, 11, 5);
  final today = DateTime.utc(2026, 10, 6);

  test('AC-001 a saved session comes back after a restart', () async {
    AuthTokenStore.saveSession(
      accessToken: 'a1',
      refreshToken: 'r1',
      refreshTokenExpiresAt: expiry,
    );
    restart();
    expect(AuthTokenStore.hasSession, isFalse);

    await AuthTokenStore.load(signedIn: true, now: today);

    expect(AuthTokenStore.accessToken, 'a1');
    expect(AuthTokenStore.refreshToken, 'r1');
    expect(AuthTokenStore.refreshTokenExpiresAt, expiry);
  });

  test('AC-002 clearing erases the saved session', () async {
    AuthTokenStore.saveSession(accessToken: 'a1', refreshToken: 'r1');
    AuthTokenStore.clear();
    restart();

    await AuthTokenStore.load(signedIn: true, now: today);

    expect(vault.values, isEmpty);
    expect(AuthTokenStore.hasSession, isFalse);
  });

  test('AC-003 a refresh persists the rotated tokens', () async {
    AuthTokenStore.saveSession(
      accessToken: 'old',
      refreshToken: 'r-old',
      refreshTokenExpiresAt: expiry,
    );
    final repository = AuthRepository(
      apiClient: AuthApiClient(
        client: ApiClient(
          httpClient: MockClient(
            (_) async => http.Response(
              jsonEncode({'accessToken': 'new', 'refreshToken': 'r-new'}),
              200,
            ),
          ),
        ),
      ),
    );

    expect(await repository.refresh(), isTrue);
    restart();
    await AuthTokenStore.load(signedIn: true, now: today);

    expect(AuthTokenStore.accessToken, 'new');
    expect(AuthTokenStore.refreshToken, 'r-new');
    // The old expiry went with the old token.
    expect(AuthTokenStore.refreshTokenExpiresAt, isNull);
  });

  test('AC-004 tokens without the signed-in flag are dropped', () async {
    AuthTokenStore.saveSession(accessToken: 'a1', refreshToken: 'r1');
    restart();

    await AuthTokenStore.load(signedIn: false, now: today);

    expect(AuthTokenStore.hasSession, isFalse);
    expect(vault.values, isEmpty);
  });

  test('AC-005 an expired refresh token is dropped', () async {
    AuthTokenStore.saveSession(
      accessToken: 'a1',
      refreshToken: 'r1',
      refreshTokenExpiresAt: today,
    );
    restart();

    await AuthTokenStore.load(signedIn: true, now: today);

    expect(AuthTokenStore.hasSession, isFalse);
    expect(vault.values, isEmpty);
  });
}
