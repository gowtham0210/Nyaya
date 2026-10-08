import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_services.dart';
import 'app/app_session.dart';
import 'app/theme/app_typography.dart';
import 'core/localization/app_language.dart';
import 'features/auth/data/auth_token_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerFontLicenses();
  // Requires platform config (google-services.json / GoogleService-Info.plist)
  // from the Firebase console — see the setup notes in the project README.
  await Firebase.initializeApp();
  await AppSession.load();
  // Restore the saved session so the learner stays signed in (spec 044).
  AuthTokenStore.vault = SecureTokenVault();
  await AuthTokenStore.load(signedIn: AppSession.signedIn);
  await AppLanguage.load();
  AppServices.languageCode = () => AppLanguage.current.value.languageCode;
  runApp(NyayaApp());
}
