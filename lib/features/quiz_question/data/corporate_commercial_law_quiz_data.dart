import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Corporate & Commercial Law" category
/// quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> corporateCommercialLawQuizQuestions = [
  const QuizQuestion(
    id: 'corp-salomon-separate-personality',
    stem:
        'In Salomon v. A. Salomon & Co. Ltd. (1897), the House of '
        'Lords established the principle that:',
    options: [
      "A company's directors are always personally liable for its debts",
      'A company, once validly incorporated, is a separate legal person '
          'distinct from its shareholders',
      'Shareholders are automatically agents of the company',
      'A company cannot own property in its own name',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Salomon v. Salomon established that a validly incorporated '
          'company has a legal personality separate from its members, '
          'even where one person holds nearly all the shares.',
      reference: 'Salomon v. A. Salomon & Co. Ltd. [1897] AC 22',
    ),
  ),
  const QuizQuestion(
    id: 'corp-lifting-corporate-veil',
    stem:
        'Courts may "lift the corporate veil" and hold members or '
        'directors personally liable in which of the following '
        'situations?',
    options: [
      'Whenever a company incurs ordinary business losses',
      'Where the corporate form is used as a mere sham or façade to '
          'perpetrate fraud or evade a legal obligation',
      'Whenever a company has fewer than seven shareholders',
      "Whenever the company's paid-up capital falls below the "
          'prescribed minimum',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The corporate veil is lifted only in limited circumstances, '
          'such as fraud or improper conduct, or where the corporate '
          'structure is used as a mere façade to evade an existing '
          'legal obligation.',
    ),
  ),
  const QuizQuestion(
    id: 'corp-one-person-company',
    stem:
        'Under the Companies Act, 2013, a One Person Company (OPC) is '
        'a private company that:',
    options: [
      'May have any number of members, provided all are family members',
      'Is formed with only one natural person as its member, who must '
          'also nominate another person to become a member in the '
          'event of death or incapacity',
      'Cannot appoint any director',
      'Is exempt from filing annual financial statements',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An OPC has a single member, and the Act requires that '
          'member to nominate another person who will become the '
          'member if the original member dies or becomes incapacitated.',
      reference: 'Companies Act, 2013',
    ),
  ),
  const QuizQuestion(
    id: 'corp-private-company-member-limit',
    stem:
        'Under the Companies Act, 2013, a private company (other than '
        'an OPC) may have a maximum of how many members, excluding '
        'present and past employee-members?',
    options: ['50', '100', '200', 'There is no upper limit'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Section 2(68) caps the membership of a private company at '
          '200, excluding certain employee and ex-employee members, '
          'unlike a public company, which has no maximum limit.',
      reference: 'Companies Act, 2013, Section 2(68)',
    ),
  ),
  const QuizQuestion(
    id: 'corp-moa-vs-aoa',
    stem:
        'Which of the following best distinguishes the Memorandum of '
        'Association (MOA) from the Articles of Association (AOA) of a '
        'company?',
    options: [
      "The MOA regulates only internal management, while the AOA "
          "defines the company's objects and scope",
      "The MOA is the company's charter defining its objects and scope "
          'of activity, while the AOA contains the rules for internal '
          'management, subordinate to the MOA',
      'Only public companies need an MOA, while only private companies '
          'need an AOA',
      'The AOA can override the MOA if they conflict',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "The MOA is the company's fundamental charter defining its "
          'objects and permissible scope of operation, while the AOA '
          'lays down internal management rules and must not conflict '
          'with the MOA.',
    ),
  ),
  const QuizQuestion(
    id: 'corp-ultra-vires',
    stem:
        'The doctrine of "ultra vires", as applied to companies, '
        'means that:',
    options: [
      'Any act done by a director without board approval is '
          'automatically valid',
      'An act done by a company beyond the objects stated in its '
          'Memorandum of Association is void and cannot be ratified '
          'even by all the shareholders',
      'A company can never be sued by outsiders',
      'Shareholders can amend the Memorandum without following any '
          'statutory procedure',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "An act that is ultra vires the company's Memorandum is "
          'void ab initio and cannot be validated even by unanimous '
          "shareholder consent, since it falls outside the company's "
          'very capacity to act.',
    ),
  ),
  const QuizQuestion(
    id: 'corp-indoor-management',
    stem:
        "The doctrine of indoor management (Turquand's Rule) protects "
        'a person dealing with a company by presuming that:',
    options: [
      "The company's internal procedural requirements have been duly "
          'complied with, unless the outsider had actual or '
          'constructive notice of an irregularity',
      "The company is always liable regardless of the outsider's "
          'knowledge of fraud',
      "No outsider can ever rely on the apparent authority of a "
          "company's officers",
      'The Memorandum of Association need not be examined at all',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'An outsider dealing with a company in good faith is '
          'entitled to presume that internal formalities have been '
          'duly observed, unless they had notice of an irregularity — '
          'this protects bona fide outsiders, complementing the '
          'doctrine of constructive notice for public documents.',
      reference: "Royal British Bank v. Turquand (1856) 6 E&B 327",
    ),
  ),
  const QuizQuestion(
    id: 'corp-directors-fiduciary-duty',
    stem:
        'Under Section 166 of the Companies Act, 2013, a director of '
        'a company is under a statutory duty to:',
    options: [
      'Act only in their own personal financial interest',
      'Act in good faith to promote the objects of the company for the '
          'benefit of its members as a whole, and avoid situations of '
          'direct or indirect conflict of interest',
      'Disclose confidential company information to competitors upon '
          'request',
      "Vote only as instructed by the company's auditors",
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "Section 166 codifies a director's fiduciary duties, "
          "requiring them to act in good faith for the company's "
          'benefit, exercise independent judgment, and avoid conflicts '
          'of interest.',
      reference: 'Companies Act, 2013, Section 166',
    ),
  ),
  const QuizQuestion(
    id: 'corp-agm-requirement',
    stem:
        'Under Section 96 of the Companies Act, 2013, which type of '
        'company is exempt from the requirement to hold an Annual '
        'General Meeting?',
    options: [
      'A public listed company',
      'A One Person Company',
      'A private limited company with more than 50 members',
      'A Section 8 (non-profit) company',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 96 requires every company, other than a One '
          'Person Company, to hold an Annual General Meeting each '
          'year, with the gap between two AGMs not exceeding fifteen '
          'months.',
      reference: 'Companies Act, 2013, Section 96',
    ),
  ),
  const QuizQuestion(
    id: 'corp-nclt-jurisdiction',
    stem:
        'The National Company Law Tribunal (NCLT), constituted under '
        'the Companies Act, 2013, has jurisdiction to adjudicate, among '
        'other matters:',
    options: [
      'Only criminal offences committed by company directors',
      'Disputes relating to oppression and mismanagement, company '
          'mergers/amalgamations, and matters under the Insolvency and '
          'Bankruptcy Code, 2016',
      "Only disputes between a company and its foreign trading "
          'partners',
      'Only tax disputes involving companies',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The NCLT has wide jurisdiction over company law matters, '
          'including oppression and mismanagement petitions, mergers '
          'and amalgamations, and corporate insolvency resolution '
          'proceedings under the IBC, 2016.',
    ),
  ),
  const QuizQuestion(
    id: 'corp-contract-consideration-exception',
    stem:
        'As a general rule under Section 25 of the Indian Contract '
        'Act, 1872, an agreement made without consideration is void. '
        'Which of the following is a recognized exception to this rule?',
    options: [
      'An oral promise to pay for goods already delivered without any '
          'prior request',
      'A written and registered promise made out of natural love and '
          'affection between parties standing in a near relation to '
          'each other',
      'A verbal agreement between strangers to exchange gifts in the '
          'future',
      'Any promise made during a festival',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 25(1) recognizes an exception where a promise is '
          'expressed in writing, registered, and made out of natural '
          'love and affection between parties in a near relation — '
          'such an agreement is enforceable despite the absence of '
          'consideration.',
      reference: 'Indian Contract Act, 1872, Section 25(1)',
    ),
  ),
  const QuizQuestion(
    id: 'corp-sale-vs-agreement-to-sell',
    stem:
        'Under the Sale of Goods Act, 1930, the key distinction '
        'between a "sale" and an "agreement to sell" is that:',
    options: [
      'A sale involves immovable property, while an agreement to sell '
          'involves movable property',
      'In a sale, the property in the goods is transferred to the '
          'buyer immediately, whereas in an agreement to sell, the '
          'transfer of property takes place at a future time or '
          'subject to a condition',
      'An agreement to sell can never be converted into a sale',
      'A sale requires a written contract, while an agreement to sell '
          'may be oral',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A "sale" involves immediate transfer of ownership in '
          'goods to the buyer, while an "agreement to sell" '
          'contemplates the transfer of property at a future time or '
          'upon fulfilment of a condition.',
      reference: 'Sale of Goods Act, 1930',
    ),
  ),
  const QuizQuestion(
    id: 'corp-partnership-mutual-agency',
    stem:
        'Under the Indian Partnership Act, 1932, the "true test" for '
        'determining the existence of a partnership, as distinguished '
        'from mere profit-sharing, is:',
    options: [
      'Whether the parties have registered their firm with the '
          'Registrar',
      'The existence of mutual agency, i.e., whether each partner acts '
          'as an agent for the other partners in the business',
      'Whether the business earns a minimum specified annual turnover',
      'Whether the parties have a written partnership deed',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'While sharing of profits is evidence of partnership, the '
          'real test under the Act is the existence of mutual agency — '
          'each partner carrying on the business on behalf of all the '
          'partners.',
      reference: 'Indian Partnership Act, 1932',
    ),
  ),
  const QuizQuestion(
    id: 'corp-llp-key-feature',
    stem:
        'Under the Limited Liability Partnership Act, 2008, which '
        'feature distinguishes an LLP from a traditional partnership '
        'firm governed by the Indian Partnership Act, 1932?',
    options: [
      'An LLP has no legal existence separate from its partners',
      'An LLP is a body corporate with perpetual succession and a '
          'legal identity separate from its partners, whose liability '
          'is limited to their agreed contribution',
      "An LLP cannot enter into contracts in its own name",
      "Partners of an LLP are always jointly and severally liable for "
          "each other's individual wrongful acts",
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Unlike a traditional partnership, an LLP is a body '
          'corporate with perpetual succession, a distinct legal '
          'identity, and limited liability for its partners, combining '
          'features of a company and a partnership.',
      reference: 'Limited Liability Partnership Act, 2008',
    ),
  ),
  const QuizQuestion(
    id: 'corp-competition-commission',
    stem:
        'Under the Competition Act, 2002, the Competition Commission '
        'of India (CCI) is primarily empowered to:',
    options: [
      'Fix the retail prices of all goods sold in India',
      'Prohibit anti-competitive agreements and abuse of dominant '
          'position, and regulate combinations likely to cause an '
          'appreciable adverse effect on competition',
      'Grant patents and trademarks to businesses',
      'Adjudicate disputes between employers and employees',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The CCI is tasked with preventing practices having an '
          'adverse effect on competition, including anti-competitive '
          'agreements, abuse of dominance, and regulating mergers/'
          'acquisitions (combinations) that may harm competition in '
          'India.',
      reference: 'Competition Act, 2002',
    ),
  ),
];
