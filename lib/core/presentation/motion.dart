import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The app's shared motion vocabulary.
///
/// Everything animated in Nyaya pulls its duration and curve from here, so
/// screens feel like one app rather than a set of separately-tuned widgets.
/// The scale is deliberately short — motion you feel rather than notice —
/// because these are screens people revisit many times a day.
///
/// Every helper in this file honours the platform's "reduce motion"
/// accessibility setting: when it is on, animations resolve instantly
/// instead of being skipped, so nothing ever fails to appear.
class Motion {
  Motion._();

  /// Colour and small state changes — an option locking in, a chip toggling.
  static const fast = Duration(milliseconds: 140);

  /// The default: entrances, cards settling, most transitions.
  static const normal = Duration(milliseconds: 240);

  /// Longer moves — a page arriving, a ring filling.
  static const slow = Duration(milliseconds: 340);

  /// Counting a number up, which needs longer to be legible. Long enough to
  /// read the digits move, short enough not to hold up the screen.
  static const counter = Duration(milliseconds: 520);

  /// Decelerating curve for things entering or settling.
  static const enter = Curves.easeOutCubic;

  /// Symmetric curve for things changing in place.
  static const standard = Curves.easeInOut;

  /// How far a fading-in element travels, in logical pixels.
  static const rise = 16.0;

  /// The delay between consecutive items in a staggered list. Kept well
  /// under [normal] so a list of five still finishes as one gesture rather
  /// than a queue.
  static const stagger = Duration(milliseconds: 40);

  /// Whether the viewer has asked the OS to minimise animation.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [duration], or zero when the viewer has asked for reduced motion.
  static Duration duration(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;

  /// A short tick for a committing tap — picking an answer, changing tab.
  static void tick() => HapticFeedback.selectionClick();
}

/// Fades [child] in while it rises a little into place.
///
/// Used for content that appears after a screen is already on-screen — a
/// list settling in, stats arriving from the backend — so the change reads
/// as arrival rather than a flicker.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = Motion.normal,
    this.offset = Motion.rise,
  });

  final Widget child;

  /// Staggers this item behind the ones before it.
  final Duration delay;
  final Duration duration;

  /// How far the child rises, in logical pixels. Negative values drop it in
  /// from above instead.
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  // The stagger is an Interval on the curve rather than a delayed start, so
  // there is one ticker and no pending timer to leak or to hang a test.
  late final Duration _total = widget.delay + widget.duration;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _total,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _total.inMicroseconds == 0
          ? 0.0
          : widget.delay.inMicroseconds / _total.inMicroseconds,
      1,
      curve: Motion.enter,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduced(context)) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Transform.translate(
          offset: Offset(0, widget.offset * (1 - _animation.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Shrinks [child] slightly while it is held down.
///
/// Cards in this app are large tap targets with no ripple of their own, so
/// without this a tap gives no feedback until the next screen appears.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      child: AnimatedScale(
        scale: _pressed && !Motion.reduced(context) ? 0.97 : 1.0,
        duration: Motion.fast,
        curve: Motion.standard,
        child: widget.child,
      ),
    );
  }
}

/// Counts from zero up to [value] when it first appears, and animates
/// between values on later changes.
///
/// [builder] renders the in-between value, so callers keep full control of
/// formatting — a bare number, a percentage, a fraction.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.value,
    required this.builder,
    this.duration = Motion.counter,
  });

  final double value;
  final Widget Function(BuildContext context, double value) builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: Motion.duration(context, duration),
      curve: Motion.enter,
      builder: (context, animated, _) => builder(context, animated),
    );
  }
}

/// A page route that fades and lifts its page into view.
///
/// Flutter's default Android transition slides the whole page up from the
/// bottom, which is heavy for a quiz that pushes and pops constantly. This
/// is the same idea, much shorter and much smaller.
class FadeThroughPageRoute<T> extends PageRouteBuilder<T> {
  FadeThroughPageRoute({required this.builder, super.settings})
    : super(
        transitionDuration: Motion.normal,
        reverseTransitionDuration: Motion.fast,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, secondary, child) {
          if (Motion.reduced(context)) {
            return child;
          }
          final curved = CurvedAnimation(
            parent: animation,
            curve: Motion.enter,
            reverseCurve: Curves.easeIn,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );

  final WidgetBuilder builder;
}
