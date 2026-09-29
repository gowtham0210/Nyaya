// Exports the app's bundled quiz content as JSON for the backend seeder.
//
// The 15 hardcoded question lists under `lib/features/quiz_question/data/`
// are the original source of truth for Nyaya's content. This script emits
// them in the shape the backend's seed script expects, so the database
// starts out holding exactly what the app used to ship offline.
//
//   dart run tool/export_quiz_seed.dart > quiz_seed.json
//
// Re-run it whenever the bundled lists change, then re-run the backend
// seeder — it upserts by slug, so existing quiz attempts survive.

import 'dart:convert';
import 'dart:io';

import 'package:nyaya/features/quiz_question/data/banking_financial_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/civil_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/constitutional_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/continue_learning_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/contract_act_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/corporate_commercial_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/criminal_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/cyber_ip_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/environmental_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/fundamental_rights_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/indian_penal_code_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/labor_industrial_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/marriage_family_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/property_real_estate_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/data/taxation_law_quiz_data.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';

/// Mirrors `HomeViewModel.categories`. Duplicated rather than imported
/// because that file pulls in `shared_preferences`, which needs a Flutter
/// binding this plain-Dart script does not have.
const _categories = [
  (slug: 'constitutional-law', name: 'Constitutional Law'),
  (slug: 'criminal-evidence-law', name: 'Criminal & Evidence Law'),
  (slug: 'civil-general-law', name: 'Civil & General Law'),
  (slug: 'marriage-family-law', name: 'Marriage & Family Law'),
  (slug: 'labor-industrial-law', name: 'Labor & Industrial Law'),
  (slug: 'corporate-commercial-law', name: 'Corporate & Commercial Law'),
  (slug: 'taxation-law', name: 'Taxation Law'),
  (slug: 'cyber-intellectual-property', name: 'Cyber & Intellectual Property'),
  (slug: 'property-real-estate', name: 'Property & Real Estate Law'),
  (slug: 'banking-financial-law', name: 'Banking & Financial Law'),
  (slug: 'environmental-law', name: 'Environmental Law'),
];

/// Each bundled list, with the category it belongs under and the title the
/// app already shows for it. `slug` is the stable key the seeder upserts on
/// and the client looks quizzes up by, so these must not change once
/// attempts exist against them.
final _quizzes = [
  (
    slug: 'indian-constitution-quiz',
    title: 'Indian Constitution Quiz',
    category: 'constitutional-law',
    difficulty: 'medium',
    description:
        'A tour of the Constitution: its supremacy, structure, and the '
        'machinery that keeps it working.',
    questions: continueLearningQuizQuestions,
  ),
  (
    slug: 'constitutional-law-quiz',
    title: 'Constitutional Law Quiz',
    category: 'constitutional-law',
    difficulty: 'medium',
    description: 'Core constitutional doctrine and the powers it distributes.',
    questions: constitutionalLawQuizQuestions,
  ),
  (
    slug: 'fundamental-rights-quiz',
    title: 'Fundamental Rights Quiz',
    category: 'constitutional-law',
    difficulty: 'medium',
    description:
        'Test your knowledge on Fundamental Rights guaranteed by the '
        'Constitution.',
    questions: fundamentalRightsQuizQuestions,
  ),
  (
    slug: 'criminal-law-quiz',
    title: 'Criminal Law Quiz',
    category: 'criminal-evidence-law',
    difficulty: 'medium',
    description:
        'Arrest, bail, and the rights that attach the moment police act.',
    questions: criminalLawQuizQuestions,
  ),
  (
    slug: 'indian-penal-code-quiz',
    title: 'Indian Penal Code Quiz',
    category: 'criminal-evidence-law',
    difficulty: 'hard',
    description:
        'Challenge yourself with questions from the Indian Penal Code.',
    questions: indianPenalCodeQuizQuestions,
  ),
  (
    slug: 'civil-general-law-quiz',
    title: 'Civil & General Law Quiz',
    category: 'civil-general-law',
    difficulty: 'medium',
    description: 'Civil remedies, limitation, and how a suit actually moves.',
    questions: civilLawQuizQuestions,
  ),
  (
    slug: 'contract-act-quiz',
    title: 'Contract Act Quiz',
    category: 'civil-general-law',
    difficulty: 'easy',
    description: 'Test your understanding of the Indian Contract Act, 1872.',
    questions: contractActQuizQuestions,
  ),
  (
    slug: 'marriage-family-law-quiz',
    title: 'Marriage & Family Law Quiz',
    category: 'marriage-family-law',
    difficulty: 'medium',
    description:
        'Marriage, divorce, maintenance, and custody across personal laws.',
    questions: marriageFamilyLawQuizQuestions,
  ),
  (
    slug: 'labor-industrial-law-quiz',
    title: 'Labor & Industrial Law Quiz',
    category: 'labor-industrial-law',
    difficulty: 'medium',
    description:
        'Wages, workplace safety, and the rights of the Indian worker.',
    questions: laborIndustrialLawQuizQuestions,
  ),
  (
    slug: 'corporate-commercial-law-quiz',
    title: 'Corporate & Commercial Law Quiz',
    category: 'corporate-commercial-law',
    difficulty: 'medium',
    description: 'Companies, directors, insolvency, and commercial disputes.',
    questions: corporateCommercialLawQuizQuestions,
  ),
  (
    slug: 'taxation-law-quiz',
    title: 'Taxation Law Quiz',
    category: 'taxation-law',
    difficulty: 'medium',
    description: 'Income tax, GST, and the machinery of assessment and appeal.',
    questions: taxationLawQuizQuestions,
  ),
  (
    slug: 'cyber-intellectual-property-quiz',
    title: 'Cyber & Intellectual Property Quiz',
    category: 'cyber-intellectual-property',
    difficulty: 'medium',
    description: 'Data, digital offences, copyright, trademarks, and patents.',
    questions: cyberIpLawQuizQuestions,
  ),
  (
    slug: 'property-real-estate-quiz',
    title: 'Property & Real Estate Quiz',
    category: 'property-real-estate',
    difficulty: 'medium',
    description: 'Transfer of property, registration, tenancy, and RERA.',
    questions: propertyRealEstateLawQuizQuestions,
  ),
  (
    slug: 'banking-financial-law-quiz',
    title: 'Banking & Financial Law Quiz',
    category: 'banking-financial-law',
    difficulty: 'medium',
    description: 'Negotiable instruments, recovery, and financial regulation.',
    questions: bankingFinancialLawQuizQuestions,
  ),
  (
    slug: 'environmental-law-quiz',
    title: 'Environmental Law Quiz',
    category: 'environmental-law',
    difficulty: 'medium',
    description:
        'Pollution control, forest and wildlife protection, and the NGT.',
    questions: environmentalLawQuizQuestions,
  ),
];

/// The explanation card renders `core`, `reference`, and `takeaway` as three
/// distinct rows, but `questions.explanation` is a single TEXT column.
/// Encoding the parts as a JSON object keeps that structure without a schema
/// change; the client falls back to treating a non-JSON value as bare
/// `core` text.
String _encodeExplanation(QuizExplanation explanation) {
  return jsonEncode({
    'core': explanation.core,
    if (explanation.reference != null) 'reference': explanation.reference,
    if (explanation.takeaway != null) 'takeaway': explanation.takeaway,
  });
}

Map<String, Object?> _question(QuizQuestion question, int order) {
  return {
    'key': question.id,
    'questionText': question.stem,
    'explanation': _encodeExplanation(question.explanation),
    'displayOrder': order,
    'options': [
      for (final (index, option) in question.options.indexed)
        {
          'optionText': option,
          'isCorrect': index == question.correctOption,
          'displayOrder': index + 1,
        },
    ],
  };
}

void main() {
  final payload = {
    'categories': [
      for (final category in _categories)
        {'slug': category.slug, 'name': category.name},
    ],
    'quizzes': [
      for (final quiz in _quizzes)
        {
          'slug': quiz.slug,
          'title': quiz.title,
          'categorySlug': quiz.category,
          'description': quiz.description,
          'difficulty': quiz.difficulty,
          'questions': [
            for (final (index, question) in quiz.questions.indexed)
              _question(question, index + 1),
          ],
        },
    ],
  };

  stdout.writeln(const JsonEncoder.withIndent('  ').convert(payload));
}
