import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_page.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';

const _longSummary =
    'The court held that the right to privacy covers digital records. '
    'It set out a three-part test for any state access, asked for a '
    'reasoned order in each case, and told lower courts to apply the '
    'test to all pending matters from this month.';

void main() {
  Future<void> pumpList(WidgetTester tester, {String? imageUrl}) async {
    final viewModel = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(
        fakeBackend({
          '/legal-updates': {
            'items': [
              {
                'id': 7,
                'category': 'Judgements',
                'title': 'Privacy ruling',
                'summary': _longSummary,
                'updateDate': '2026-09-20',
                'source': 'Supreme Court',
                'imageUrl': imageUrl,
              },
            ],
          },
        }),
      ),
    );
    addTearDown(viewModel.dispose);
    await viewModel.load();
    await pumpLocalized(
      tester,
      LegalUpdatesPage(viewModel: viewModel),
      locale: const Locale('en'),
    );
  }

  Future<void> openCard(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('legalUpdate.card.7')));
    await tester.pumpAndSettle();
  }

  testWidgets('047 AC-002 tapping a card shows the whole update', (
    tester,
  ) async {
    await pumpList(tester, imageUrl: 'https://cdn.example.com/a.png');
    await openCard(tester);

    expect(find.byKey(const ValueKey('legalUpdateDetail.scroll')), findsOne);
    final summary = tester.widget<Text>(find.text(_longSummary));
    expect(summary.maxLines, isNull);
    expect(find.text('Privacy ruling'), findsOneWidget);
    expect(find.text('Supreme Court'), findsOneWidget);
    expect(find.byKey(const ValueKey('legalUpdateDetail.image')), findsOne);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('legalUpdates.list')), findsOne);
  });

  testWidgets('047 AC-003 the image opens full screen and closes', (
    tester,
  ) async {
    await pumpList(tester, imageUrl: 'https://cdn.example.com/a.png');
    await openCard(tester);

    expect(find.bySemanticsLabel('View image'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('legalUpdateDetail.image')));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('legalUpdateDetail.viewer.close')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
    expect(find.text(_longSummary), findsOneWidget);
  });

  testWidgets('047 AC-004 no image shows text only', (tester) async {
    await pumpList(tester);
    await openCard(tester);

    expect(find.byKey(const ValueKey('legalUpdateDetail.image')), findsNothing);
    expect(find.text(_longSummary), findsOneWidget);
  });
}
