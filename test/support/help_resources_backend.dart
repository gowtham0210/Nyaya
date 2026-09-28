/// Canned `/help-resources` routes: two states, two categories, and
/// resources for Tamil Nadu + women's safety.
Map<String, Object> helpResourcesRoutes({List<Object>? resources}) => {
  '/help-resources/states': {
    'items': [
      {'code': 'TN', 'name': 'Tamil Nadu'},
      {'code': 'KA', 'name': 'Karnataka'},
    ],
  },
  '/help-resources/categories': {
    'items': [
      {'slug': 'women-safety', 'name': "Women's safety"},
      {'slug': 'legal-aid', 'name': 'Free legal aid'},
    ],
  },
  '/help-resources': {
    'items':
        resources ??
        [
          {
            'id': 1,
            'resourceName': 'Women Helpline',
            'isNational': true,
            'tollFree': '181',
            'phoneNumber': null,
            'email': 'help@wcd.example.in',
            'websiteUrl': 'https://wcd.example.in',
            'serviceHours': '24x7',
            'sourceName': 'Ministry of WCD',
            'sourceUrl': 'https://wcd.example.in/helplines',
            'verificationStatus': 'verified',
            'lastVerifiedAt': '2026-09-01T00:00:00.000Z',
          },
          {
            'id': 2,
            'resourceName': 'TN State Commission for Women',
            'isNational': false,
            'phoneNumber': '044-2855 1155',
            'sourceName': 'Govt of Tamil Nadu',
            'sourceUrl': 'https://tn.example.in',
            'verificationStatus': 'pending',
          },
        ],
  },
};
