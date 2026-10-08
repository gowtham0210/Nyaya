import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/onboarding/presentation/onboarding_page.dart';
import 'package:nyaya/features/onboarding/presentation/welcome_page.dart';
import 'package:nyaya/features/splash/presentation/splash_page.dart';

import '../../../support/localized_app.dart';

void main() {
  testWidgets('Welcome renders in Tamil', (tester) async {
    await pumpLocalized(
      tester,
      const WelcomePage(),
      locale: const Locale('ta'),
    );

    expect(find.text('சட்டம் எளிதாக,'), findsOneWidget);
    expect(find.text('சட்டங்களைக் கற்றுக்கொள்ளுங்கள்'), findsOneWidget);
    expect(find.text('Law Made Easy,'), findsNothing);
  });

  testWidgets('Onboarding renders in Telugu', (tester) async {
    await pumpLocalized(
      tester,
      const OnboardingPage(),
      locale: const Locale('te'),
    );

    expect(find.text('మీ జ్ఞానాన్ని పరీక్షించుకోండి.'), findsOneWidget);
    expect(find.text('Test Your Knowledge.'), findsNothing);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('నేర్చుకోండి. అర్థం చేసుకోండి.'), findsOneWidget);
    expect(find.text('దాటవేయి'), findsOneWidget);
    expect(find.text('తదుపరి'), findsOneWidget);
  });

  testWidgets('Splash tagline renders in Hindi', (tester) async {
    await pumpLocalized(tester, const SplashPage(), locale: const Locale('hi'));

    expect(find.text('कानून आधारित क्विज़ ऐप'), findsOneWidget);
  });

  testWidgets('Splash screen-reader text is localized', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpLocalized(tester, const SplashPage(), locale: const Locale('hi'));

    expect(find.bySemanticsLabel('न्याय स्प्लैश स्क्रीन'), findsOneWidget);
    expect(
      tester.getSemantics(
        find.byKey(const ValueKey('splash.loading_semantics')),
      ),
      matchesSemantics(label: 'न्याय लोड हो रहा है', value: '33 प्रतिशत'),
    );
    semantics.dispose();
  });
}
