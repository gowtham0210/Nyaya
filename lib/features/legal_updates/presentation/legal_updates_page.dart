import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import 'legal_updates_view_model.dart';
import 'widgets/legal_update_card.dart';

const _pageBackground = Color(0xFFF8F6F2);
const _navy = Color(0xFF11233B);

/// All legal updates, opened from Home's "View All" (spec 020). Shares
/// Home's view model, so it shows what Home loaded without reloading.
class LegalUpdatesPage extends StatelessWidget {
  const LegalUpdatesPage({super.key, required this.viewModel});

  final LegalUpdatesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.legalUpdatesTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => LoadStateView<List<LegalUpdate>>(
          state: viewModel.state,
          onRetry: viewModel.load,
          emptyMessage: l10n.legalUpdatesEmpty,
          emptyIcon: Icons.gavel_rounded,
          builder: (context, updates) => ListView.separated(
            key: const ValueKey('legalUpdates.list'),
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            itemCount: updates.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                LegalUpdateCard(update: updates[index]),
          ),
        ),
      ),
    );
  }
}
