import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NyayaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NyayaAppBar({super.key, required this.onNotificationTap});

  final VoidCallback onNotificationTap;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Semantics(
                label: 'NYAYA — Law Basic Quiz App',
                image: true,
                child: Image.asset(
                  'assets/images/nyaya_logo.png',
                  height: 42,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
              const Spacer(),
              Semantics(
                button: true,
                label: 'Notifications',
                child: InkWell(
                  onTap: onNotificationTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.beigeBorder),
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: AppColors.navy, size: 21),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
