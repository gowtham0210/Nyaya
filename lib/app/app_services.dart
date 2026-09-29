import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';
import '../features/auth/data/auth_api_client.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/auth_token_store.dart';
import 'dev_flags.dart';

/// App-wide singletons, created on first use. Pages and view models take
/// their dependencies as constructor arguments; only the app wiring layer
/// reads from here.
class AppServices {
  AppServices._();

  /// Bumped when the backend session can no longer be refreshed; the app
  /// listens and returns the user to sign-in.
  static final sessionExpired = ValueNotifier<int>(0);

  static String Function() languageCode = () => 'en';

  static final ApiClient apiClient = ApiClient(
    readAccessToken: () => AuthTokenStore.accessToken,
    languageCode: () => languageCode(),
    refreshSession: () => authRepository.refresh(),
    // With sign-in skipped every call is a 401; don't bounce to sign-in.
    onSessionExpired: skipSignInForDev ? null : () => sessionExpired.value++,
  );

  static final AuthRepository authRepository = AuthRepository(
    apiClient: AuthApiClient(client: apiClient),
  );
}
