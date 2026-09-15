import 'package:flutter/material.dart';

import 'screens/root_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NyayaApp());
}

class NyayaApp extends StatelessWidget {
  const NyayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NYAYA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RootScreen(),
    );
  }
}
