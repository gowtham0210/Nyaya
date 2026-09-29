import '../../home/presentation/home_view_model.dart';

/// A single quiz belonging to a category, shown on [CategoryContent].
///
/// Not yet populated for any category except Criminal & Evidence Law (which
/// bypasses this page and opens its quiz directly) — this model exists so
/// real quizzes can be added per category later without touching the page
/// or navigation wiring.
class CategoryQuizSummary {
  const CategoryQuizSummary({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.difficulty,
  });

  final String id;
  final String title;
  final int questionCount;
  final QuizDifficulty difficulty;
}

class CategoryContent {
  const CategoryContent({
    required this.description,
    this.articleContent = '',
    this.quizzes = const [],
  });

  final String description;

  /// A short, plain-language explanation of the topic, shown on the
  /// category detail page for "Click any topic to read more". Empty for
  /// categories that don't have one registered below.
  final String articleContent;

  final List<CategoryQuizSummary> quizzes;
}

const _fallbackDescription =
    'Explore quizzes and study material for this category.';

/// Content for each of Home's category ids. Categories without an entry
/// here, or with an empty `quizzes` list, render the page's empty state
/// instead of fabricated content.
const Map<String, CategoryContent> categoryContentById = {
  'constitutional_law': CategoryContent(
    description:
        'Fundamental rights, government structure, and constitutional '
        'provisions.',
    articleContent:
        'The supreme law defining government structure, powers, and every '
        "citizen's fundamental rights.",
  ),
  'criminal_evidence_law': CategoryContent(
    description:
        'Offences, criminal procedure, and rules of evidence under Indian '
        'law.',
    articleContent:
        'Defines crimes and their punishments, plus the procedures and '
        'evidence rules used to prosecute them.',
  ),
  'civil_general_law': CategoryContent(
    description: 'Contracts, torts, and general civil rights and obligations.',
    articleContent:
        'Governs non-criminal disputes like broken contracts, property '
        'issues, and negligence.',
  ),
  'marriage_family_law': CategoryContent(
    description: 'Marriage, divorce, custody, and family relations.',
    articleContent:
        'Covers marriage, divorce, custody, and inheritance within '
        'families.',
  ),
  'labor_industrial_law': CategoryContent(
    description:
        'Employment rights, industrial disputes, and workplace regulations.',
    articleContent:
        'Protects worker rights around wages, hours, safety, and '
        'workplace disputes.',
  ),
  'corporate_commercial_law': CategoryContent(
    description:
        'Company law, business contracts, and commercial transactions.',
    articleContent:
        'Rules for forming and running businesses, and the contracts '
        'they rely on.',
  ),
  'taxation_law': CategoryContent(
    description: 'Direct and indirect tax laws, compliance, and procedures.',
    articleContent:
        'Governs how income tax, GST, and other taxes are calculated, '
        'filed, and enforced.',
  ),
  'cyber_intellectual_property': CategoryContent(
    description:
        'Cyber law, data protection, patents, copyrights, and trademarks.',
    articleContent:
        'Covers online offences and data protection, plus rights over '
        'patents, copyrights, and trademarks.',
  ),
  'property_real_estate': CategoryContent(
    description: 'Property rights, real estate transactions, and land laws.',
    articleContent:
        'Governs ownership, transfer, and disputes over land and '
        'buildings.',
  ),
  'banking_financial_law': CategoryContent(
    description:
        'Banking regulations, financial transactions, and monetary law.',
    articleContent:
        'Regulates banks, loans, and financial institutions to keep the '
        'system stable.',
  ),
  'environmental_law': CategoryContent(
    description:
        'Environmental protection, compliance, and regulatory frameworks.',
    articleContent:
        'Protects natural resources and regulates pollution and land '
        'use.',
  ),
};

CategoryContent categoryContentFor(String categoryId) =>
    categoryContentById[categoryId] ??
    const CategoryContent(description: _fallbackDescription);
