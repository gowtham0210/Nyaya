import 'package:flutter/material.dart';

import 'nyaya_icon.dart';

const navBarActive = Color(0xFF11233B);
const navBarInactive = Color(0xFF8B95A5);
const navBarIndicator = Color(0xFFD3A247);
const navBarBorder = Color(0xFFECE5DB);

/// The five-tab bottom navigation bar shared by every main-tab screen
/// (Home, Categories, Leaderboard, Articles, Profile).
class NyayaBottomNavBar extends StatelessWidget {
  const NyayaBottomNavBar({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onSelected,
  });

  final List<HomeNavItemData> items;
  final int activeIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('nav.bar'),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: navBarBorder)),
        boxShadow: [
          BoxShadow(
            color: navBarActive.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    item: items[i],
                    isActive: i == activeIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final HomeNavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? navBarActive : navBarInactive;

    return InkWell(
      key: ValueKey('nav.${item.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NyayaIcon(
              type: item.icon,
              size: 24,
              color: color,
              accentColor: color,
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              key: isActive
                  ? ValueKey('nav.${item.id}.active')
                  : ValueKey('nav.${item.id}.inactive'),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: isActive ? 28 : 12,
              height: 3,
              decoration: BoxDecoration(
                color: isActive ? navBarIndicator : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
