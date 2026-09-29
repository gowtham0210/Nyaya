import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Civil & General Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> civilLawQuizQuestions = [
  const QuizQuestion(
    id: 'civil-law-purpose',
    stem: 'What is the primary purpose of civil law?',
    options: [
      'To punish criminals',
      'To resolve disputes between individuals or entities',
      'To conduct elections',
      'To investigate crimes',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Civil law exists to resolve disputes between private parties — '
          'individuals, businesses, or other entities — rather than to '
          'punish offenders.',
    ),
  ),
  const QuizQuestion(
    id: 'civil-procedure-code',
    stem:
        'Which law primarily governs the procedure followed by civil '
        'courts in India?',
    options: [
      'Indian Penal Code',
      'Code of Civil Procedure, 1908',
      'Indian Evidence Act',
      'Companies Act, 2013',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Code of Civil Procedure, 1908 lays down the procedure that '
          'civil courts in India follow, from filing a suit to execution of '
          'a decree.',
    ),
  ),
  const QuizQuestion(
    id: 'civil-suit-initiation',
    stem: 'A civil suit is generally initiated by filing a:',
    options: ['FIR', 'Plaint', 'Charge sheet', 'Warrant'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A civil suit begins with a plaint — a written statement of '
          'claim filed by the plaintiff. FIRs, charge sheets, and warrants '
          'belong to the criminal process.',
    ),
  ),
  const QuizQuestion(
    id: 'plaintiff-definition',
    stem: 'The person who files a civil suit is called the:',
    options: ['Defendant', 'Accused', 'Plaintiff', 'Appellant'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The party who brings the suit before the court is the '
          'plaintiff; the party being sued is the defendant.',
    ),
  ),
  const QuizQuestion(
    id: 'defendant-definition',
    stem: 'The person against whom a civil suit is filed is called the:',
    options: ['Plaintiff', 'Defendant', 'Witness', 'Complainant'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The defendant is the party against whom the plaintiff\'s claim '
          'is made and who must answer it in court.',
    ),
  ),
  const QuizQuestion(
    id: 'injunction-meaning',
    stem: 'What is an injunction?',
    options: [
      'An order directing or restraining a person from doing a particular '
          'act',
      'A criminal punishment',
      'A police investigation',
      'A type of contract',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'An injunction is a court order that requires a person to do, '
          'or refrain from doing, a specific act — a common civil remedy.',
    ),
  ),
  const QuizQuestion(
    id: 'civil-dispute-example',
    stem: 'Which of the following is an example of a civil dispute?',
    options: [
      'Theft',
      'Murder',
      'Dispute over ownership of property',
      'Robbery',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'A property ownership dispute is a civil matter between '
          'parties; theft, murder, and robbery are criminal offences '
          'prosecuted by the State.',
    ),
  ),
  const QuizQuestion(
    id: 'res-judicata',
    stem: 'The principle of res judicata generally means:',
    options: [
      'A case must always be decided by a jury',
      'A matter already finally decided by a competent court cannot '
          'generally be litigated again between the same parties',
      'Every case must be appealed',
      'A criminal case becomes a civil case',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Res judicata bars parties from re-litigating a matter that a '
          'competent court has already finally decided between them.',
    ),
  ),
  const QuizQuestion(
    id: 'contract-enforceability',
    stem: 'A contract is generally an agreement that is:',
    options: [
      'Always oral',
      'Enforceable by law',
      'Made only between companies',
      'Valid only if registered',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A contract is an agreement enforceable by law — it need not '
          'be written, made only by companies, or registered to be valid.',
    ),
  ),
  const QuizQuestion(
    id: 'valid-contract-essential',
    stem:
        'Which of the following is generally essential for a valid '
        'contract?',
    options: [
      'Free consent of the parties',
      'Criminal intention',
      'Police permission',
      'Court approval in every case',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Free consent of the parties is one of the essential elements '
          'of a valid contract, along with lawful consideration and '
          'object.',
    ),
  ),
  const QuizQuestion(
    id: 'breach-of-contract',
    stem: 'What is meant by "breach of contract"?',
    options: [
      'Formation of a contract',
      'Failure to perform a contractual obligation without lawful '
          'justification',
      'Cancellation of every contract',
      'Registration of a contract',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A breach occurs when a party fails, without lawful excuse, to '
          'perform what the contract required of them.',
    ),
  ),
  const QuizQuestion(
    id: 'burden-of-proof',
    stem:
        'In a civil case, the burden of proving a fact generally lies '
        'on:',
    options: [
      'The person who asserts it',
      'The judge',
      'The police',
      'The court clerk',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'As a general rule, whoever asserts a fact must prove it — the '
          'burden of proof rests on the party making the claim.',
    ),
  ),
  const QuizQuestion(
    id: 'civil-damages-purpose',
    stem: 'Damages in civil law are generally awarded to:',
    options: [
      'Punish every defendant with imprisonment',
      'Compensate a party for loss or injury suffered',
      'Conduct a criminal investigation',
      'Cancel all contracts',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Damages compensate the wronged party for the loss or injury '
          'they suffered; civil law does not impose imprisonment.',
    ),
  ),
  const QuizQuestion(
    id: 'civil-remedy',
    stem:
        'Which of the following is commonly a remedy available in a '
        'civil dispute?',
    options: [
      'Imprisonment in every case',
      'Damages',
      'Arrest warrant in every case',
      'Criminal conviction',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Damages, injunctions, specific performance, and declarations '
          'are typical civil remedies — imprisonment and conviction belong '
          'to criminal law.',
    ),
  ),
  const QuizQuestion(
    id: 'civil-appeal-meaning',
    stem: 'An appeal in a civil case generally means:',
    options: [
      'Starting a completely unrelated case',
      'Asking a higher court to review a decision of a lower court',
      'Filing an FIR',
      'Arresting the defendant',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An appeal asks a higher court to review and, if warranted, '
          'reverse or modify a lower court\'s decision in the same '
          'dispute.',
    ),
  ),
];
