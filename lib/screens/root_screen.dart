import 'package:flutter/material.dart';

import '../widgets/nyaya_bottom_nav.dart';
import 'home_screen.dart';
import 'placeholder_screen.dart';

/// Hosts the bottom navigation bar and swaps the body between the five
/// top-level destinations.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    PlaceholderScreen(title: 'Quizzes', subtitle: 'Quiz mode is coming soon.'),
    PlaceholderScreen(title: 'Leaderboard', subtitle: 'The leaderboard is coming soon.'),
    PlaceholderScreen(title: 'Articles', subtitle: 'Articles are coming soon.'),
    PlaceholderScreen(title: 'Profile', subtitle: 'Your profile is coming soon.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NyayaBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
