import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_services.dart';
import 'app/app_session.dart';
import 'core/localization/app_language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Requires platform config (google-services.json / GoogleService-Info.plist)
  // from the Firebase console — see the setup notes in the project README.
  await Firebase.initializeApp();
  await AppSession.load();
  await AppLanguage.load();
  AppServices.languageCode = () => AppLanguage.current.value.languageCode;
  runApp(const NyayaApp());
}
