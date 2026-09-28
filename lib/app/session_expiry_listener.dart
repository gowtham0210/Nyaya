import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Runs [onExpired] when [sessionExpired] changes, i.e. when the API client
/// gives up on refreshing the backend session. Signals that arrive while a
/// previous [onExpired] is still running (parallel 401s) are ignored.
class SessionExpiryListener extends StatefulWidget {
  const SessionExpiryListener({
    super.key,
    required this.sessionExpired,
    required this.onExpired,
    required this.child,
  });

  final ValueListenable<int> sessionExpired;
  final FutureOr<void> Function(BuildContext context) onExpired;
  final Widget child;

  @override
  State<SessionExpiryListener> createState() => _SessionExpiryListenerState();
}

class _SessionExpiryListenerState extends State<SessionExpiryListener> {
  var _handling = false;

  @override
  void initState() {
    super.initState();
    widget.sessionExpired.addListener(_handleExpiry);
  }

  @override
  void didUpdateWidget(SessionExpiryListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessionExpired != widget.sessionExpired) {
      oldWidget.sessionExpired.removeListener(_handleExpiry);
      widget.sessionExpired.addListener(_handleExpiry);
    }
  }

  @override
  void dispose() {
    widget.sessionExpired.removeListener(_handleExpiry);
    super.dispose();
  }

  Future<void> _handleExpiry() async {
    if (!mounted || _handling) {
      return;
    }
    _handling = true;
    try {
      await widget.onExpired(context);
    } finally {
      _handling = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
