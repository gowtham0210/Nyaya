import '../presentation/quiz_session_view_model.dart';

/// The 15 mock questions behind Home's "Criminal Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> criminalLawQuizQuestions = [
  const QuizQuestion(
    id: 'essential-element-of-crime',
    stem: 'What is the essential element of a crime?',
    options: [
      'Only intention',
      'Only punishment',
      'Act or omission prohibited by law',
      'Only motive',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'A crime requires an act or omission that the law expressly '
          'prohibits and punishes — intention or motive alone is not '
          'enough.',
    ),
  ),
  const QuizQuestion(
    id: 'mens-rea',
    stem: 'Mens rea means:',
    options: [
      'Guilty act',
      'Guilty mind',
      'Legal punishment',
      'Criminal court',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Mens rea is Latin for "guilty mind" — the mental element '
          '(intention, knowledge, or recklessness) behind an offence.',
    ),
  ),
  const QuizQuestion(
    id: 'actus-reus',
    stem: 'Actus reus refers to:',
    options: [
      'Guilty intention',
      'Criminal act or unlawful omission',
      'Punishment',
      'Motive',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Actus reus is the physical element of a crime — the wrongful '
          'act or unlawful omission itself, as opposed to the mental state '
          'behind it.',
    ),
  ),
  const QuizQuestion(
    id: 'not-a-crime',
    stem: 'Which of the following is generally not a crime?',
    options: [
      'Theft',
      'Murder',
      'Mere evil thought without a criminal act',
      'Robbery',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Criminal law does not punish thoughts alone; an evil '
          'intention must be translated into an act or omission before it '
          'becomes an offence.',
      takeaway: 'No one is punished for a thought that was never acted on.',
    ),
  ),
  const QuizQuestion(
    id: 'theft',
    stem:
        "A person takes someone else's movable property dishonestly "
        'without consent. This is generally:',
    options: ['Extortion', 'Theft', 'Cheating', 'Criminal trespass'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "Dishonestly taking another person's movable property out of "
          'their possession, without their consent, is the classic '
          'definition of theft.',
    ),
  ),
  const QuizQuestion(
    id: 'robbery',
    stem: 'Robbery is generally considered an aggravated form of:',
    options: [
      'Theft or extortion involving immediate violence or fear',
      'Defamation',
      'Cheating only',
      'Criminal conspiracy',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Robbery is theft or extortion aggravated by the use, or '
          'threat, of immediate force that causes fear of instant harm.',
    ),
  ),
  const QuizQuestion(
    id: 'motive',
    stem: 'The term motive means:',
    options: [
      'The physical act of committing a crime',
      'The reason that induces a person to commit an act',
      'The punishment for an offence',
      'The evidence produced in court',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Motive is the underlying reason that drives a person to act. '
          'It differs from intention, which is the mental state at the '
          'moment of the act itself.',
    ),
  ),
  const QuizQuestion(
    id: 'offence-against-body',
    stem: 'Which one is an offence against the human body?',
    options: ['Murder', 'Theft', 'Cheating', 'Forgery'],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Murder is an offence against the human body, unlike property '
          'or document offences such as theft, cheating, or forgery.',
    ),
  ),
  const QuizQuestion(
    id: 'criminal-liability',
    stem: 'Criminal liability generally requires:',
    options: [
      'Actus reus only',
      'Mens rea only',
      'Both a prohibited act and the required mental element',
      'Motive only',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Criminal liability generally needs actus reus and mens rea '
          'together — the guilty act and the guilty mind coinciding.',
    ),
  ),
  const QuizQuestion(
    id: 'criminal-conspiracy',
    stem:
        'If two or more persons agree to commit an illegal act, it may '
        'amount to:',
    options: [
      'Abetment only',
      'Criminal conspiracy',
      'Defamation',
      'Negligence',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An agreement between two or more persons to do an illegal '
          'act, or a legal act by illegal means, can itself amount to '
          'criminal conspiracy.',
    ),
  ),
  const QuizQuestion(
    id: 'defence-private',
    stem: 'Which of the following can be a defence in criminal law?',
    options: [
      'Private defence',
      'Ignorance of every law',
      'Bad motive',
      'Previous conviction',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'The right of private defence lets a person protect their own '
          'body or property (and that of others) against an unlawful '
          'attack, within reasonable limits.',
    ),
  ),
  const QuizQuestion(
    id: 'negligence',
    stem:
        'Causing harm due to failure to exercise reasonable care may '
        'constitute:',
    options: ['Negligence', 'Theft', 'Robbery', 'Forgery'],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Causing harm through a failure to take the care a reasonable '
          'person would have taken is negligence.',
    ),
  ),
  const QuizQuestion(
    id: 'attempt',
    stem: 'Attempting to commit a crime means:',
    options: [
      'Merely thinking about committing it',
      'Taking a direct step towards committing the offence',
      'Discussing a crime without action',
      'Having a motive',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An attempt goes beyond mere preparation — it is a direct '
          'move towards actually committing the offence, even though the '
          'offence itself is not completed.',
    ),
  ),
  const QuizQuestion(
    id: 'abetment',
    stem: 'Which of the following best describes abetment?',
    options: [
      'Punishing an innocent person',
      'Instigating, aiding, or intentionally assisting another person in '
          'committing an offence',
      'Reporting a crime',
      'Being present near a crime scene',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Abetment covers instigating a person to commit an offence, '
          'engaging in a conspiracy for it, or intentionally aiding its '
          'commission.',
    ),
  ),
  const QuizQuestion(
    id: 'murder-vs-culpable-homicide',
    stem:
        'The main difference between murder and culpable homicide not '
        'amounting to murder generally depends on:',
    options: [
      'The colour of the weapon',
      'The degree of intention, knowledge, and circumstances of the act',
      'Whether the accused is rich',
      'The location of the offence',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Culpable homicide becomes murder when the act is done with a '
          'higher degree of intention or knowledge and falls within the '
          'specific circumstances the law treats as murder; otherwise it '
          'remains culpable homicide not amounting to murder.',
    ),
  ),
];
