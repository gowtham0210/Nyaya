import '../presentation/quiz_session_view_model.dart';

/// The 10 questions behind Home's "Fundamental Rights Quiz" popular-quiz
/// card.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> fundamentalRightsQuizQuestions = [
  const QuizQuestion(
    id: 'fr-article-12-state',
    stem:
        'Which Article of the Constitution defines "State" for the '
        'purposes of Part III (Fundamental Rights)?',
    options: ['Article 12', 'Article 13', 'Article 14', 'Article 19'],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Article 12 defines "State" to include the Government and '
          'Parliament of India, State legislatures and governments, and '
          'local or other authorities, for the purpose of Fundamental '
          'Rights.',
      reference: 'Constitution of India, Article 12',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-13-void-laws',
    stem:
        'Article 13 of the Constitution provides that any law '
        'inconsistent with Fundamental Rights shall be:',
    options: [
      'Suspended for one year',
      'Void to the extent of the inconsistency',
      'Automatically amended by Parliament',
      'Valid until challenged in the Supreme Court',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 13 makes any law that takes away or abridges a '
          'Fundamental Right void to the extent of the contravention.',
      reference: 'Constitution of India, Article 13',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-14-equality',
    stem: 'Article 14 of the Constitution guarantees:',
    options: [
      'Equality before law and equal protection of laws',
      'Freedom of speech and expression',
      'Right to constitutional remedies',
      'Right against exploitation',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Article 14 guarantees that the State shall not deny to any '
          'person equality before the law or the equal protection of the '
          'laws within the territory of India.',
      reference: 'Constitution of India, Article 14',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-15-discrimination',
    stem:
        'Article 15 of the Constitution prohibits discrimination by the '
        'State on grounds of:',
    options: [
      'Religion, race, caste, sex, or place of birth',
      'Educational qualification',
      'Political affiliation',
      'Marital status',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Article 15 bars the State from discriminating against any '
          'citizen on grounds only of religion, race, caste, sex, or '
          'place of birth, while permitting special provisions for women, '
          'children, and socially and educationally backward classes.',
      reference: 'Constitution of India, Article 15',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-16-public-employment',
    stem:
        'Which Article guarantees equality of opportunity in matters of '
        'public employment?',
    options: ['Article 14', 'Article 15', 'Article 16', 'Article 19'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Article 16 guarantees equality of opportunity for all '
          'citizens in matters relating to employment or appointment to '
          'any office under the State, subject to permitted reservations.',
      reference: 'Constitution of India, Article 16',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-17-untouchability',
    stem: 'Article 17 of the Constitution deals with:',
    options: [
      'Abolition of untouchability',
      'Abolition of titles',
      'Freedom of religion',
      'Right to education',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Article 17 abolishes "untouchability" and forbids its '
          'practice in any form, making its enforcement a punishable '
          'offence.',
      reference: 'Constitution of India, Article 17',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-19-six-freedoms',
    stem:
        'Which of the following is NOT one of the six freedoms '
        'guaranteed under Article 19(1) of the Constitution?',
    options: [
      'Freedom of speech and expression',
      'Freedom to practice any profession',
      'Right to property',
      'Freedom of movement throughout India',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The right to property was removed from Part III by the 44th '
          'Amendment; it now survives only as a legal right under Article '
          '300A, not among the freedoms in Article 19(1).',
      reference: 'Constitution of India, Article 19(1); Article 300A',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-20-double-jeopardy',
    stem:
        'Article 20(2) of the Constitution embodies the principle '
        'against:',
    options: [
      'Self-incrimination',
      'Double jeopardy',
      'Ex post facto laws',
      'Preventive detention',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 20(2) protects a person from being prosecuted and '
          'punished more than once for the same offence; Article 20(1) '
          'covers ex post facto laws and Article 20(3) covers '
          'self-incrimination.',
      reference: 'Constitution of India, Article 20(2)',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-21-maneka-gandhi',
    stem:
        'In Maneka Gandhi v. Union of India (1978), the Supreme Court '
        'held that the "procedure established by law" under Article 21 '
        'must be:',
    options: [
      'Any procedure enacted by the legislature, regardless of fairness',
      'Just, fair and reasonable, not arbitrary',
      'Applicable only to citizens, not foreigners',
      "Subject to the President's approval",
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Maneka Gandhi read Articles 14, 19, and 21 together, holding '
          'that any procedure depriving a person of life or personal '
          'liberty must be just, fair, and reasonable.',
      reference:
          'Maneka Gandhi v. Union of India, (1978) 1 SCC 248; Article 21',
    ),
  ),
  const QuizQuestion(
    id: 'fr-article-32-heart-and-soul',
    stem:
        'Dr. B.R. Ambedkar described which Article as the "heart and '
        'soul" of the Constitution?',
    options: ['Article 14', 'Article 19', 'Article 21', 'Article 32'],
    correctOption: 3,
    explanation: QuizExplanation(
      core:
          'Article 32 guarantees the right to move the Supreme Court '
          'directly for enforcement of Fundamental Rights through writs, '
          'which Ambedkar called the heart and soul of the Constitution.',
      reference: 'Constitution of India, Article 32',
    ),
  ),
];
