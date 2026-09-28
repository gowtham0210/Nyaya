import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/localization/l10n.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/auth/data/auth_api_client.dart';
import 'package:nyaya/features/auth/presentation/auth_error_text.dart';
import 'package:nyaya/features/auth/presentation/profession.dart';

void main() {
  final hi = lookupAppLocalizations(const Locale('hi'));

  test('AC-007 professions send stable English values whatever the language', () {
    expect(Profession.values.map((p) => p.value), [
      'Law Student',
      'Lawyer / Advocate',
      'Judge / Judicial Officer',
      'Legal Professional',
      'General Citizen',
    ]);
    expect(Profession.lawStudent.label(hi), 'कानून का छात्र');
  });

  group('authApiErrorText', () {
    test('offline uses the localized offline text', () {
      final error = AuthApiException.from(const ApiOfflineException());
      expect(authApiErrorText(hi, error), hi.errorOffline);
    });

    test('a backend message is shown as returned', () {
      final error = AuthApiException.from(
        const ApiServerException(401, 'फ़ोन या पासवर्ड गलत है', serverMessage: 'फ़ोन या पासवर्ड गलत है'),
      );
      expect(authApiErrorText(hi, error), 'फ़ोन या पासवर्ड गलत है');
    });

    test('no backend message falls back to localized generic text', () {
      final error = AuthApiException.from(
        const ApiServerException(500, 'Request failed (500). Please try again.'),
      );
      expect(authApiErrorText(hi, error), hi.errorGeneric);
    });
  });

  test('an unhandled Firebase code uses localized generic text', () {
    final error = FirebaseAuthException(code: 'internal-error', message: 'An internal error has occurred.');
    expect(firebaseAuthErrorText(hi, error), hi.errorGeneric);
  });
}
