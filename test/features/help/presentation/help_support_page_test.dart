import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/help/data/support_repository.dart';
import 'package:nyaya/features/help/presentation/help_support_page.dart';
import 'package:nyaya/features/help/presentation/support_view_model.dart';

import '../../../support/localized_app.dart';
import '../../../support/support_backend.dart';

void main() {
  late FakeSupportBackend backend;

  Future<void> pumpPage(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    final viewModel = SupportViewModel(
      repository: SupportRepository(backend.client),
    );
    addTearDown(viewModel.dispose);
    await pumpLocalized(
      tester,
      HelpSupportPage(viewModel: viewModel),
      locale: locale,
    );
  }

  Finder field(String name) => find.byKey(ValueKey('support.$name'));

  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(
      target,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  setUp(() => backend = FakeSupportBackend());

  testWidgets('lists past requests with status and a localized date', (
    tester,
  ) async {
    backend.requests.add({
      'id': 1,
      'subject': 'OTP never arrives',
      'message': 'I tried three times.',
      'status': 'resolved',
      'createdAt': '2026-09-20T10:00:00.000Z',
    });
    await pumpPage(tester);
    await scrollTo(tester, find.text('OTP never arrives'));

    expect(find.text('Resolved'), findsOneWidget);
    expect(find.text('Sep 20, 2026'), findsOneWidget);
  });

  testWidgets('no requests shows the empty message', (tester) async {
    await pumpPage(tester);
    await scrollTo(tester, find.text("You haven't sent any requests yet."));

    expect(find.text("You haven't sent any requests yet."), findsOneWidget);
  });

  testWidgets('the form validates subject and message', (tester) async {
    await pumpPage(tester);

    await tester.enterText(field('message'), 'short');
    await tester.tap(field('send'));
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Please write at least 10 characters'), findsOneWidget);
    expect(backend.posts, 0);
  });

  testWidgets('sending confirms, clears the form and lists it', (tester) async {
    await pumpPage(tester);

    await tester.enterText(field('subject'), 'Streak reset');
    await tester.enterText(field('message'), 'My streak went back to zero.');
    await tester.tap(field('send'));
    await tester.pumpAndSettle();

    expect(backend.posts, 1);
    expect(find.text('Your request has been sent.'), findsOneWidget);
    expect(
      tester.widget<TextFormField>(field('subject')).controller!.text,
      isEmpty,
    );
    await scrollTo(tester, find.text('Streak reset'));
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('a failed send keeps the text and says why', (tester) async {
    await pumpPage(tester);
    backend.online = false;

    await tester.enterText(field('subject'), 'Streak reset');
    await tester.enterText(field('message'), 'My streak went back to zero.');
    await tester.tap(field('send'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Can't reach the Nyaya server. Check your connection and try again.",
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<TextFormField>(field('subject')).controller!.text,
      'Streak reset',
    );
  });

  testWidgets('strings are in Hindi', (tester) async {
    await pumpPage(tester, locale: const Locale('hi'));

    expect(find.text('अनुरोध भेजें'), findsOneWidget);
  });

  testWidgets('a failed list shows Retry, which reloads', (tester) async {
    backend.online = false;
    await pumpPage(tester);
    await scrollTo(tester, find.byKey(const ValueKey('loadState.retry')));

    backend.online = true;
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text("You haven't sent any requests yet."));
    expect(find.text("You haven't sent any requests yet."), findsOneWidget);
  });

  testWidgets('long messages wrap and fit large text', (tester) async {
    final long = List.filled(
      20,
      'The OTP never arrives on my phone.',
    ).join(' ');
    backend.requests.add({
      'id': 1,
      'subject': 'OTP',
      'message': long,
      'status': 'open',
      'createdAt': '2026-09-20T10:00:00.000Z',
    });
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpPage(tester);
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text(long));

    expect(tester.takeException(), isNull);
    expect(tester.widget<Text>(find.text(long)).maxLines, isNull);
  });
}
