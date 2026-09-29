import '../presentation/quiz_session_view_model.dart';

/// The 15 mock questions behind Home's "Continue Learning" quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the arrest/bail sample session so the Topic Detail
/// quiz flow (and its tests) keep behaving exactly as before.
final List<QuizQuestion> continueLearningQuizQuestions = [
  const QuizQuestion(
    id: 'supreme-law',
    stem:
        'What is the supreme law of India, to which every other law must '
        'conform?',
    options: [
      'An Act of Parliament',
      'The Constitution of India',
      'A Presidential Ordinance',
      'A Supreme Court judgment',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Constitution is the supreme law of the land. Any law '
          'inconsistent with it is void to the extent of that '
          'inconsistency.',
      reference: 'Article 13',
    ),
  ),
  const QuizQuestion(
    id: 'commencement-date',
    stem: 'On which date did the Constitution of India come into force?',
    options: [
      '15 August 1947',
      '26 November 1949',
      '26 January 1950',
      '2 October 1950',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The Constitution was adopted on 26 November 1949 but came into '
          'force on 26 January 1950 — celebrated as Republic Day.',
      takeaway:
          '26 January 1950 is Republic Day; 26 November is now marked '
          'as Constitution Day.',
    ),
  ),
  const QuizQuestion(
    id: 'father-of-constitution',
    stem:
        'Who chaired the Drafting Committee of the Indian Constitution and '
        'is widely called its chief architect?',
    options: [
      'Jawaharlal Nehru',
      'Dr. Rajendra Prasad',
      'Dr. B. R. Ambedkar',
      'Sardar Vallabhbhai Patel',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Dr. B. R. Ambedkar chaired the Drafting Committee and is '
          'regarded as the chief architect of the Constitution.',
    ),
  ),
  const QuizQuestion(
    id: 'fundamental-rights-part',
    stem:
        'Which Part of the Constitution guarantees the Fundamental '
        'Rights?',
    options: ['Part II', 'Part III', 'Part IV', 'Part V'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Part III (Articles 12–35) contains the Fundamental Rights '
          'guaranteed to every citizen.',
      reference: 'Constitution of India, Part III',
    ),
  ),
  const QuizQuestion(
    id: 'right-to-equality',
    stem:
        'Meera and Raj are treated differently by a government office for '
        'no lawful reason. Which right have they been denied?',
    options: [
      'Right to Equality',
      'Right to Property',
      'Right against Exploitation',
      'Right to Freedom of Religion',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Article 14 guarantees equality before the law and equal '
          'protection of the laws to every person.',
      reference: 'Article 14',
    ),
  ),
  const QuizQuestion(
    id: 'untouchability',
    stem:
        'Which Article of the Constitution abolishes untouchability in '
        'any form?',
    options: ['Article 15', 'Article 17', 'Article 21', 'Article 25'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 17 abolishes untouchability and forbids its practice '
          'in any form; enforcing any disability arising from it is an '
          'offence.',
      reference: 'Article 17',
    ),
  ),
  const QuizQuestion(
    id: 'habeas-corpus',
    stem:
        'A person is detained by the police without any legal '
        'justification. Which writ can be sought to secure their release?',
    options: ['Mandamus', 'Habeas Corpus', 'Quo Warranto', 'Certiorari'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Habeas Corpus literally means "to have the body." A court '
          'issuing it orders that a detained person be produced and '
          'released if the detention is unlawful.',
      reference: 'Article 32 / Article 226',
      takeaway: 'This writ directly protects personal liberty.',
    ),
  ),
  const QuizQuestion(
    id: 'highest-court',
    stem: 'Which is the highest court in the Indian judicial system?',
    options: [
      'High Court',
      'District Court',
      'Supreme Court of India',
      'National Green Tribunal',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The Supreme Court of India, seated in New Delhi, is the apex '
          'court and the final court of appeal.',
      reference: 'Article 124',
    ),
  ),
  const QuizQuestion(
    id: 'cji-appointment',
    stem: 'Who formally appoints the Chief Justice of India?',
    options: [
      'The Prime Minister',
      'The President of India',
      'The Parliament',
      'The Law Minister',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The President of India appoints the Chief Justice of India and '
          'the other judges of the Supreme Court.',
      reference: 'Article 124(2)',
    ),
  ),
  const QuizQuestion(
    id: 'constitutional-remedies',
    stem:
        'Which Article, sometimes called the "heart and soul" of the '
        'Constitution by Dr. Ambedkar, guarantees the right to move the '
        'Supreme Court to enforce Fundamental Rights?',
    options: ['Article 19', 'Article 21', 'Article 32', 'Article 44'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Article 32 gives every citizen the right to directly approach '
          'the Supreme Court for enforcement of Fundamental Rights.',
      reference: 'Article 32',
    ),
  ),
  const QuizQuestion(
    id: 'lok-sabha-age',
    stem:
        'What is the minimum age required to contest election as a '
        'member of the Lok Sabha?',
    options: ['18 years', '21 years', '25 years', '30 years'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'A person must be at least 25 years old to be a member of the '
          'House of the People (Lok Sabha).',
      reference: 'Article 84',
    ),
  ),
  const QuizQuestion(
    id: 'anti-defection',
    stem:
        'A sitting legislator wants to know which Schedule of the '
        'Constitution governs disqualification for defecting from their '
        'party. Which one is it?',
    options: [
      'Seventh Schedule',
      'Ninth Schedule',
      'Tenth Schedule',
      'Twelfth Schedule',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The Tenth Schedule, added by the 52nd Amendment, lays down the '
          'anti-defection law for members of Parliament and State '
          'legislatures.',
      reference: 'Tenth Schedule',
    ),
  ),
  const QuizQuestion(
    id: 'president-term',
    stem: 'What is the normal term of office of the President of India?',
    options: ['4 years', '5 years', '6 years', '7 years'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The President holds office for a term of five years from the '
          'date of entering upon the office, subject to re-election.',
      reference: 'Article 56',
    ),
  ),
  const QuizQuestion(
    id: 'directive-principles',
    stem:
        'Which Part of the Constitution lays down the Directive '
        'Principles of State Policy, guiding the State in law-making?',
    options: ['Part II', 'Part III', 'Part IV', 'Part IX'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Part IV (Articles 36–51) contains the Directive Principles — '
          'guidelines for governance that are not enforceable in court but '
          'are fundamental to it.',
      reference: 'Constitution of India, Part IV',
    ),
  ),
  const QuizQuestion(
    id: 'right-to-education',
    stem:
        'A child aged 8 is denied free schooling by a government school. '
        'Which Fundamental Right protects them?',
    options: [
      'Right to Education under Article 21A',
      'Right to Property',
      'Right to Constitutional Remedies',
      'Cultural and Educational Rights under Article 29',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Article 21A guarantees free and compulsory education to all '
          'children aged 6 to 14 years as a Fundamental Right.',
      reference: 'Article 21A (86th Amendment)',
      takeaway: 'Education for this age group is a right, not a favour.',
    ),
  ),
];
