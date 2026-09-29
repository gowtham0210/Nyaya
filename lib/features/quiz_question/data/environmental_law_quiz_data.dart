import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Environmental Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> environmentalLawQuizQuestions = [
  const QuizQuestion(
    id: 'env-protection-act-origin',
    stem:
        'The Environment (Protection) Act, 1986 was enacted primarily '
        'as a legislative response to:',
    options: [
      'The Chernobyl nuclear disaster',
      'The Bhopal Gas Tragedy of 1984',
      'The Stockholm Conference of 1972 alone',
      'The Kyoto Protocol',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Environment (Protection) Act, 1986 was enacted in the '
          'aftermath of the Bhopal Gas Tragedy to provide an umbrella '
          'legislation empowering the Central Government to take '
          'comprehensive measures for protecting and improving the '
          'environment.',
      reference: 'Environment (Protection) Act, 1986',
    ),
  ),
  const QuizQuestion(
    id: 'env-water-act-objective',
    stem:
        'The primary objective of the Water (Prevention and Control '
        'of Pollution) Act, 1974 is to:',
    options: [
      'Regulate the construction of dams',
      'Provide for the prevention and control of water pollution and '
          'the maintaining or restoring of wholesomeness of water, '
          'through Pollution Control Boards',
      'Privatize all water resources in India',
      'Regulate international river water disputes',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Water Act, 1974 establishes Central and State '
          'Pollution Control Boards and empowers them to prevent and '
          'control water pollution and maintain or restore the '
          'wholesomeness of water bodies.',
      reference: 'Water (Prevention and Control of Pollution) Act, 1974',
    ),
  ),
  const QuizQuestion(
    id: 'env-air-act-consent',
    stem:
        'The Air (Prevention and Control of Pollution) Act, 1981 '
        'empowers State Pollution Control Boards to:',
    options: [
      'Grant consent for the establishment or operation of industrial '
          'plants likely to cause air pollution, and to take measures '
          'for controlling such pollution',
      'Regulate only vehicular traffic on highways',
      'Impose income tax on polluting industries',
      'Grant environmental clearance for mining projects exclusively',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'The Air Act, 1981 requires industries operating in '
          'designated air pollution control areas to obtain prior '
          'consent from the State Pollution Control Board and empowers '
          'the Board to regulate emissions and enforce standards.',
      reference: 'Air (Prevention and Control of Pollution) Act, 1981',
    ),
  ),
  const QuizQuestion(
    id: 'env-cpcb-functions',
    stem:
        'Which of the following is a key function of the Central '
        'Pollution Control Board (CPCB) under the Water Act, 1974 and '
        'Air Act, 1981?',
    options: [
      'Drafting the annual Union Budget',
      'Coordinating the activities of State Pollution Control Boards, '
          'laying down standards for the quality of air and water, and '
          'advising the Central Government on pollution-related '
          'matters',
      'Appointing judges of the National Green Tribunal',
      'Issuing passports to foreign nationals',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The CPCB coordinates State Board activities, sets ambient '
          'air and water quality standards, and advises the Central '
          'Government on the prevention and control of pollution.',
    ),
  ),
  const QuizQuestion(
    id: 'env-van-adhiniyam-approval',
    stem:
        'Under the Van (Sanrakshan Evam Samvardhan) Adhiniyam, 1980 '
        '(formerly the Forest (Conservation) Act, 1980), the use of '
        'forest land for any non-forest purpose ordinarily requires:',
    options: [
      'Only the consent of the local Gram Panchayat',
      'Prior approval of the Central Government',
      'No approval at all, if the State Government consents',
      'Approval of the National Green Tribunal alone',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Act (renamed by a 2023 amendment) requires prior '
          'approval of the Central Government before forest land is '
          'diverted for any non-forest purpose, to check large-scale '
          'deforestation.',
      reference: 'Van (Sanrakshan Evam Samvardhan) Adhiniyam, 1980',
    ),
  ),
  const QuizQuestion(
    id: 'env-wildlife-protection-act',
    stem: 'The Wildlife (Protection) Act, 1972 primarily provides for:',
    options: [
      'The regulation of hunting of wild animals and birds, and the '
          'protection and management of wildlife habitats through '
          'Schedules classifying species by the degree of protection',
      'The construction of new zoos exclusively',
      'The taxation of hunting licenses',
      'The regulation of marine fishing alone',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'The Wildlife (Protection) Act, 1972 prohibits hunting of '
          'specified species, regulates trade in wildlife products, '
          'and provides for the declaration of protected areas, '
          'classifying species into Schedules according to the degree '
          'of protection.',
      reference: 'Wildlife (Protection) Act, 1972',
    ),
  ),
  const QuizQuestion(
    id: 'env-ngt-jurisdiction',
    stem:
        'The National Green Tribunal, established under the National '
        'Green Tribunal Act, 2010, has jurisdiction over:',
    options: [
      'All civil and criminal disputes without any subject-matter '
          'restriction',
      'Civil cases involving a substantial question relating to the '
          'environment, including enforcement of legal rights relating '
          'to the environment',
      'Only disputes relating to income tax on polluting industries',
      'Only disputes arising outside India',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The NGT has jurisdiction over civil cases involving a '
          'substantial question relating to the environment, including '
          'questions arising out of the implementation of specified '
          'environmental enactments.',
      reference: 'National Green Tribunal Act, 2010',
    ),
  ),
  const QuizQuestion(
    id: 'env-eia-notification-2006',
    stem:
        'Under the Environmental Impact Assessment (EIA) '
        'Notification, 2006, issued under the Environment (Protection) '
        'Act, 1986, certain categories of projects and activities '
        'require:',
    options: [
      'No clearance if the project cost is below a certain threshold',
      'Prior environmental clearance from the Central Government or '
          'the State Environment Impact Assessment Authority before '
          'commencement',
      'Approval only from the local municipal corporation',
      'Clearance only after the project is completed',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The EIA Notification, 2006 mandates prior environmental '
          'clearance for specified categories of projects (such as '
          'mining, thermal power, and large infrastructure) before '
          'they can lawfully commence construction or operation.',
      reference: 'EIA Notification, 2006',
    ),
  ),
  const QuizQuestion(
    id: 'env-precautionary-principle',
    stem:
        'In Vellore Citizens Welfare Forum v. Union of India (1996), '
        'the Supreme Court held that under the "precautionary '
        'principle":',
    options: [
      'Environmental measures should be taken only after scientific '
          'certainty of harm is established',
      'The burden of proof lies on the person or industry proposing an '
          'action to show that it is environmentally benign, rather '
          'than on the affected community to prove harm',
      'Industries need not take any preventive measures until ordered '
          'by a court',
      'The principle applies only to nuclear industries',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Vellore Citizens Welfare Forum recognized the '
          'precautionary principle as part of Indian environmental '
          'law, placing the onus on the developer/industrialist to '
          'demonstrate that a proposed action will not cause '
          'environmental harm, rather than requiring affected parties '
          'to prove harm after the fact.',
      reference:
          'Vellore Citizens Welfare Forum v. Union of India, '
          '(1996) 5 SCC 647',
    ),
  ),
  const QuizQuestion(
    id: 'env-polluter-pays-principle',
    stem:
        'The "polluter pays principle", as recognized by the Supreme '
        'Court in Indian Council for Enviro-Legal Action v. Union of '
        'India (1996), means that:',
    options: [
      'The government must bear the entire cost of remedying '
          'environmental damage',
      'The polluter is liable to bear the cost of remedying the '
          'environmental damage caused, as well as compensating the '
          'victims, regardless of whether due care was taken',
      'Only criminal penalties can be imposed on a polluter, never '
          'civil liability',
      'The principle applies only to government-owned industries',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The polluter pays principle makes the polluter absolutely '
          'liable for the cost of environmental remediation and '
          'compensation to affected persons, as an essential feature '
          'of sustainable development recognized under Indian law.',
      reference:
          'Indian Council for Enviro-Legal Action v. Union of '
          'India, (1996) 3 SCC 212',
    ),
  ),
  const QuizQuestion(
    id: 'env-public-trust-doctrine',
    stem:
        'In M.C. Mehta v. Kamal Nath (1997), the Supreme Court '
        'applied the "public trust doctrine" to hold that:',
    options: [
      'The State can freely transfer any natural resource to private '
          'parties for commercial exploitation',
      'Certain natural resources, such as rivers, forests, and air, '
          'are held by the State in trust for the free and unimpaired '
          'use of the general public, and cannot be granted to private '
          'parties for commercial purposes inconsistent with that '
          'trust',
      'Only the Central Government, and never the States, owns natural '
          'resources',
      'Private ownership of forests overrides public interest in all '
          'circumstances',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The public trust doctrine holds that certain resources '
          "are meant for public use and remain subject to the "
          "public's right of use, restricting the State from "
          'transferring them for purely private, commercial purposes.',
      reference: 'M.C. Mehta v. Kamal Nath, (1997) 1 SCC 388',
    ),
  ),
  const QuizQuestion(
    id: 'env-sustainable-development',
    stem:
        'The concept of "sustainable development", as recognized by '
        'the Indian judiciary in environmental jurisprudence, primarily '
        'refers to:',
    options: [
      'Development that maximizes short-term industrial profit '
          'regardless of environmental cost',
      'Development that meets the needs of the present generation '
          'without compromising the ability of future generations to '
          'meet their own needs, balancing economic development with '
          'environmental protection',
      'A complete prohibition on all industrial development',
      'Development undertaken exclusively by government-owned '
          'enterprises',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Sustainable development, as adopted in Indian '
          'environmental law following international instruments and '
          'Supreme Court rulings, requires balancing developmental '
          'needs with the imperative of environmental protection for '
          'both present and future generations.',
    ),
  ),
  const QuizQuestion(
    id: 'env-absolute-liability-oleum-gas',
    stem:
        'In the Oleum Gas Leak case, M.C. Mehta v. Union of India '
        '(1987), the Supreme Court evolved the rule of "absolute '
        'liability", under which an enterprise engaged in a hazardous '
        'or inherently dangerous activity is:',
    options: [
      'Liable only if negligence on its part is proved',
      'Absolutely and non-delegably liable for any harm caused, '
          'without any exception based on the defences available under '
          'the traditional rule in Rylands v. Fletcher',
      'Exempt from liability if the harm was caused by an act of a '
          'third party',
      'Liable only for harm caused within its own factory premises',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The absolute liability rule, evolved in the Oleum Gas '
          'Leak case, holds an enterprise engaged in hazardous '
          'activity strictly and absolutely liable for resulting harm, '
          'without the exceptions (such as act of a stranger or act of '
          'God) available under the older Rylands v. Fletcher rule.',
      reference: 'M.C. Mehta v. Union of India, (1987) 1 SCC 395',
    ),
  ),
  const QuizQuestion(
    id: 'env-ngt-appeal-supreme-court',
    stem:
        'Under Section 22 of the National Green Tribunal Act, 2010, '
        'an appeal against an order or decision of the National Green '
        'Tribunal lies to:',
    options: [
      'The concerned State High Court',
      'The Supreme Court of India',
      'The Central Administrative Tribunal',
      'The Ministry of Environment, Forest and Climate Change',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 22 of the NGT Act provides that any person '
          'aggrieved by an order or decision of the Tribunal may file '
          'an appeal directly to the Supreme Court, generally within '
          'ninety days.',
      reference: 'National Green Tribunal Act, 2010, Section 22',
    ),
  ),
  const QuizQuestion(
    id: 'env-article-48a-51a-g',
    stem:
        'Which of the following correctly pairs a constitutional '
        'provision relating to the environment with its nature?',
    options: [
      'Article 48A is a Fundamental Right, and Article 51A(g) is a '
          'Directive Principle',
      'Article 48A is a Directive Principle directing the State to '
          'protect and improve the environment, and Article 51A(g) is '
          'a Fundamental Duty of every citizen to protect and improve '
          'the natural environment',
      'Both Article 48A and Article 51A(g) are Fundamental Rights',
      'Both Article 48A and Article 51A(g) are found in the Ninth '
          'Schedule',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 48A (a Directive Principle) directs the State to '
          'protect and improve the environment, while Article 51A(g) '
          '(a Fundamental Duty) obliges every citizen to protect and '
          'improve the natural environment, including forests, lakes, '
          'rivers, and wildlife.',
      reference: 'Constitution of India, Articles 48A and 51A(g)',
    ),
  ),
];
