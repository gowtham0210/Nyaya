import '../presentation/quiz_session_view_model.dart';

/// The 12 questions behind Home's "Contract Act Quiz" popular-quiz card.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> contractActQuizQuestions = [
  const QuizQuestion(
    id: 'contract-proposal-definition',
    stem:
        'Under the Indian Contract Act, 1872, when one person signifies '
        "to another their willingness to do or abstain from doing "
        "something, with a view to obtaining that other's assent, it is "
        'called a:',
    options: ['Proposal', 'Consideration', 'Acceptance', 'Guarantee'],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'This is the statutory definition of a "proposal" (offer) — '
          'the first step in forming an agreement.',
      reference: 'Indian Contract Act, 1872, Section 2(a)',
    ),
  ),
  const QuizQuestion(
    id: 'contract-acceptance-absolute',
    stem:
        'For a proposal to result in a promise, the acceptance of the '
        'proposal must be:',
    options: [
      'Conditional and open to negotiation',
      'Absolute and unqualified',
      'Given only in writing',
      'Given only after payment is made',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Acceptance must be absolute and unqualified — a conditional '
          'or qualified acceptance is treated as a counter-offer, not an '
          'acceptance.',
      reference: 'Indian Contract Act, 1872, Section 7',
    ),
  ),
  const QuizQuestion(
    id: 'contract-consideration-definition',
    stem: 'In contract law, "consideration" generally refers to:',
    options: [
      'The signature of a witness',
      'Something in return given or promised by one party for the '
          "promise of the other",
      'The court fee paid to file a suit',
      'A moral obligation with no legal effect',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Consideration is what each party gives or promises in '
          'return for the other\'s promise — it is one of the essentials '
          'of a valid contract.',
      reference: 'Indian Contract Act, 1872, Section 2(d)',
    ),
  ),
  const QuizQuestion(
    id: 'contract-void-agreement',
    stem:
        'A "void agreement" under the Indian Contract Act, 1872 is one '
        'that is:',
    options: [
      'Enforceable only by the stronger party',
      'Not enforceable by law at all',
      'Enforceable only in criminal courts',
      'Automatically converted into a contract after a year',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An agreement not enforceable by law is void — it creates no '
          'legal rights or obligations for either party.',
      reference: 'Indian Contract Act, 1872, Section 2(g)',
    ),
  ),
  const QuizQuestion(
    id: 'contract-voidable-definition',
    stem: 'A "voidable contract" is one that is:',
    options: [
      'Void from the very beginning',
      'Enforceable at the option of one or more parties, but not at the '
          'option of the other(s)',
      'Always illegal',
      'Binding on neither party under any circumstances',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A voidable contract remains valid and enforceable unless '
          'and until the party whose consent was not free chooses to '
          'avoid it.',
      reference: 'Indian Contract Act, 1872, Section 2(i)',
    ),
  ),
  const QuizQuestion(
    id: 'contract-capacity',
    stem:
        'Which of the following persons is generally NOT competent to '
        'contract under the Indian Contract Act, 1872?',
    options: [
      'A major of sound mind',
      'A minor',
      'A company acting through its authorised representative',
      'A sane adult who is not disqualified by any law',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A person is competent to contract only if they have '
          'attained majority, are of sound mind, and are not disqualified '
          'by any law — a minor lacks contractual capacity.',
      reference: 'Indian Contract Act, 1872, Section 11',
    ),
  ),
  const QuizQuestion(
    id: 'contract-coercion',
    stem: '"Coercion" as a factor vitiating free consent involves:',
    options: [
      'Committing or threatening to commit an act forbidden by law, or '
          "unlawfully detaining property, to induce a person's consent",
      'Simply offering a better deal',
      'Giving honest advice to a friend',
      'Advertising a product truthfully',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Coercion involves committing, or threatening to commit, an '
          'act forbidden by law, or unlawfully detaining property, to '
          'compel a person to enter into an agreement.',
      reference: 'Indian Contract Act, 1872, Section 15',
    ),
  ),
  const QuizQuestion(
    id: 'contract-undue-influence',
    stem:
        '"Undue influence" typically arises when one party is in a '
        'position to dominate the will of the other and:',
    options: [
      'Uses that position to obtain an unfair advantage over the other',
      'Simply gives fair market advice',
      'Has no relationship with the other party at all',
      'Signs the agreement last',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Undue influence occurs when a party capable of dominating '
          "the will of another (e.g. due to a fiduciary relationship) "
          'uses that dominant position to gain an unfair advantage.',
      reference: 'Indian Contract Act, 1872, Section 16',
    ),
  ),
  const QuizQuestion(
    id: 'contract-fraud',
    stem:
        'Which of the following amounts to "fraud" under the Indian '
        'Contract Act, 1872?',
    options: [
      'A false representation of fact, made knowingly, with intent to '
          'deceive another party into entering the contract',
      'An honest mistake about a fact',
      'A statement believed to be true when made',
      'Silence in every situation, regardless of duty to speak',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Fraud involves a false representation made knowingly, or '
          'without belief in its truth, with the intent to deceive the '
          'other party and induce them to enter the contract.',
      reference: 'Indian Contract Act, 1872, Section 17',
    ),
  ),
  const QuizQuestion(
    id: 'contract-wagering-agreement',
    stem: 'A wagering agreement under the Indian Contract Act, 1872 is:',
    options: [
      'Valid and fully enforceable in every court',
      'Void',
      'Enforceable only between friends',
      'Automatically treated as a contract of guarantee',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Agreements by way of wager are expressly declared void, and '
          'no suit can be brought to recover anything won on a wager.',
      reference: 'Indian Contract Act, 1872, Section 30',
    ),
  ),
  const QuizQuestion(
    id: 'contract-contingent-contract',
    stem:
        'A "contingent contract" is a contract to do or not do '
        'something:',
    options: [
      'Immediately, regardless of any condition',
      'If some event, collateral to the contract, does or does not '
          'happen',
      'Only after the death of one party',
      'Only if a court orders it',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A contingent contract depends on the happening or '
          'non-happening of some future, uncertain event that is '
          'collateral to the contract itself.',
      reference: 'Indian Contract Act, 1872, Section 31',
    ),
  ),
  const QuizQuestion(
    id: 'contract-necessaries-incapable-person',
    stem:
        'If necessaries are supplied to a person incapable of '
        'entering into a contract (such as a minor), the supplier is:',
    options: [
      'Entitled to be reimbursed from the property of such incapable '
          'person',
      'Barred from any recovery whatsoever',
      'Entitled to imprison the incapable person',
      'Required to supply the goods free of any claim',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'This is a quasi-contractual obligation: the person who '
          'furnishes necessaries to someone incapable of contracting is '
          'entitled to be reimbursed from that person\'s property, even '
          'though no valid contract exists.',
      reference: 'Indian Contract Act, 1872, Section 68',
    ),
  ),
];
