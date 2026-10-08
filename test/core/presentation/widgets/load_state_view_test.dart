import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/localization/l10n.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/core/presentation/widgets/load_state_view.dart';
import 'package:nyaya/core/presentation/widgets/nyaya_skeleton.dart';

void main() {
  Future<void> pumpView(
    WidgetTester tester,
    LoadState<String> state, {
    VoidCallback? onRetry,
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: LoadStateView<String>(
            state: state,
            onRetry: onRetry,
            emptyMessage: 'No categories yet.',
            builder: (context, data) => Text('data: $data'),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('AC-008 loading shows a skeleton (spec 039)', (tester) async {
    await pumpView(tester, const Loading());

    expect(find.byKey(const ValueKey('loadState.loading')), findsOneWidget);
    expect(find.byType(NyayaSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('AC-008 loaded shows the content', (tester) async {
    await pumpView(tester, const Loaded('ready'));

    expect(find.text('data: ready'), findsOneWidget);
  });

  testWidgets('AC-008 empty shows the empty message', (tester) async {
    await pumpView(tester, const Empty());

    expect(find.byKey(const ValueKey('loadState.empty')), findsOneWidget);
    expect(find.text('No categories yet.'), findsOneWidget);
  });

  testWidgets('AC-008 offline shows a localized message and Retry', (
    tester,
  ) async {
    var retried = 0;
    await pumpView(
      tester,
      const Failed(ApiOfflineException()),
      onRetry: () => retried++,
      locale: const Locale('ta'),
    );

    expect(
      find.text(
        'நியாயா சேவையகத்தை அடைய முடியவில்லை. இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    expect(retried, 1);
  });

  testWidgets('AC-008 other failures show the generic message', (tester) async {
    await pumpView(
      tester,
      const Failed(ApiServerException(500, 'Database down')),
      onRetry: () {},
    );

    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('Database down'), findsNothing);
  });

  testWidgets('AC-008 an ended session says so', (tester) async {
    await pumpView(tester, const Failed(ApiUnauthorizedException()));

    expect(
      find.text('Your session has ended. Please sign in again.'),
      findsOneWidget,
    );
  });
}
