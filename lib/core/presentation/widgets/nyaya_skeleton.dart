import 'package:flutter/material.dart';

import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_tokens.dart';

/// A soft, pulsing placeholder shown while content loads (spec 039), in
/// place of a spinner: it hints at the layout to come. Holds still when
/// the learner asked the OS to reduce motion.
class NyayaSkeleton extends StatefulWidget {
  const NyayaSkeleton({super.key, this.lines = 3});

  final int lines;

  @override
  State<NyayaSkeleton> createState() => _NyayaSkeletonState();
}

class _NyayaSkeletonState extends State<NyayaSkeleton>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.45,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (NyayaMotion.reduced(context)) {
      _pulse
        ..stop()
        ..value = 0.7;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      child: FadeTransition(
        opacity: _pulse,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: NyayaSpace.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < widget.lines; i++) ...[
                if (i > 0) const SizedBox(height: NyayaSpace.sm),
                FractionallySizedBox(
                  // Last line shorter, like a paragraph's end.
                  widthFactor: i == widget.lines - 1 ? 0.6 : 1 - i * 0.12,
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: NyayaColors.hairline,
                      borderRadius: BorderRadius.circular(NyayaRadii.xs),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
