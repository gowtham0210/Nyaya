import 'dart:math' as math;

import 'package:flutter/material.dart';

const _ivory = Color(0xFFFBF7F1);
const _waveBeige = Color(0xFFF1E5D7);
const _waveHighlight = Color(0xFFFFFFFF);
const _gold = Color(0xFFC99A45);
const _dotGold = Color(0xFFE8D4B8);
const _progressTrack = Color(0xFFE9DED0);
const _templeAsset = 'assets/backgrounds/temple_bg.png';
const _logoAsset = 'assets/branding/logo_mark.png';
const _wordmarkAsset = 'assets/branding/wordmark.png';
const _bookAsset = 'assets/icons/book_icon.png';
const _starAsset = 'assets/icons/star.png';

class SplashPage extends StatelessWidget {
  const SplashPage({
    super.key,
    this.progress = 0.33,
    this.isAwaitingTapToContinue = false,
    this.onTap,
  });

  final double progress;
  final bool isAwaitingTapToContinue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    final isReadyToContinue = isAwaitingTapToContinue || progress >= 1;

    final logoWidth = _clamp(width * 0.42, 156, 190);
    final logoHeight = _clamp(logoWidth * 0.80, 124, 152);
    final wordmarkWidth = _clamp(width * 0.67, 258, 308);
    final wordmarkHeight = _clamp(wordmarkWidth * 0.21, 52, 66);
    final dividerWidth = _clamp(width * 0.60, 220, 252);
    final taglineSize = _clamp(width * 0.034, 12, 14);
    final taglineSpacing = _clamp(width * 0.016, 4.8, 6.6);
    final bookWidth = _clamp(width * 0.30, 110, 130);
    final bookHeight = bookWidth * 0.92;
    final progressWidth = _clamp(width * 0.44, 158, 172);
    final progressHeight = _clamp(height * 0.0052, 4, 5);
    final topSpacer = _clamp(height * 0.18, 118, 166);

    return Scaffold(
      backgroundColor: _ivory,
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  key: ValueKey('splash.wave'),
                  painter: _SplashBackdropPainter(),
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('splash.temple'),
              right: -width * 0.50,
              top: height * 0.05,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.14,
                  child: Image.asset(
                    _templeAsset,
                    width: width * 0.92,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('splash.dots.top'),
              left: width * 0.02,
              top: height * 0.07,
              child: IgnorePointer(
                child: _DotPatternDecoration(
                  width: width * 0.14,
                  height: width * 0.11,
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('splash.star.top'),
              right: width * 0.16,
              top: height * 0.125,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.95,
                  child: Image.asset(
                    _starAsset,
                    width: _clamp(width * 0.22, 90, 115),
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('splash.star.bottom'),
              right: width * 0.11,
              bottom: height * 0.13,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.94,
                  child: Image.asset(
                    _starAsset,
                    width: _clamp(width * 0.06, 18, 22),
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('splash.dots.bottom'),
              right: width * 0.08,
              bottom: height * 0.055,
              child: IgnorePointer(
                child: _DotPatternDecoration(
                  width: width * 0.14,
                  height: width * 0.11,
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: Column(
                    children: [
                      SizedBox(height: topSpacer),
                      Column(
                        key: const ValueKey('splash.screen'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Semantics(
                            container: true,
                            label: 'Nyaya splash screen',
                            hint: isReadyToContinue ? 'Tap to continue' : null,
                            child: ExcludeSemantics(
                              child: Column(
                                key: const ValueKey('splash.brand'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    key: const ValueKey('splash.logo'),
                                    width: logoWidth,
                                    height: logoHeight,
                                    child: Image.asset(
                                      _logoAsset,
                                      fit: BoxFit.contain,
                                      excludeFromSemantics: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: _clamp(height * 0.006, 4, 8),
                                  ),
                                  SizedBox(
                                    key: const ValueKey('splash.wordmark'),
                                    width: wordmarkWidth,
                                    height: wordmarkHeight,
                                    child: Image.asset(
                                      _wordmarkAsset,
                                      fit: BoxFit.contain,
                                      excludeFromSemantics: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: _clamp(height * 0.015, 10, 16),
                                  ),
                                  SizedBox(
                                    key: const ValueKey('splash.divider'),
                                    width: dividerWidth,
                                    child: const _SplashDivider(),
                                  ),
                                  SizedBox(
                                    height: _clamp(height * 0.015, 10, 16),
                                  ),
                                  Text(
                                    'LAW BASED QUIZ APP',
                                    key: const ValueKey('splash.tagline'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: _gold,
                                          fontSize: taglineSize,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: taglineSpacing,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: _clamp(height * 0.05, 34, 44)),
                          SizedBox(
                            key: const ValueKey('splash.book'),
                            width: bookWidth,
                            height: bookHeight,
                            child: Transform.scale(
                              scale: 1.14,
                              child: Image.asset(
                                _bookAsset,
                                fit: BoxFit.contain,
                                excludeFromSemantics: true,
                              ),
                            ),
                          ),
                          SizedBox(height: _clamp(height * 0.034, 22, 28)),
                          Semantics(
                            key: const ValueKey('splash.loading_semantics'),
                            container: true,
                            label: 'Loading Nyaya',
                            value: '${(progress * 100).round()} percent',
                            child: ExcludeSemantics(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: SizedBox(
                                  width: progressWidth,
                                  height: progressHeight,
                                  child: LinearProgressIndicator(
                                    key: const ValueKey('splash.progress'),
                                    value: progress.clamp(0.0, 1.0),
                                    backgroundColor: _progressTrack,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          _gold,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !isReadyToContinue,
                child: ExcludeSemantics(
                  excluding: !isReadyToContinue,
                  child: Semantics(
                    button: true,
                    label: 'Tap to continue',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: const ValueKey('splash.tap_target'),
                        onTap: onTap,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashDivider extends StatelessWidget {
  const _SplashDivider();

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
                color: _gold,
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

class _DotPatternDecoration extends StatelessWidget {
  const _DotPatternDecoration({required this.width, required this.height});

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
      ..color = _dotGold.withValues(alpha: 0.72)
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

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      decoration: BoxDecoration(
        color: _gold,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SplashBackdropPainter extends CustomPainter {
  const _SplashBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final topGlowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              _waveBeige.withValues(alpha: 0.30),
              _waveBeige.withValues(alpha: 0),
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
      ..shader =
          RadialGradient(
            colors: [
              _waveBeige.withValues(alpha: 0.34),
              _waveBeige.withValues(alpha: 0),
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
      ..color = _waveBeige.withValues(alpha: 0.82)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final beigePath = Path()
      ..moveTo(0, size.height * 0.875)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.848,
        size.width * 0.38,
        size.height * 0.934,
        size.width * 0.58,
        size.height * 0.904,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.874,
        size.width * 0.92,
        size.height * 0.79,
        size.width * 1.04,
        size.height * 0.69,
      )
      ..lineTo(size.width * 1.04, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(beigePath, beigePaint);

    final highlightPaint = Paint()
      ..color = _waveHighlight.withValues(alpha: 0.62)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.015
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final highlightPath = Path()
      ..moveTo(-size.width * 0.02, size.height * 0.86)
      ..cubicTo(
        size.width * 0.17,
        size.height * 0.835,
        size.width * 0.37,
        size.height * 0.914,
        size.width * 0.58,
        size.height * 0.885,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.856,
        size.width * 0.92,
        size.height * 0.775,
        size.width * 1.02,
        size.height * 0.698,
      );

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double _clamp(double value, double min, double max) {
  return value.clamp(min, max).toDouble();
}
