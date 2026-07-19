import 'package:flutter/material.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';

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

    final bookWidth = _clamp(width * 0.30, 110, 130);
    final bookHeight = bookWidth * 0.92;
    final progressWidth = _clamp(width * 0.44, 158, 172);
    final progressHeight = _clamp(height * 0.0052, 4, 5);
    final topSpacer = _clamp(height * 0.18, 118, 166);

    const templeAsset = 'assets/backgrounds/temple_bg.png';
    const bookAsset = 'assets/icons/book_icon.png';
    const starAsset = 'assets/icons/star.png';

    return Scaffold(
      backgroundColor: ivory,
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(
              child: BackgroundWave(),
            ),
            Positioned(
              key: const ValueKey('splash.temple'),
              right: -width * 0.50,
              top: height * 0.05,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.14,
                  child: Image.asset(
                    templeAsset,
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
                child: DotPattern(
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
                    starAsset,
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
                    starAsset,
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
                child: DotPattern(
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
                            child: const ExcludeSemantics(
                              child: BrandLockup(
                                key: ValueKey('splash.brand'),
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
                                bookAsset,
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
                                    backgroundColor: progressTrack,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          gold,
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

double _clamp(double value, double min, double max) {
  return value.clamp(min, max).toDouble();
}
