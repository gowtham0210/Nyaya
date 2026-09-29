import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/nyaya_widgets.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 20 : 6,
          decoration: BoxDecoration(
            color: isActive ? gold : waveBeige,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
