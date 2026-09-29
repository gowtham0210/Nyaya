import '../presentation/quiz_session_view_model.dart';

/// Five short, local stand-ins for the Leaderboard journey's quiz pool.
///
/// The journey is meant to pull unseen quizzes from the backend catalogue,
/// but a fresh dev setup has no server running yet to seed any. These let
/// the journey — level layout, locking, credits, preview — be played
/// end to end without one. `post_sign_up_flow.dart` only reaches for them
/// when the live backend pool comes back empty; delete both once real pool
/// quizzes are seeded server-side.
final _demoQuizzes = [_quizOne, _quizTwo, _quizThree, _quizFour, _quizFive];

/// 30 slugs — four normal levels of 5 plus the 10-quiz boss level 5 and the
/// chest after it — cycling through the five question sets above. The
/// content repeats, but that's fine for exercising the journey's layout,
/// locking and chest.
final demoPoolQuizzes = <String, List<QuizQuestion>>{
  for (var i = 1; i <= 30; i++)
    'demo-pool-quiz-$i': _demoQuizzes[(i - 1) % _demoQuizzes.length],
};

final List<QuizQuestion> _quizOne = [
  const QuizQuestion(
    id: 'demo-1-1',
    stem: 'What is the supreme law of India?',
    options: [
      'The Constitution',
      'The Indian Penal Code',
      'Common Law',
      "Parliament's rulings",
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'The Constitution of India is the supreme law — every other '
          'law must conform to it.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-1-2',
    stem:
        'How many Fundamental Rights does the Indian Constitution '
        'currently guarantee?',
    options: ['Five', 'Six', 'Seven', 'Eight'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Six, after the Right to Property was removed as a '
          'Fundamental Right by the 44th Amendment.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-1-3',
    stem: 'Who is the final interpreter of the Constitution of India?',
    options: [
      'The President',
      'The Parliament',
      'The Supreme Court',
      'The Election Commission',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The Supreme Court has the final word on constitutional '
          'interpretation, through its power of judicial review.',
    ),
  ),
];

final List<QuizQuestion> _quizTwo = [
  const QuizQuestion(
    id: 'demo-2-1',
    stem: 'A contract entered into by a minor is:',
    options: ['Valid', 'Void', 'Voidable at the minor\'s option', 'Illegal'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A minor\'s agreement is void ab initio under Indian contract '
          'law, not merely voidable.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-2-2',
    stem:
        'Which of these is NOT one of the essentials of a valid '
        'contract?',
    options: [
      'Free consent',
      'Lawful consideration',
      'Registration with a notary',
      'Competent parties',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Most contracts need no registration at all — it is not a '
          'general essential of contract formation.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-2-3',
    stem: 'A promise without consideration is generally:',
    options: ['Enforceable', 'Void', 'Voidable', 'Illegal'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'As a rule, an agreement made without consideration is void, '
          'subject to a few statutory exceptions.',
    ),
  ),
];

final List<QuizQuestion> _quizThree = [
  const QuizQuestion(
    id: 'demo-3-1',
    stem:
        'The presumption of innocence means the accused is presumed '
        'innocent until:',
    options: ['Arrested', 'Charged', 'Proven guilty', 'Questioned by police'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The burden lies on the prosecution to prove guilt beyond '
          'reasonable doubt; the accused need prove nothing.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-3-2',
    stem: 'What does "FIR" stand for in Indian criminal procedure?',
    options: [
      'Final Investigation Record',
      'First Information Report',
      'Formal Inquiry Request',
      'Field Incident Report',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An FIR is the document police prepare on first receiving '
          'information about a cognizable offence.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-3-3',
    stem: 'Bail is generally a matter of right for:',
    options: [
      'Non-bailable offences',
      'Bailable offences',
      'Capital offences only',
      'No offences',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'For a bailable offence, bail is a right; for a non-bailable '
          'one it is at the court\'s discretion.',
    ),
  ),
];

final List<QuizQuestion> _quizFour = [
  const QuizQuestion(
    id: 'demo-4-1',
    stem:
        'Registration of a sale deed for immovable property above a '
        'certain value is:',
    options: [
      'Optional',
      'Mandatory',
      'Only needed for agricultural land',
      'Only needed between strangers',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Under the Registration Act, 1908, sale of immovable property '
          'worth over ₹100 must be registered to be valid.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-4-2',
    stem: 'A "lease" of immovable property transfers:',
    options: [
      'Ownership',
      'A right to enjoy the property for a term',
      'A mortgage interest',
      'Nothing legally binding',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A lease grants the right to possess and enjoy property for a '
          'fixed term or periodically, not ownership.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-4-3',
    stem: 'What is "adverse possession"?',
    options: [
      'Buying property at auction',
      'Acquiring title through long, open, hostile possession',
      'Inheriting property from a will',
      'Renting property month to month',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Continuous, open, and hostile possession of land for the '
          'statutory period can ripen into ownership.',
    ),
  ),
];

final List<QuizQuestion> _quizFive = [
  const QuizQuestion(
    id: 'demo-5-1',
    stem:
        'Which authority hears disputes between an employee and '
        'employer under Indian labour law?',
    options: [
      'Civil Court only',
      'Labour Court / Industrial Tribunal',
      'Supreme Court only',
      'Police',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Labour Courts and Industrial Tribunals are the specialised '
          'forums for most employment disputes.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-5-2',
    stem: 'What does GST stand for?',
    options: [
      'General Sales Tax',
      'Goods and Services Tax',
      'Government Service Tariff',
      'Gross Selling Tax',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'GST — Goods and Services Tax — replaced most indirect taxes '
          'with a single unified tax.',
    ),
  ),
  const QuizQuestion(
    id: 'demo-5-3',
    stem:
        'Copyright protection for a literary work in India generally '
        'lasts for the author\'s life plus:',
    options: ['10 years', '20 years', '60 years', '100 years'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Under the Copyright Act, 1957, protection runs for the '
          'author\'s lifetime plus 60 years.',
    ),
  ),
];
