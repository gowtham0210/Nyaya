import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../state/app_language.dart';
import '../state/nyaya_tabs.dart';
import '../widgets/nyaya_bottom_nav.dart';
import 'articles_screen.dart';
import 'home_screen.dart';
import 'placeholder_screen.dart';
import 'profile_screen.dart';

/// Hosts the bottom navigation bar and swaps the body between the five
/// top-level destinations. The active tab lives in [NyayaTabs.current] so
/// screens pushed on top of this one can show the same nav bar and switch
/// tabs without needing their own copy of this state.
///
/// This screen is Navigator's `home` route, so once mounted it sits inside
/// the Overlay and does NOT reliably get rebuilt just because a distant
/// ancestor (MaterialApp) rebuilds — Flutter's route machinery insulates
/// already-built route content from ordinary ancestor rebuilds. Subscribing
/// to [AppLanguage.current] directly here (instead of relying on that
/// ancestor rebuild to cascade down) is what makes every tab's `tr()` text
/// — including the already-mounted Profile tab — actually update when the
/// language changes.
///
/// The tab widgets below are deliberately NOT `const`: Flutter's element
/// reconciliation skips rebuilding a child entirely when the exact same
/// (identical) const widget instance is passed down again — which a
/// language change alone would otherwise do, since `const HomeScreen()` is
/// literally the same singleton object every build. Constructing plain
/// (non-const) instances here forces each tab to actually rebuild and
/// re-evaluate its own `tr()` calls when the language changes.
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, _, _) {
        final screens = [
          HomeScreen(),
          PlaceholderScreen(title: tr('nav_quizzes'), showOwnBottomNav: false),
          PlaceholderScreen(title: tr('nav_leaderboard'), showOwnBottomNav: false),
          ArticlesScreen(),
          ProfileScreen(),
        ];
        return ValueListenableBuilder<int>(
          valueListenable: NyayaTabs.current,
          builder: (context, index, _) {
            return Scaffold(
              body: IndexedStack(index: index, children: screens),
              bottomNavigationBar: NyayaBottomNav(
                currentIndex: index,
                onTap: (i) => NyayaTabs.current.value = i,
              ),
            );
          },
        );
      },
    );
  }
}
