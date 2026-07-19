class QuizExplanation {
  const QuizExplanation({required this.core, this.reference, this.takeaway});

  final String core;
  final String? reference;
  final String? takeaway;
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.stem,
    required this.options,
    required this.correctOption,
    required this.explanation,
  });

  final String id;
  final String stem;
  final List<String> options;
  final int correctOption;
  final QuizExplanation explanation;
}

class QuizSessionViewModel {
  QuizSessionViewModel({List<QuizQuestion>? questions})
      : questions = questions ?? _sampleQuestions;

  final List<QuizQuestion> questions;

  String get featureId => '011-quiz-question';

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  QuizQuestion get currentQuestion => questions[_currentIndex];

  String get counterLabel =>
      'Question ${_currentIndex + 1} of ${questions.length}';

  double get progress => (_currentIndex + 1) / questions.length;

  int? _selectedOption;

  int? get selectedOption => _selectedOption;

  bool get isAnswered => _selectedOption != null;

  bool get isCorrect => _selectedOption == currentQuestion.correctOption;

  void answer(int optionIndex) {
    if (isAnswered) {
      return;
    }
    _selectedOption = optionIndex;
  }

  final List<QuizOutcome> _outcomes = [];

  List<QuizOutcome> get outcomes => List.unmodifiable(_outcomes);

  bool _isComplete = false;

  bool get isComplete => _isComplete;

  void next() {
    final selected = _selectedOption;
    if (selected == null || _isComplete) {
      return;
    }
    _outcomes.add(
      QuizOutcome(
        questionId: currentQuestion.id,
        chosenOption: selected,
        isCorrect: isCorrect,
      ),
    );
    if (_currentIndex == questions.length - 1) {
      _isComplete = true;
      return;
    }
    _currentIndex += 1;
    _selectedOption = null;
  }
}

class QuizOutcome {
  const QuizOutcome({
    required this.questionId,
    required this.chosenOption,
    required this.isCorrect,
  });

  final String questionId;
  final int chosenOption;
  final bool isCorrect;
}

final List<QuizQuestion> _sampleQuestions = [
  const QuizQuestion(
    id: 'fir-meaning',
    stem: 'You witness a theft and rush to the police station. What is the '
        'report you file called under the BNSS?',
    options: [
      'A charge sheet',
      'A First Information Report (FIR)',
      'A summons',
      'A writ petition',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'The first report of a cognizable offence to the police is the '
          'FIR. It sets the criminal process in motion.',
      reference: 'BNSS §173 (formerly CrPC §154)',
      takeaway: 'You can report a crime at any police station, free of cost.',
    ),
  ),
  const QuizQuestion(
    id: 'zero-fir',
    stem: 'The crime happened in another district. Can the local police '
        'still register your FIR?',
    options: [
      'No — only the police with jurisdiction can',
      'Yes — as a Zero FIR, transferred later',
      'Only with a court order',
      'Only if the accused lives nearby',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'A Zero FIR can be filed at any police station regardless of '
          'where the offence happened; it is then transferred.',
      reference: 'BNSS §173',
      takeaway: 'Never let jurisdiction be an excuse to turn you away.',
    ),
  ),
  const QuizQuestion(
    id: 'cognizable',
    stem: 'For which kind of offence can police act without a court\'s '
        'permission?',
    options: [
      'Cognizable offences',
      'Non-cognizable offences',
      'Civil disputes',
      'All offences equally',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core: 'Cognizable offences (the serious kind) let police register an '
          'FIR, investigate, and arrest without prior court approval.',
      reference: 'BNSS §2(1)(g)',
    ),
  ),
  const QuizQuestion(
    id: 'warrantless-arrest',
    stem: 'The police stop Ravi at night and want to arrest him without a '
        'warrant. When is this legal under the BNSS?',
    options: [
      'Only if a magistrate has signed the order',
      'For any cognizable offence, with reasons recorded',
      'Never — a warrant is always required',
      'Only between sunrise and sunset',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'Police can arrest without a warrant for cognizable offences — '
          'serious crimes where recording reasons is enough. A magistrate\'s '
          'warrant is needed only for the less serious, non-cognizable kind.',
      reference: 'BNSS §35 (formerly CrPC §41)',
      takeaway: 'If arrested, you have the right to know the reason in '
          'writing.',
    ),
  ),
  const QuizQuestion(
    id: 'grounds-of-arrest',
    stem: 'When must the police tell you why you are being arrested?',
    options: [
      'Immediately, at the time of arrest',
      'Within a week',
      'Only if you ask in writing',
      'Only at the bail hearing',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core: 'The grounds of arrest must be communicated at once; the '
          'Constitution and the BNSS both guarantee it.',
      reference: 'Article 22(1); BNSS §47',
    ),
  ),
  const QuizQuestion(
    id: 'woman-arrest',
    stem: 'As a general rule, when may a woman not be arrested?',
    options: [
      'On public holidays',
      'After sunset and before sunrise',
      'During working hours',
      'There is no such rule',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'A woman may not be arrested after sunset and before sunrise '
          'except with a magistrate\'s prior permission in exceptional cases.',
      reference: 'BNSS §43(5)',
    ),
  ),
  const QuizQuestion(
    id: 'magistrate-24h',
    stem: 'After an arrest, the police must produce you before a magistrate '
        'within…',
    options: ['12 hours', '24 hours', '48 hours', '7 days'],
    correctOption: 1,
    explanation: QuizExplanation(
      core: '24 hours, excluding journey time. Detention beyond that without '
          'a magistrate\'s order is illegal.',
      reference: 'Article 22(2); BNSS §58',
      takeaway: 'Count the hours — this deadline protects you.',
    ),
  ),
  const QuizQuestion(
    id: 'bailable-right',
    stem: 'In a bailable offence, bail is…',
    options: [
      'A favour the police may refuse',
      'Your right',
      'Granted only by the High Court',
      'Available only to first-time offenders',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'For bailable offences bail is a matter of right, from the '
          'police station itself or the court.',
      reference: 'BNSS §478',
    ),
  ),
  const QuizQuestion(
    id: 'anticipatory-bail',
    stem: 'Fearing a false case, Meera wants bail before any arrest. What '
        'does she seek?',
    options: [
      'Default bail',
      'Interim relief',
      'Anticipatory bail',
      'A discharge petition',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core: 'Anticipatory bail is a direction that in the event of arrest, '
          'the person shall be released on bail.',
      reference: 'BNSS §482 (formerly CrPC §438)',
    ),
  ),
  const QuizQuestion(
    id: 'police-custody',
    stem: 'What is the longest total period of police custody a magistrate '
        'can authorise?',
    options: ['24 hours', '15 days', '60 days', 'Unlimited'],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'Police custody cannot exceed 15 days in total; beyond that, '
          'custody is judicial.',
      reference: 'BNSS §187',
    ),
  ),
  const QuizQuestion(
    id: 'legal-aid',
    stem: 'You cannot afford a lawyer for your defence. What does the law '
        'provide?',
    options: [
      'Nothing — hiring one is your problem',
      'Free legal aid from the State',
      'A lawyer only at appeal stage',
      'A police officer argues for you',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'Free legal aid is a constitutional promise; legal services '
          'authorities must provide a lawyer at State expense.',
      reference: 'Article 39A',
      takeaway: 'Ask the magistrate for a legal-aid lawyer — it is free.',
    ),
  ),
  const QuizQuestion(
    id: 'handcuffs',
    stem: 'When may the police routinely handcuff every person they arrest?',
    options: [
      'Always — it is standard procedure',
      'Never as a routine; only in specified serious cases',
      'Whenever the officer prefers',
      'Only outside court premises',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core: 'Routine handcuffing is unlawful. The BNSS permits it only for '
          'specified categories like habitual or violent offenders.',
      reference: 'BNSS §43(3)',
    ),
  ),
];
