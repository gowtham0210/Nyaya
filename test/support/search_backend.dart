/// Routes for categories, articles and legal updates, for search tests.
Map<String, Object> searchRoutes() => {
  '/categories': {
    'items': [
      {'id': 1, 'name': 'Criminal Law', 'slug': 'criminal-law'},
      {'id': 2, 'name': 'Tax Law', 'slug': 'tax-law'},
    ],
  },
  '/categories/1/quizzes': {'items': []},
  '/categories/2/quizzes': {'items': []},
  '/articles': {
    'items': [
      {
        'id': 1,
        'part': 'III',
        'partTitle': 'Fundamental Rights',
        'title': 'Right to Equality',
        'articleRange': 'Articles 14–18',
        'description': 'Equality before law.',
        'whatItMeans': 'Everyone is equal.',
      },
      {
        'id': 2,
        'part': 'III',
        'partTitle': 'Fundamental Rights',
        'title': 'Protection against arrest',
        'articleRange': 'Article 22',
        'description': 'Rights under criminal arrest.',
      },
    ],
  },
  '/legal-updates': {
    'items': [
      {
        'id': 7,
        'category': 'Judgements',
        'title': 'Bail is the rule in criminal cases',
        'summary': 'Supreme Court on bail.',
        'updateDate': '2026-09-01',
      },
    ],
  },
};
