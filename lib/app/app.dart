import 'package:flutter/material.dart';

import '../features/auth/presentation/sign_in_page.dart';
import '../features/onboarding/presentation/welcome_page.dart';
import '../features/splash/presentation/splash_bootstrap.dart';
import 'app_session.dart';
import 'post_sign_up_flow.dart';
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
        child: AppSession.isOnboarded
            ? Builder(builder: buildWiredHomePage)
            : Builder(
                builder: (context) => WelcomePage(
                  onGetStarted: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SignInPage(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
