import 'package:flutter/material.dart';

import '../widgets/nyaya_bottom_nav.dart';

/// Single source of truth for which of the 5 root tabs is active — shared
/// between [RootScreen] (which owns the tab IndexedStack) and any screen
/// pushed on top of it, so the bottom nav bar stays visible and consistent
/// on every screen, not just the 5 top-level tabs.
class NyayaTabs {
  NyayaTabs._();
  static final ValueNotifier<int> current = ValueNotifier(0);
}

/// A [NyayaBottomNav] for screens pushed via [Navigator.push] (article
/// detail, sign-in, placeholders): tapping a destination pops back to the
/// root tab shell and switches to that tab, so the nav behaves identically
/// everywhere in the app.
class GlobalBottomNav extends StatelessWidget {
  const GlobalBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NyayaTabs.current,
      builder: (context, index, _) {
        return NyayaBottomNav(
          currentIndex: index,
          onTap: (i) {
            NyayaTabs.current.value = i;
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      },
    );
  }
}
