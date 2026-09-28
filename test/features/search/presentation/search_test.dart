import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/presentation/widgets/nyaya_icon.dart';
import 'package:nyaya/features/articles/data/articles_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/search/presentation/search.dart';

CategoryData category(int id, String label) => CategoryData(
  id: id,
  slug: label.toLowerCase().replaceAll(' ', '-'),
  label: label,
  icon: HomeIconType.book,
  tintHex: 0,
  iconHex: 0,
);

const equality = Article(
  id: 1,
  part: 'III',
  partTitle: 'Fundamental Rights',
  title: 'Right to Equality',
  articleRange: 'Articles 14–18',
  description: 'Equality before law for every person.',
  keyFeatures: [],
);
const arrest = Article(
  id: 2,
  part: 'III',
  partTitle: 'Fundamental Rights',
  title: 'Protection against arrest',
  articleRange: 'Article 22',
  description: 'Rights of a person under criminal arrest.',
  keyFeatures: [],
);
const bailRuling = LegalUpdate(
  id: 7,
  category: 'Judgements',
  title: 'Bail is the rule in criminal cases',
  summary: 'Supreme Court on bail.',
  rawDate: '2026-09-01',
);

const taxReform = LegalUpdate(
  id: 8,
  category: 'Reforms',
  title: 'New tax slabs notified',
  summary: 'Income tax changes.',
  rawDate: '2026-09-02',
);

final sources = SearchSources(
  categories: [
    category(1, 'Criminal Law'),
    category(2, 'Tax Law'),
    category(3, 'आपराधिक कानून'),
  ],
  articles: [equality, arrest],
  legalUpdates: [bailRuling, taxReform],
);

void main() {
  test('blank query and no filters returns everything', () {
    final results = search(sources, const SearchQuery());

    expect(results.categories, hasLength(3));
    expect(results.articles, hasLength(2));
    expect(results.legalUpdates, hasLength(2));
    expect(results.isEmpty, isFalse);
  });

  test('text matches titles and descriptions, ignoring case', () {
    final results = search(sources, const SearchQuery(text: 'EQUALITY'));

    expect(results.articles.map((a) => a.article.id), [1]);
    expect(results.articles.single.number, 1);
    expect(results.categories, isEmpty);
    expect(results.legalUpdates, isEmpty);
  });

  test('content type narrows to one kind', () {
    final results = search(
      sources,
      const SearchQuery(types: {SearchContentType.legalUpdates}),
    );

    expect(results.categories, isEmpty);
    expect(results.articles, isEmpty);
    expect(results.legalUpdates, hasLength(2));
  });

  test('a category keeps itself and items that mention it', () {
    final results = search(sources, const SearchQuery(categoryIds: {1}));

    expect(results.categories.map((c) => c.label), ['Criminal Law']);
    // "criminal" appears in the arrest article and the bail ruling.
    expect(results.articles.map((a) => a.article.id), [2]);
    // Numbered as in the Articles tab.
    expect(results.articles.single.number, 2);
    expect(results.legalUpdates.map((u) => u.id), [7]);
  });

  test('text and filters combine; nothing matching is empty', () {
    final results = search(
      sources,
      const SearchQuery(text: 'tax', types: {SearchContentType.articles}),
    );

    expect(results.isEmpty, isTrue);
  });

  test('a query counts its active filters and clears in one step', () {
    const query = SearchQuery(
      text: 'bail',
      types: {SearchContentType.articles, SearchContentType.legalUpdates},
      categoryIds: {1},
    );

    expect(query.filterCount, 3);
    expect(query.clearFilters(), const SearchQuery(text: 'bail'));
    expect(query.clearFilters().filterCount, 0);
  });

  test('a short-named category still matches its word', () {
    final results = search(sources, const SearchQuery(categoryIds: {2}));

    expect(results.legalUpdates.map((u) => u.id), [8]);
    expect(results.articles, isEmpty);
  });

  test('a category in another script matches by its words', () {
    final results = search(sources, const SearchQuery(categoryIds: {3}));

    expect(results.categories.map((c) => c.id), [3]);
  });

  test('key words match whole words only', () {
    const copyright = Article(
      id: 9,
      part: 'X',
      partTitle: 'Other',
      title: 'Copyrights explained',
      articleRange: '',
      description: 'On copyrights.',
      keyFeatures: [],
    );
    final results = search(
      SearchSources(
        categories: [category(4, 'Fundamental Rights')],
        articles: const [copyright, equality],
      ),
      const SearchQuery(categoryIds: {4}),
    );

    // "Rights" appears in equality's part title, not as "copyrights".
    expect(results.articles.map((a) => a.article.id), [1]);
  });
}
