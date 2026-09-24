import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../theme/app_colors.dart';

/// A colored circle showing a user's initial(s), or their real uploaded
/// photo when [avatarUrl] is provided (see POST /users/me/avatar in
/// nyaya_backend). Falls back to initials while the image loads or if it
/// fails to load. Leaderboard entries have no avatar field yet, so they
/// always render initials. The color is derived deterministically from the
/// name so the same user always gets the same fallback color.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.size = 44, this.avatarUrl});

  final String name;
  final double size;
  final String? avatarUrl;

  static const _palette = [
    AppColors.navy,
    AppColors.gold,
    AppColors.goldDark,
    AppColors.navySecondary,
    AppColors.navyDark,
  ];

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  Color get _color => _palette[name.hashCode.abs() % _palette.length];

  Widget get _fallback => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        child: Text(
          _initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl;
    if (url == null || url.isEmpty) return _fallback;

    final fullUrl = url.startsWith('http') ? url : '${ApiConfig.serverOrigin}$url';
    return ClipOval(
      child: Image.network(
        fullUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback,
        loadingBuilder: (context, child, progress) => progress == null ? child : _fallback,
      ),
    );
  }
}
