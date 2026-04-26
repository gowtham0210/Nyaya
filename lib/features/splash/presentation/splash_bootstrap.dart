import 'package:flutter/material.dart';

import 'splash_page.dart';

class SplashBootstrap extends StatefulWidget {
  const SplashBootstrap({
    super.key,
    required this.child,
    this.splashDuration = const Duration(milliseconds: 1800),
  });

  final Widget child;
  final Duration splashDuration;

  @override
  State<SplashBootstrap> createState() => _SplashBootstrapState();
}

class _SplashBootstrapState extends State<SplashBootstrap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  var _showChild = false;
  var _awaitingTapToContinue = false;

  @override
  void initState() {
    super.initState();
    if (widget.splashDuration == Duration.zero) {
      _showChild = true;
      _progressController = AnimationController.unbounded(vsync: this);
      return;
    }

    _progressController = AnimationController(
      vsync: this,
      duration: widget.splashDuration,
    );
    _progressController.addStatusListener(_handleProgressStatus);
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController
      ..removeStatusListener(_handleProgressStatus)
      ..dispose();
    super.dispose();
  }

  void _handleProgressStatus(AnimationStatus status) {
    if (!mounted || status != AnimationStatus.completed) {
      return;
    }

    setState(() {
      // Temporary review mode: keep the splash visible until the user taps.
      _awaitingTapToContinue = true;
    });
  }

  void _showHome() {
    if (!mounted || _showChild) {
      return;
    }

    if (!_awaitingTapToContinue && _progressController.value < 1) {
      return;
    }

    setState(() {
      _showChild = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReadyToContinue =
        _awaitingTapToContinue || _progressController.value >= 1;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.015),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _showChild
          ? KeyedSubtree(
              key: const ValueKey('bootstrap.home'),
              child: widget.child,
            )
          : AnimatedBuilder(
              key: const ValueKey('bootstrap.splash.animation'),
              animation: _progressController,
              builder: (BuildContext context, Widget? child) {
                return SplashPage(
                  key: const ValueKey('bootstrap.splash'),
                  progress: isReadyToContinue
                      ? 1
                      : Tween<double>(
                          begin: 0.33,
                          end: 1,
                        ).transform(_progressController.value),
                  isAwaitingTapToContinue: isReadyToContinue,
                  onTap: _showHome,
                );
              },
            ),
    );
  }
}
