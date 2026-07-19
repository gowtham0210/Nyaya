import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSession.load();
  runApp(const NyayaApp());
}
