import 'package:flutter/material.dart';

import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_tokens.dart';

import 'nyaya_icon.dart';

const navBarActive = NyayaColors.ink;
const navBarInactive = NyayaColors.inkSubtle;
const navBarIndicator = NyayaColors.goldBright;
const navBarBorder = NyayaColors.hairline;

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
          // One indicator slides between tabs (spec 039).
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slot = constraints.maxWidth / items.length;
              return Stack(
                children: [
                  Row(
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
                  AnimatedPositioned(
                    key: const ValueKey('nav.indicator'),
                    duration: NyayaMotion.of(context, NyayaMotion.medium),
                    curve: NyayaMotion.curve,
                    left: slot * activeIndex + (slot - _indicatorWidth) / 2,
                    bottom: 6,
                    width: _indicatorWidth,
                    height: 3,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: navBarIndicator,
                        borderRadius: BorderRadius.all(
                          Radius.circular(NyayaRadii.pill),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
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
      borderRadius: BorderRadius.circular(NyayaRadii.sm),
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
            // One line, shrunk to fit: long labels (e.g. translations) never
            // wrap, and the weight stays fixed so tabs don't shift (spec 037).
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.label,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Holds the indicator's place; the bar itself slides above.
            SizedBox(
              key: isActive
                  ? ValueKey('nav.${item.id}.active')
                  : ValueKey('nav.${item.id}.inactive'),
              width: _indicatorWidth,
              height: 3,
            ),
          ],
        ),
      ),
    );
  }
}

const double _indicatorWidth = 28;
