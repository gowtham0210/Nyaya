import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/session_expiry_listener.dart';

void main() {
  testWidgets('AC-007 each expiry signal runs the handler once', (
    tester,
  ) async {
    final expired = ValueNotifier<int>(0);
    addTearDown(expired.dispose);
    var handled = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: SessionExpiryListener(
          sessionExpired: expired,
          onExpired: (_) => handled++,
          child: const Text('shell'),
        ),
      ),
    );

    expect(handled, 0);
    expect(find.text('shell'), findsOneWidget);

    expired.value++;
    await tester.pump();
    expect(handled, 1);

    expired.value++;
    await tester.pump();
    expect(handled, 2);
  });

  testWidgets('AC-010 signals while an expiry is being handled are ignored', (
    tester,
  ) async {
    final expired = ValueNotifier<int>(0);
    addTearDown(expired.dispose);
    var handled = 0;
    final pending = Completer<void>();

    await tester.pumpWidget(
      MaterialApp(
        home: SessionExpiryListener(
          sessionExpired: expired,
          onExpired: (_) {
            handled++;
            return pending.future;
          },
          child: const Text('shell'),
        ),
      ),
    );

    // Three parallel requests fail with 401 at once.
    expired.value++;
    expired.value++;
    expired.value++;
    await tester.pump();
    expect(handled, 1);

    pending.complete();
    await tester.pump();
    expired.value++;
    await tester.pump();
    expect(handled, 2);
  });
}
