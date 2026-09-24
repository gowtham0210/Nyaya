import 'package:flutter/material.dart';

import 'screens/root_screen.dart';
import 'state/app_language.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLanguage.load();
  runApp(const NyayaApp());
}

class NyayaApp extends StatelessWidget {
  const NyayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, _, _) {
        return MaterialApp(
          title: 'NYAYA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const RootScreen(),
        );
      },
    );
  }
}
