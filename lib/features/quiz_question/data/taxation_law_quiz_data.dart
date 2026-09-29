import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Taxation Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> taxationLawQuizQuestions = [
  const QuizQuestion(
    id: 'tax-current-act-2026',
    stem:
        'Which enactment governs the computation and charge of '
        'income-tax for a Tax Year beginning on or after 1 April 2026?',
    options: [
      'The Income-tax Act, 1961',
      'The Income-tax Act, 2025',
      'The Finance Act, 1961',
      'The Direct Tax Code, 2010',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Income-tax Act, 2025 came into force from 1 April 2026 '
          'and replaced the Income-tax Act, 1961 as the principal '
          'income-tax statute for Tax Years beginning on or after that '
          'date.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-year-concept',
    stem:
        'The Income-tax Act, 2025 replaced the twin concepts of '
        '"previous year" and "assessment year" used under the earlier '
        'Income-tax Act, 1961 with a single unified concept known as:',
    options: ['Financial Year', 'Tax Year', 'Accounting Period', 'Fiscal Year'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Income-tax Act, 2025 simplifies drafting by using a '
          'single term, "Tax Year", for the period in which income is '
          'earned and taxed, doing away with the separate "assessment '
          'year" terminology of the 1961 Act.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-direct-vs-indirect',
    stem:
        'Which of the following best distinguishes a direct tax from '
        'an indirect tax?',
    options: [
      'A direct tax is levied only by the Union, while an indirect tax '
          'is levied only by the States',
      'In a direct tax, the person who bears the burden is the same '
          'person who pays it to the government, whereas in an indirect '
          'tax, the burden is passed on to another person',
      'A direct tax applies only to companies, while an indirect tax '
          'applies only to individuals',
      'A direct tax cannot be refunded, while an indirect tax can '
          'always be refunded',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "The classic distinction is that a direct tax's incidence "
          'and impact fall on the same person (e.g., income-tax), while '
          "an indirect tax's burden is shifted to another person, "
          'typically the end consumer (e.g., GST).',
    ),
  ),
  const QuizQuestion(
    id: 'tax-article-265',
    stem: 'Article 265 of the Constitution of India provides that:',
    options: [
      'No tax shall be levied or collected except by authority of law',
      'All tax revenue must be shared equally between the Union and the '
          'States',
      'Only Parliament may impose any tax in India',
      'States cannot levy any tax without Presidential assent',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Article 265 lays down the fundamental constitutional '
          'principle that taxation requires legislative authority; no '
          'tax can be levied or collected merely by executive action.',
      reference: 'Constitution of India, Article 265',
    ),
  ),
  const QuizQuestion(
    id: 'tax-article-246a',
    stem:
        'The Constitution (One Hundred and First Amendment) Act, 2016 '
        'inserted which Article to give Parliament and State '
        'Legislatures concurrent power to make laws on Goods and '
        'Services Tax?',
    options: ['Article 246', 'Article 246A', 'Article 254', 'Article 265'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 246A, inserted by the 101st Constitutional '
          'Amendment, gives both Parliament and State Legislatures '
          'concurrent power to legislate on GST, subject to the '
          'exclusive Union power over inter-state supply.',
      reference: 'Constitution of India, Article 246A',
    ),
  ),
  const QuizQuestion(
    id: 'tax-gst-council-chair',
    stem:
        'The GST Council, established under Article 279A of the '
        'Constitution, is chaired by:',
    options: [
      'The President of India',
      'The Union Finance Minister',
      'The Chief Justice of India',
      'The Comptroller and Auditor General',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 279A designates the Union Finance Minister as '
          "Chairperson of the GST Council, with the Union Minister of "
          "State for Finance and each State's Finance Minister as "
          'members.',
      reference: 'Constitution of India, Article 279A',
    ),
  ),
  const QuizQuestion(
    id: 'tax-intra-state-supply',
    stem:
        'A supply of goods made from Delhi to a buyer in Delhi (an '
        'intra-state supply) is chargeable to:',
    options: [
      'Only IGST',
      'Central GST and State GST, levied concurrently',
      'Only Customs Duty',
      'Only State GST',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Under the GST framework, an intra-state supply attracts '
          'CGST (levied by the Union) and SGST (levied by the State) '
          'concurrently on the same transaction value.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-inter-state-supply',
    stem:
        'A supply of goods from Delhi to a buyer in Maharashtra (an '
        'inter-state supply) is chargeable to:',
    options: [
      'CGST and SGST together',
      'Integrated GST (IGST)',
      'Only SGST of the destination State',
      'Customs Duty',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Inter-state supplies of goods or services attract IGST, '
          'levied and collected by the Union under the IGST Act, 2017, '
          'with proceeds apportioned between the Union and the '
          'destination State.',
      reference: 'IGST Act, 2017',
    ),
  ),
  const QuizQuestion(
    id: 'tax-input-tax-credit',
    stem: '"Input Tax Credit" under the GST law refers to:',
    options: [
      'A refund given to exporters only',
      'The credit a registered taxable person can claim for GST paid on '
          'inward supplies used in the course of business, to be set '
          'off against output tax liability',
      'A rebate given by the GST Council to small businesses',
      'A penalty imposed for late filing of GST returns',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Input Tax Credit allows a registered person to reduce their '
          'output GST liability by the GST already paid on eligible '
          'business purchases, avoiding a cascading tax effect.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-tds-vs-tcs',
    stem:
        'Which of the following correctly distinguishes Tax Collected '
        'at Source (TCS) from Tax Deducted at Source (TDS)?',
    options: [
      'TDS is deducted by the payer from a payment made to the payee, '
          'while TCS is collected by the seller from the buyer at the '
          'time of sale of specified goods',
      'TDS applies only to salaries, while TCS applies only to capital '
          'gains',
      'TCS is deducted by the buyer, while TDS is collected by the '
          'seller',
      'TDS and TCS are identical concepts with no legal difference',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'TDS is withheld by the person making a payment (e.g., an '
          'employer or a buyer of services), whereas TCS is collected by '
          'the seller of specified goods from the buyer, both being '
          'mechanisms for advance tax collection.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-evasion-vs-avoidance',
    stem:
        'Which of the following best describes "tax avoidance" as '
        'distinct from "tax evasion"?',
    options: [
      'Both are equally illegal under Indian tax law',
      "Tax avoidance involves arranging one's affairs within the "
          'framework of law to legally minimize tax liability, whereas '
          'tax evasion involves illegal suppression or misrepresentation '
          'of facts to escape tax',
      'Tax evasion is legal if done in good faith, while tax avoidance '
          'is always illegal',
      'Tax avoidance applies only to companies, while tax evasion '
          'applies only to individuals',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Tax avoidance uses lawful means to reduce tax liability, '
          'while tax evasion involves deliberate concealment or '
          'misstatement of facts, which is a punishable offence.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-residential-status-scope',
    stem:
        'Under Indian income-tax law, the scope of "total income" that '
        'can be brought to tax primarily depends on:',
    options: [
      'The nationality of the assessee',
      'The residential status of the assessee for the relevant tax year',
      'The religion of the assessee',
      'The state in which the assessee resides',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A resident and ordinarily resident assessee is taxed on '
          'global income, whereas a non-resident is generally taxed only '
          'on income received, accrued, or arising in India — '
          'residential status determines this scope.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-capital-gains-holding-period',
    stem:
        'Whether a gain arising from the transfer of a capital asset '
        'is classified as a short-term or long-term capital gain '
        'primarily depends on:',
    options: [
      'The purchase price of the asset',
      'The period for which the asset was held by the assessee before '
          'transfer',
      'The mode of payment received on transfer',
      'Whether the asset was insured',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The holding period of a capital asset before its transfer '
          'determines whether the resulting gain is treated as '
          'short-term or long-term, which in turn affects the applicable '
          'tax rate and available exemptions.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-domestic-company',
    stem:
        'For income-tax purposes, an "Indian company", or any other '
        'company which has made prescribed arrangements for the '
        'declaration and payment of dividends within India, is '
        'classified as a:',
    options: [
      'Foreign company',
      'Domestic company',
      'Non-resident entity',
      'Partnership firm',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A "domestic company" includes an Indian company as well as '
          'any other company that has made the prescribed arrangements '
          'for declaring and paying dividends within India, '
          'distinguishing it from a foreign company for tax purposes.',
    ),
  ),
  const QuizQuestion(
    id: 'tax-first-appellate-authority',
    stem:
        'Where an assessee is aggrieved by an order of assessment '
        'passed by an Assessing Officer, the first appellate authority '
        'to which an appeal ordinarily lies is:',
    options: [
      'The Income Tax Appellate Tribunal',
      'The Commissioner (Appeals)',
      'The High Court',
      'The Supreme Court',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An appeal against an assessment order first lies to the '
          'Commissioner (Appeals) (or an equivalent appellate '
          'authority), with further appeal to the Income Tax Appellate '
          'Tribunal and then to the High Court on a substantial question '
          'of law.',
    ),
  ),
];
