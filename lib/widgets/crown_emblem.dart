import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Gold crown flanked by laurel branches — the decorative emblem used above
/// the "Leaderboard" heading, matching the reference's crown-and-laurel
/// mark. Drawn as vector shapes so it stays crisp at any size.
class CrownEmblem extends StatelessWidget {
  const CrownEmblem({super.key, this.width = 100, this.height = 34});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _CrownEmblemPainter()),
    );
  }
}

class _CrownEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final gold = Paint()..color = AppColors.gold;

    _paintLaurel(canvas, Offset(w * 0.20, h * 0.78), w * 0.16, h, gold, flip: false);
    _paintLaurel(canvas, Offset(w * 0.80, h * 0.78), w * 0.16, h, gold, flip: true);
    _paintCrown(canvas, Offset(w * 0.5, 0), w * 0.15, h, gold);
  }

  void _paintCrown(Canvas canvas, Offset center, double armHalf, double h, Paint paint) {
    final baseY = h * 0.80;
    final bandH = h * 0.16;

    final path = Path()
      ..moveTo(center.dx - armHalf * 2, baseY)
      ..lineTo(center.dx - armHalf * 2, h * 0.42)
      ..lineTo(center.dx - armHalf, h * 0.62)
      ..lineTo(center.dx - armHalf * 0.5, h * 0.10)
      ..lineTo(center.dx, h * 0.40)
      ..lineTo(center.dx + armHalf * 0.5, h * 0.10)
      ..lineTo(center.dx + armHalf, h * 0.62)
      ..lineTo(center.dx + armHalf * 2, h * 0.42)
      ..lineTo(center.dx + armHalf * 2, baseY)
      ..close();
    canvas.drawPath(path, paint);

    // Ball tips.
    for (final dx in [-armHalf * 2, -armHalf * 0.5, 0.0, armHalf * 0.5, armHalf * 2]) {
      final y = dx == 0
          ? h * 0.10
          : (dx.abs() == armHalf * 0.5 ? h * 0.10 : h * 0.42);
      canvas.drawCircle(Offset(center.dx + dx, y - h * 0.02), h * 0.065, paint);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - armHalf * 2, baseY, armHalf * 4, bandH),
        Radius.circular(bandH * 0.3),
      ),
      paint,
    );
  }

  void _paintLaurel(Canvas canvas, Offset origin, double spread, double h, Paint paint, {required bool flip}) {
    final dir = flip ? -1.0 : 1.0;
    const leafCount = 4;
    final leafSize = h * 0.16;

    // A gentle stem arc from origin curving up and outward.
    final stemPath = Path()
      ..moveTo(origin.dx, origin.dy)
      ..quadraticBezierTo(
        origin.dx + dir * spread * 0.6,
        origin.dy - h * 0.25,
        origin.dx + dir * spread,
        origin.dy - h * 0.55,
      );
    canvas.drawPath(
      stemPath,
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    for (var i = 0; i < leafCount; i++) {
      final t = (i + 0.5) / leafCount;
      // Point roughly along the quadratic curve.
      final x = origin.dx + dir * spread * (1.2 * t - 0.2 * t * t);
      final y = origin.dy - h * 0.55 * t;
      final angle = dir * (-0.5 + t * 0.9);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: leafSize, height: leafSize * 0.48),
        paint,
      );
      canvas.restore();
    }

    // A small berry/leaf at the very base of the stem.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(origin.dx, origin.dy + h * 0.03), width: leafSize * 0.7, height: leafSize * 0.4),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CrownEmblemPainter oldDelegate) => false;
}
