import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';

import '../../../support/fake_backend.dart';

void main() {
  test('AC-001 maps updates newest first; a missing source is null', () async {
    final repository = LegalUpdatesRepository(
      fakeBackend({
        '/legal-updates': {
          'items': [
            {
              'id': 1,
              'category': 'Legislation',
              'title': 'Older act',
              'summary': 'Passed last month.',
              'updateDate': '2026-08-01',
              'source': 'Gazette of India',
              'imageUrl': null,
            },
            {
              'id': 2,
              'category': 'Judgements',
              'title': 'Newer ruling',
              'summary': 'Decided this week.',
              'updateDate': '2026-09-20',
            },
          ],
        },
      }),
    );

    final updates = await repository.fetchUpdates();

    expect(updates.map((u) => u.title), ['Newer ruling', 'Older act']);
    expect(updates.first.id, 2);
    expect(updates.first.category, 'Judgements');
    expect(updates.first.summary, 'Decided this week.');
    expect(updates.first.date, DateTime(2026, 9, 20));
    expect(updates.first.source, isNull);
    expect(updates.last.source, 'Gazette of India');
  });

  test('AC-001 an unparseable date keeps its raw text', () async {
    final repository = LegalUpdatesRepository(
      fakeBackend({
        '/legal-updates': {
          'items': [
            {
              'id': 3,
              'category': 'Notices',
              'title': 'Undated notice',
              'summary': 'No date.',
              'updateDate': 'soon',
            },
          ],
        },
      }),
    );

    final update = (await repository.fetchUpdates()).single;

    expect(update.date, isNull);
    expect(update.rawDate, 'soon');
  });
}
