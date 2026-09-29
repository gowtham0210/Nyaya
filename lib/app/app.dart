import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/localization/app_language.dart';
import '../core/localization/l10n.dart';

import '../features/auth/presentation/sign_in_page.dart';
import '../features/onboarding/presentation/welcome_page.dart';
import '../features/splash/presentation/splash_bootstrap.dart';
import 'app_session.dart';
import 'dev_flags.dart';
import 'main_shell.dart';
import 'theme/app_theme.dart';

class NyayaApp extends StatelessWidget {
  NyayaApp({
    super.key,
    this.splashDuration = const Duration(milliseconds: 1800),
    bool? skipSignIn,
  }) : skipSignIn = skipSignIn ?? skipSignInForDev;

  final Duration splashDuration;

  /// Opens the tabs without signing in (see `dev_flags.dart`).
  final bool skipSignIn;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLanguage.current,
      builder: (context, locale, _) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: buildNyayaTheme(),
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SplashBootstrap(
          splashDuration: splashDuration,
          child: skipSignIn || AppSession.isOnboarded
              ? const MainShell()
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
      ),
    );
  }
}
