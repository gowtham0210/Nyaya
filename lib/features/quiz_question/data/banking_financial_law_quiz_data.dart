import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Banking & Financial Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> bankingFinancialLawQuizQuestions = [
  const QuizQuestion(
    id: 'banking-rbi-establishment',
    stem:
        "The Reserve Bank of India, India's central bank, was "
        'established under:',
    options: [
      'The Banking Regulation Act, 1949',
      'The Reserve Bank of India Act, 1934',
      'The Companies Act, 2013',
      'The SARFAESI Act, 2002',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Reserve Bank of India was constituted under the '
          'Reserve Bank of India Act, 1934, and commenced operations in '
          "1935 as India's central banking institution.",
      reference: 'Reserve Bank of India Act, 1934',
    ),
  ),
  const QuizQuestion(
    id: 'banking-definition-section-5b',
    stem:
        'Under Section 5(b) of the Banking Regulation Act, 1949, '
        '"banking" means:',
    options: [
      'Lending money to the public without accepting any deposits',
      'Accepting, for the purpose of lending or investment, deposits '
          'of money from the public, repayable on demand or otherwise, '
          'and withdrawable by cheque, draft, order, or otherwise',
      'Only the issuance of currency notes',
      'Only the trading of government securities',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 5(b) defines "banking" as accepting deposits from '
          'the public for lending or investment, repayable on demand '
          'or otherwise, and withdrawable by cheque, draft, or similar '
          'instruments.',
      reference: 'Banking Regulation Act, 1949, Section 5(b)',
    ),
  ),
  const QuizQuestion(
    id: 'banking-negotiable-instrument',
    stem:
        'Under Section 13 of the Negotiable Instruments Act, 1881, '
        'which of the following is recognized as a "negotiable '
        'instrument"?',
    options: [
      'A share certificate',
      'A promissory note, bill of exchange, or cheque, payable either '
          'to order or to bearer',
      'A fixed deposit receipt',
      'A memorandum of understanding',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 13 defines a negotiable instrument as a '
          'promissory note, bill of exchange, or cheque payable either '
          'to order or to bearer, transferable by mere delivery or '
          'endorsement.',
      reference: 'Negotiable Instruments Act, 1881, Section 13',
    ),
  ),
  const QuizQuestion(
    id: 'banking-cheque-definition',
    stem:
        'Under Section 6 of the Negotiable Instruments Act, 1881, a '
        '"cheque" is:',
    options: [
      'A bill of exchange drawn on a specified banker, payable '
          'otherwise than on demand',
      'A bill of exchange drawn on a specified banker and not '
          'expressed to be payable otherwise than on demand',
      'A promissory note issued by a company',
      'An instrument that can be drawn on any person, not necessarily '
          'a banker',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A cheque is a species of bill of exchange, drawn '
          'specifically on a banker and payable on demand — it cannot '
          'be made payable otherwise than on demand.',
      reference: 'Negotiable Instruments Act, 1881, Section 6',
    ),
  ),
  const QuizQuestion(
    id: 'banking-cheque-dishonour-138',
    stem:
        'A cheque issued by A in discharge of a legally enforceable '
        'debt is dishonoured by the bank due to insufficiency of funds. '
        'A fails to make payment despite a valid demand notice. Under '
        'which provision of the Negotiable Instruments Act, 1881 can A '
        'be held criminally liable?',
    options: ['Section 118', 'Section 131', 'Section 138', 'Section 6'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Section 138 makes dishonour of a cheque for insufficiency '
          'of funds, issued towards discharge of a legally enforceable '
          'debt, a criminal offence, provided the statutory notice and '
          'payment-default conditions are met.',
      reference: 'Negotiable Instruments Act, 1881, Section 138',
    ),
  ),
  const QuizQuestion(
    id: 'banking-promissory-note-definition',
    stem:
        'Under Section 4 of the Negotiable Instruments Act, 1881, a '
        '"promissory note" is an instrument in writing containing an '
        'unconditional undertaking, signed by the maker, to pay a '
        'certain sum of money:',
    options: [
      'Only to a named company',
      'To, or to the order of, a certain person, or to the bearer of '
          'the instrument',
      'Only upon the happening of an uncertain future event',
      'Only if countersigned by a bank',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A promissory note contains an unconditional promise by '
          'its maker to pay a certain sum to a specified person or '
          'bearer — a conditional promise does not qualify as a valid '
          'promissory note.',
      reference: 'Negotiable Instruments Act, 1881, Section 4',
    ),
  ),
  const QuizQuestion(
    id: 'banking-bill-of-exchange-definition',
    stem:
        'Under Section 5 of the Negotiable Instruments Act, 1881, a '
        '"bill of exchange" is an instrument in writing containing an '
        'unconditional order, signed by the maker, directing a certain '
        'person to pay a certain sum of money:',
    options: [
      'Only to the maker themselves',
      'To, or to the order of, a certain person, or to the bearer of '
          'the instrument',
      'Only in foreign currency',
      'Only through a promissory note',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A bill of exchange involves three parties — the drawer, '
          'the drawee, and the payee — and contains an unconditional '
          'order (not a promise) by the drawer directing the drawee to '
          'pay a certain sum to a specified person or bearer.',
      reference: 'Negotiable Instruments Act, 1881, Section 5',
    ),
  ),
  const QuizQuestion(
    id: 'banking-cheque-crossing',
    stem:
        'A cheque bearing two parallel transverse lines across its '
        'face, with or without the words "& Co.", is known as:',
    options: [
      'An open cheque',
      'A generally crossed cheque',
      'A post-dated cheque',
      'A bearer cheque',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'General crossing, marked by two parallel transverse lines '
          '(with or without "& Co."), directs that the cheque be paid '
          'only through a banker rather than across the counter, '
          'reducing the risk of fraudulent encashment.',
      reference: 'Negotiable Instruments Act, 1881, Section 123',
    ),
  ),
  const QuizQuestion(
    id: 'banking-holder-in-due-course',
    stem:
        'Under Section 9 of the Negotiable Instruments Act, 1881, a '
        '"holder in due course" is a person who, for consideration, '
        'became the possessor of a negotiable instrument:',
    options: [
      'After knowing that the instrument was forged',
      'Before the amount mentioned in it became payable, and without '
          'having sufficient cause to believe that any defect existed '
          'in the title of the person from whom they derived title',
      'Without paying any consideration for it',
      'Only if they are the original payee',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A holder in due course must have taken the instrument in '
          'good faith, for consideration, before maturity, and without '
          "notice of any defect in the transferor's title, which "
          'entitles them to enhanced protection under the Act.',
      reference: 'Negotiable Instruments Act, 1881, Section 9',
    ),
  ),
  const QuizQuestion(
    id: 'banking-banker-customer-relationship',
    stem:
        'The primary legal relationship between a bank and a '
        'customer in respect of money deposited in an ordinary savings '
        'or current account is that of:',
    options: [
      'Trustee and beneficiary',
      'Bailor and bailee',
      'Debtor and creditor, with the bank as debtor and the customer '
          'as creditor',
      'Principal and agent only',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'When a customer deposits money with a bank, the bank '
          'becomes a debtor obliged to repay an equivalent sum on '
          'demand (or as agreed), while the customer becomes the '
          'creditor — this is the foundational contractual '
          'relationship, alongside certain agency functions.',
    ),
  ),
  const QuizQuestion(
    id: 'banking-sarfaesi-purpose',
    stem:
        'The primary purpose of the Securitisation and Reconstruction '
        'of Financial Assets and Enforcement of Security Interest Act, '
        '2002 (SARFAESI Act) is to:',
    options: [
      'Regulate the issuance of currency notes',
      'Enable banks and financial institutions to enforce their '
          'security interest over secured assets and recover '
          'non-performing dues without the intervention of a court, '
          'subject to specified safeguards',
      'Establish the Reserve Bank of India',
      'Govern the incorporation of banking companies',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The SARFAESI Act empowers secured creditors to enforce '
          'security interests and recover dues from defaulting '
          'borrowers through measures like taking possession of '
          'secured assets, without approaching a civil court, subject '
          "to the borrower's right of appeal.",
      reference: 'SARFAESI Act, 2002',
    ),
  ),
  const QuizQuestion(
    id: 'banking-sarfaesi-section-13-2-notice',
    stem:
        'Before a secured creditor can enforce its security interest '
        'under Section 13(2) of the SARFAESI Act, 2002, it must first:',
    options: [
      'Obtain a decree from a civil court',
      'Issue a written notice to the borrower, calling upon them to '
          'discharge their liabilities within sixty days from the date '
          'of the notice',
      'Immediately auction the property without any notice',
      'Seek prior approval of the Reserve Bank of India for every '
          'individual loan',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 13(2) requires the secured creditor to first '
          'serve a written notice on the defaulting borrower demanding '
          'repayment within 60 days before taking any enforcement '
          'measures against the secured assets.',
      reference: 'SARFAESI Act, 2002, Section 13(2)',
    ),
  ),
  const QuizQuestion(
    id: 'banking-ibc-purpose',
    stem:
        'The Insolvency and Bankruptcy Code, 2016 primarily provides '
        'for:',
    options: [
      'A time-bound process for resolving insolvency of corporate '
          'debtors, individuals, and partnership firms, through a '
          'Corporate Insolvency Resolution Process or liquidation',
      'The regulation of foreign exchange transactions',
      'The registration of trademarks of insolvent companies',
      'The direct write-off of all bank loans without any process',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'The IBC, 2016 consolidates and provides a time-bound '
          'mechanism for resolving insolvency, primarily through the '
          'Corporate Insolvency Resolution Process before the NCLT, '
          'with liquidation as a last resort if resolution fails.',
      reference: 'Insolvency and Bankruptcy Code, 2016',
    ),
  ),
  const QuizQuestion(
    id: 'banking-nbfc-distinction',
    stem:
        'Which of the following distinguishes a Non-Banking Financial '
        'Company (NBFC) from a bank under Indian law?',
    options: [
      'An NBFC can issue cheques drawable on itself, just like a bank',
      'An NBFC cannot accept demand deposits and cannot issue cheques '
          'drawable on itself, unlike a bank',
      'An NBFC is not regulated by the Reserve Bank of India at all',
      'An NBFC can never lend money to the public',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'While NBFCs carry on financial activities like lending '
          'and investment and are regulated by the RBI, they cannot '
          'accept demand deposits or issue cheques drawn on '
          'themselves — a key distinction from banking companies.',
    ),
  ),
  const QuizQuestion(
    id: 'banking-payment-settlement-systems-act',
    stem:
        'Electronic and digital payment systems in India, such as '
        'RTGS, NEFT, and UPI, are regulated principally under:',
    options: [
      'The Information Technology Act, 2000, alone',
      'The Payment and Settlement Systems Act, 2007, which empowers '
          'the Reserve Bank of India to regulate and supervise payment '
          'systems',
      'The Banking Regulation Act, 1949, exclusively',
      'The Consumer Protection Act, 2019',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Payment and Settlement Systems Act, 2007 designates '
          'the Reserve Bank of India as the regulator and supervisor '
          'of payment and settlement systems in India, including '
          'digital and electronic payment mechanisms.',
      reference: 'Payment and Settlement Systems Act, 2007',
    ),
  ),
];
