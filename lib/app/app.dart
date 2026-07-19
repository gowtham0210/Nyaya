import 'package:flutter/material.dart';

import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/home_view_model.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/splash/presentation/splash_bootstrap.dart';
import '../features/auth/presentation/sign_in_page.dart';
import 'theme/app_theme.dart';

class NyayaApp extends StatelessWidget {
  const NyayaApp({
    super.key,
    this.splashDuration = const Duration(milliseconds: 1800),
  });

  final Duration splashDuration;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyaya',
      debugShowCheckedModeBanner: false,
      theme: buildNyayaTheme(),
      home: SplashBootstrap(
        splashDuration: splashDuration,
        child: const SignInPage(),
      ),
    );
  }
}
