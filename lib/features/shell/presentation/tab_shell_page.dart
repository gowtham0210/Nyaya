import 'package:flutter/material.dart';

import '../../../app/theme/app_motion.dart';

import '../../../core/presentation/widgets/nyaya_bottom_nav.dart';
import '../../../core/presentation/widgets/nyaya_icon.dart';

/// One bottom-nav tab: its nav item plus the page it shows.
class ShellTab {
  const ShellTab({
    required this.id,
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String id;
  final String label;
  final HomeIconType icon;
  final WidgetBuilder builder;
}

/// The selected tab index. Lets pages inside the shell switch tabs.
class TabShellController extends ValueNotifier<int> {
  TabShellController([super.value = 0]);

  void select(int index) => value = index;
}

/// Hosts the main tabs under one shared bottom nav. Every tab stays
/// mounted so its scroll position and state survive switching. Full-screen
/// flows (topic, quiz) push on the root navigator, over the nav.
class TabShellPage extends StatelessWidget {
  const TabShellPage({super.key, required this.tabs, required this.controller});

  final List<ShellTab> tabs;
  final TabShellController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller,
      builder: (context, index, _) => PopScope(
        // Back on any other tab goes to the first tab (Home) before the
        // app can close.
        canPop: index == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            controller.select(0);
          }
        },
        child: Scaffold(
          // Tabs keep their state; the one coming in fades up (spec 039).
          body: IndexedStack(
            index: index,
            children: [
              for (final (i, tab) in tabs.indexed)
                AnimatedOpacity(
                  opacity: i == index ? 1 : 0,
                  duration: NyayaMotion.of(context, NyayaMotion.medium),
                  curve: NyayaMotion.curve,
                  child: Builder(builder: tab.builder),
                ),
            ],
          ),
          bottomNavigationBar: NyayaBottomNavBar(
            items: [
              for (final tab in tabs)
                HomeNavItemData(id: tab.id, label: tab.label, icon: tab.icon),
            ],
            activeIndex: index,
            onSelected: (selected) {
              if (selected != index) NyayaHaptics.select();
              controller.select(selected);
            },
          ),
        ),
      ),
    );
  }
}
