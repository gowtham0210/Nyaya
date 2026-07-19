import 'dart:math' as math;
import 'package:flutter/material.dart';

const ivory = Color(0xFFFBF7F1);
const waveBeige = Color(0xFFF1E5D7);
const waveHighlight = Color(0xFFFFFFFF);
const gold = Color(0xFFC89B3C);
const dotGold = Color(0xFFE8D4B8);
const progressTrack = Color(0xFFE9DED0);
const navy = Color(0xFF1A2C3D);
const bodyGrey = Color(0xFF4A5568);

const logoAsset = 'assets/branding/logo_mark.png';
const wordmarkAsset = 'assets/branding/wordmark.png';
const starAsset = 'assets/icons/star.png';

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    final logoWidth = _clamp(width * 0.42, 156, 190);
    final logoHeight = _clamp(logoWidth * 0.80, 124, 152);
    final wordmarkWidth = _clamp(width * 0.67, 258, 308);
    final wordmarkHeight = _clamp(wordmarkWidth * 0.21, 52, 66);
    final dividerWidth = _clamp(width * 0.60, 220, 252);
    final taglineSize = _clamp(width * 0.034, 12, 14);
    final taglineSpacing = _clamp(width * 0.016, 4.8, 6.6);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: logoWidth,
          height: logoHeight,
          child: Image.asset(
            logoAsset,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ),
        SizedBox(height: _clamp(height * 0.006, 4, 8)),
        SizedBox(
          width: wordmarkWidth,
          height: wordmarkHeight,
          child: Image.asset(
            wordmarkAsset,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: dividerWidth,
          child: const NyayaDivider(),
        ),
        SizedBox(height: 8),
        Text(
          'LAW BASED QUIZ APP',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: gold,
                fontSize: taglineSize,
                fontWeight: FontWeight.bold,
                letterSpacing: taglineSpacing,
              ),
        ),
      ],
    );
  }
}

class NyayaDivider extends StatelessWidget {
  const NyayaDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _DividerLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(1.2),
              ),
            ),
          ),
        ),
        const Expanded(child: _DividerLine()),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      decoration: BoxDecoration(
        color: gold,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

/// A decorative divider with an outlined (stroke) diamond icon in the center.
/// Used below headings on onboarding content screens.
class ContentDivider extends StatelessWidget {
  const ContentDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _DividerLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                border: Border.all(color: gold, width: 1.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const Expanded(child: _DividerLine()),
      ],
    );
  }
}

class DotPattern extends StatelessWidget {
  const DotPattern({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _DotPatternPainter()),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotGold.withValues(alpha: 0.72)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    const columns = 5;
    const rows = 5;
    final spacingX = size.width / (columns + 1);
    final spacingY = size.height / (rows + 1);
    final radius = size.shortestSide * 0.035;

    for (var row = 1; row <= rows; row++) {
      for (var column = 1; column <= columns; column++) {
        canvas.drawCircle(
          Offset(spacingX * column, spacingY * row),
          radius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BackgroundWave extends StatelessWidget {
  const BackgroundWave({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: CustomPaint(
        painter: _SplashBackdropPainter(),
      ),
    );
  }
}

class _SplashBackdropPainter extends CustomPainter {
  const _SplashBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final topGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          waveBeige.withValues(alpha: 0.30),
          waveBeige.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.02, size.height * 0.03),
          radius: size.width * 0.25,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.02, size.height * 0.03),
      size.width * 0.25,
      topGlowPaint,
    );

    final bottomGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          waveBeige.withValues(alpha: 0.34),
          waveBeige.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.02, size.height * 1.02),
          radius: size.width * 0.34,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.02, size.height * 1.02),
      size.width * 0.34,
      bottomGlowPaint,
    );

    final beigePaint = Paint()
      ..color = waveBeige.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final beigePath = Path()
      ..moveTo(0, size.height * 0.975)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.948,
        size.width * 0.38,
        size.height * 1.034,
        size.width * 0.58,
        size.height * 1.004,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.974,
        size.width * 0.92,
        size.height * 0.89,
        size.width * 1.04,
        size.height * 0.79,
      )
      ..lineTo(size.width * 1.04, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(beigePath, beigePaint);

    final highlightPaint = Paint()
      ..color = waveHighlight.withValues(alpha: 0.62)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.015
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final highlightPath = Path()
      ..moveTo(-size.width * 0.02, size.height * 0.96)
      ..cubicTo(
        size.width * 0.17,
        size.height * 0.935,
        size.width * 0.37,
        size.height * 1.014,
        size.width * 0.58,
        size.height * 0.985,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.956,
        size.width * 0.92,
        size.height * 0.875,
        size.width * 1.02,
        size.height * 0.798,
      );

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double _clamp(double value, double min, double max) {
  return value.clamp(min, max).toDouble();
}
