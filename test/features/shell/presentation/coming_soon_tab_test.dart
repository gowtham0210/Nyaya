import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/localization/l10n.dart';
import 'package:nyaya/core/presentation/widgets/nyaya_icon.dart';
import 'package:nyaya/features/shell/presentation/coming_soon_tab.dart';

void main() {
  Future<void> pumpTab(WidgetTester tester, Locale locale) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => ComingSoonTab(
            title: context.l10n.navLeaderboard,
            icon: HomeIconType.navLeaderboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('AC-006 shows the tab title and a coming-soon message', (
    tester,
  ) async {
    await pumpTab(tester, const Locale('en'));

    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('AC-006 the coming-soon state is localized', (tester) async {
    await pumpTab(tester, const Locale('hi'));

    expect(find.text('लीडरबोर्ड'), findsOneWidget);
    expect(find.text('शीघ्र आ रहा है'), findsOneWidget);
  });
}
