import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../onboarding/presentation/widgets/page_indicator.dart';
import 'goal_selection_view_model.dart';

const _selectedCardTint = Color(0xFFFDF6E9);
const _cardBorder = Color(0xFFECE5DB);
const _iconTileFill = Color(0xFFF7EAD2);
const _radioBorder = Color(0xFFB9C0CA);
const _templeAsset = 'assets/backgrounds/temple_bg.png';

class GoalSelectionPage extends StatefulWidget {
  const GoalSelectionPage({super.key, required this.onContinue, this.viewModel});

  final ValueChanged<String> onContinue;
  final GoalSelectionViewModel? viewModel;

  @override
  State<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  late final GoalSelectionViewModel _viewModel =
      widget.viewModel ?? GoalSelectionViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,
      body: Stack(
        children: [
          Positioned(
            right: -20,
            top: 120,
            child: ExcludeSemantics(
              child: Opacity(
                key: const ValueKey('goal.temple'),
                opacity: 0.12,
                child: Image.asset(_templeAsset, width: 220),
              ),
            ),
          ),
          const Positioned(
            left: 16,
            top: 80,
            child: ExcludeSemantics(
              child: DotPattern(width: 60, height: 60),
            ),
          ),
          Positioned(
            left: 60,
            top: 210,
            child: ExcludeSemantics(
              child: Opacity(
                key: const ValueKey('goal.star'),
                opacity: 0.95,
                child: Image.asset(starAsset, width: 20),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ExcludeSemantics(child: BackgroundWave()),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        key: const ValueKey('goal.back'),
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back, color: navy),
                        tooltip: 'Back',
                      ),
                      const PageIndicator(
                        key: ValueKey('goal.progress'),
                        count: 4,
                        currentIndex: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'What brings you',
                    key: const ValueKey('goal.heading.lead'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: navy,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    'to Nyaya?',
                    key: const ValueKey('goal.heading.accent'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: gold,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose your goal — you can change it anytime.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: bodyGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  for (final goal in _viewModel.goals) ...[
                    _GoalCard(
                      goal: goal,
                      selected: goal.id == _viewModel.selectedGoalId,
                      onTap: () => setState(() => _viewModel.select(goal.id)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      key: const ValueKey('goal.continue'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () =>
                          widget.onContinue(_viewModel.selectedGoalId),
                      child: const Text(
                        'CONTINUE',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You can switch goals later in Profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: bodyGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final GoalOption goal;
  final bool selected;
  final VoidCallback onTap;

  IconData get _iconData => switch (goal.icon) {
        GoalIconType.scales => Icons.balance,
        GoalIconType.trophy => Icons.emoji_events_outlined,
        GoalIconType.graduationCap => Icons.school_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      label: '${goal.title}. ${goal.description}',
      child: InkWell(
        key: ValueKey('goal.card.${goal.id}'),
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? _selectedCardTint : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? gold : _cardBorder,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _iconTileFill,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_iconData, color: navy, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: const TextStyle(color: bodyGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              selected
                  ? Container(
                      key: ValueKey('goal.radio.selected.${goal.id}'),
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  : Container(
                      key: ValueKey('goal.radio.unselected.${goal.id}'),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _radioBorder),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
