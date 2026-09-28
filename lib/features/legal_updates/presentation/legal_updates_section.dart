import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import 'legal_updates_view_model.dart';
import 'widgets/legal_update_card.dart';

/// Home's latest legal updates (spec 020). Its load states render in
/// place, so the rest of Home never waits on it.
class LegalUpdatesSection extends StatelessWidget {
  const LegalUpdatesSection({super.key, required this.viewModel});

  /// Updates shown on Home; the rest are on the see-all list.
  static const homeCount = 3;

  final LegalUpdatesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => LoadStateView<List<LegalUpdate>>(
        key: const ValueKey('home.legalUpdates'),
        state: viewModel.state,
        onRetry: viewModel.load,
        emptyMessage: context.l10n.legalUpdatesEmpty,
        emptyIcon: Icons.gavel_rounded,
        builder: (context, updates) => Column(
          children: [
            for (final (index, update) in updates.take(homeCount).indexed) ...[
              if (index > 0) const SizedBox(height: 12),
              LegalUpdateCard(update: update),
            ],
          ],
        ),
      ),
    );
  }
}
