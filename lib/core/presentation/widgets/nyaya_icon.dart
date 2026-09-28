import 'package:flutter/material.dart';

enum HomeIconType {
  book,
  gavel,
  scales,
  document,
  community,
  temple,
  handcuffs,
  contract,
  navHome,
  navCategories,
  navLeaderboard,
  navBookmarks,
  navProfile,
}

class HomeNavItemData {
  const HomeNavItemData({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final HomeIconType icon;
}

/// Renders the shared icon set used across nav bars and category tiles.
class NyayaIcon extends StatelessWidget {
  const NyayaIcon({
    super.key,
    required this.type,
    required this.size,
    required this.color,
    required this.accentColor,
  });

  final HomeIconType type;
  final double size;
  final Color color;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HomeIconType.book:
        return Icon(Icons.menu_book_rounded, size: size, color: color);
      case HomeIconType.gavel:
        return Transform.rotate(
          angle: -0.35,
          child: Icon(Icons.gavel_rounded, size: size, color: color),
        );
      case HomeIconType.scales:
        return Icon(Icons.balance_rounded, size: size, color: color);
      case HomeIconType.document:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.description_outlined, size: size, color: color),
            Positioned(
              right: size * 0.06,
              bottom: size * 0.02,
              child: Icon(
                Icons.edit_outlined,
                size: size * 0.38,
                color: accentColor,
              ),
            ),
          ],
        );
      case HomeIconType.community:
        return Icon(Icons.groups_outlined, size: size, color: color);
      case HomeIconType.temple:
        return Icon(Icons.account_balance_outlined, size: size, color: color);
      case HomeIconType.handcuffs:
        return Icon(Icons.link_rounded, size: size, color: color);
      case HomeIconType.contract:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.article_outlined, size: size, color: color),
            Positioned(
              right: size * 0.04,
              bottom: 0,
              child: Icon(
                Icons.verified_user_outlined,
                size: size * 0.34,
                color: accentColor,
              ),
            ),
          ],
        );
      case HomeIconType.navHome:
        return Icon(Icons.home_rounded, size: size, color: color);
      case HomeIconType.navCategories:
        return Icon(Icons.grid_view_rounded, size: size, color: color);
      case HomeIconType.navLeaderboard:
        return Icon(Icons.emoji_events_outlined, size: size, color: color);
      case HomeIconType.navBookmarks:
        return Icon(Icons.bookmark_border_rounded, size: size, color: color);
      case HomeIconType.navProfile:
        return Icon(Icons.person_outline_rounded, size: size, color: color);
    }
  }
}
