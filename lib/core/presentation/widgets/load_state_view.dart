import 'package:flutter/material.dart';

import '../../localization/l10n.dart';
import '../../network/api_client.dart';
import '../load_state.dart';
import 'nyaya_widgets.dart';

/// Renders a [LoadState]: a spinner, [builder]'s content, an empty message,
/// or a localized failure message with Retry.
class LoadStateView<T> extends StatelessWidget {
  const LoadStateView({
    super.key,
    required this.state,
    required this.builder,
    this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.onRetry,
  });

  final LoadState<T> state;
  final Widget Function(BuildContext context, T data) builder;

  /// Defaults to a generic "nothing here" message.
  final String? emptyMessage;
  final IconData emptyIcon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      Loading() => const Center(
        key: ValueKey('loadState.loading'),
        child: CircularProgressIndicator(color: gold),
      ),
      Loaded(:final data) => builder(context, data),
      Empty() => _StateMessage(
        key: const ValueKey('loadState.empty'),
        icon: emptyIcon,
        message: emptyMessage ?? context.l10n.emptyNothingHere,
      ),
      Failed(:final error) => _StateMessage(
        key: const ValueKey('loadState.error'),
        icon: error is ApiOfflineException
            ? Icons.cloud_off_rounded
            : Icons.error_outline_rounded,
        message: _failureMessage(context, error),
        onRetry: error is ApiUnauthorizedException ? null : onRetry,
      ),
    };
  }

  String _failureMessage(BuildContext context, Object error) {
    final l10n = context.l10n;
    return switch (error) {
      ApiOfflineException() => l10n.errorOffline,
      ApiUnauthorizedException() => l10n.errorSessionExpired,
      _ => l10n.errorGeneric,
    };
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    super.key,
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: bodyGrey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: bodyGrey,
              ),
            ),
            if (retry != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                key: const ValueKey('loadState.retry'),
                onPressed: retry,
                style: FilledButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                child: Text(context.l10n.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
