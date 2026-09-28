import 'package:flutter/material.dart';

const _palette = [
  Color(0xFF11233B),
  Color(0xFFB9823A),
  Color(0xFF2F6FED),
  Color(0xFF1C9C90),
  Color(0xFF7C4DFF),
];

/// A learner's photo, or their initials on a colour picked from the name
/// when there's no photo or it can't load.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 72,
  });

  final String name;

  /// Absolute photo URL.
  final String? avatarUrl;
  final double size;

  /// Up to two initials, e.g. "AR" for "Asha Rao"; "?" for a blank name.
  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) {
      return '?';
    }
    return parts.take(2).map((p) => p.characters.first.toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl;
    final fallback = _Initials(name: name, size: size);
    if (url == null) {
      return fallback;
    }
    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => fallback,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : fallback,
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Code units, not hashCode, so the colour is stable across builds.
        color:
            _palette[name.codeUnits.fold(0, (a, b) => a + b) % _palette.length],
        shape: BoxShape.circle,
      ),
      child: ExcludeSemantics(
        child: Text(
          InitialsAvatar.initialsOf(name),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
