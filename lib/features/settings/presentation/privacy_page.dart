import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import 'privacy_view_model.dart';
import '../../../core/presentation/widgets/detail_scaffold.dart';

/// Privacy & security (spec 030): active sessions and logging out of every
/// device. Accounts use phone + OTP, so there's no password to change.
class PrivacyPage extends StatefulWidget {
  const PrivacyPage({
    super.key,
    required this.viewModel,
    required this.onSignedOut,
  });

  final PrivacyViewModel viewModel;

  /// Called after every session ended, even if the page has closed; the
  /// app returns to sign-in.
  final Future<void> Function() onSignedOut;

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  Future<void> _logoutAll() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.privacyLogoutAll),
        content: Text(l10n.privacyLogoutAllConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            key: const ValueKey('privacy.logoutAll.confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: brandDanger),
            child: Text(l10n.profileLogout),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    if (await widget.viewModel.logoutAll()) {
      await widget.onSignedOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;
        final error = viewModel.logoutError;
        return DetailScaffold(
          title: l10n.profilePrivacy,
          children: [
            DetailHeading(l10n.privacySessionsTitle),
            DetailCard(
              children: [
                ListTile(
                  key: const ValueKey('privacy.sessions'),
                  leading: const Icon(Icons.devices_rounded),
                  title: Text(l10n.privacySessionsBody),
                  trailing: _SessionCount(
                    state: viewModel.state,
                    onRetry: viewModel.load,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DetailCard(
              children: [
                ListTile(
                  key: const ValueKey('privacy.logoutAll'),
                  enabled: !viewModel.loggingOut,
                  leading: const Icon(Icons.logout_rounded, color: brandDanger),
                  title: Text(
                    l10n.privacyLogoutAll,
                    style: const TextStyle(
                      color: brandDanger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: _logoutAll,
                ),
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(
                failureMessage(l10n, error),
                style: const TextStyle(color: brandDanger, height: 1.4),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  size: 18,
                  color: brandSupportText,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.privacyNoPassword,
                    style: const TextStyle(
                      color: brandSupportText,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// The session count, a small spinner while loading, or a retry button.
class _SessionCount extends StatelessWidget {
  const _SessionCount({required this.state, required this.onRetry});

  final LoadState<int> state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      Loaded(:final data) => Text(
        '$data',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: brandNavy,
        ),
      ),
      Failed() => IconButton(
        key: const ValueKey('loadState.retry'),
        tooltip: context.l10n.commonRetry,
        icon: const Icon(Icons.refresh_rounded),
        onPressed: onRetry,
      ),
      _ => const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    };
  }
}
