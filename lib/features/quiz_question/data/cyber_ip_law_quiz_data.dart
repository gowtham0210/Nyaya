import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Cyber & Intellectual Property" category
/// quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> cyberIpLawQuizQuestions = [
  const QuizQuestion(
    id: 'cyber-electronic-record',
    stem:
        'Under Section 2(1)(t) of the Information Technology Act, 2000, '
        'an "electronic record" means:',
    options: [
      'Only a handwritten document scanned into a computer',
      'Data, record, or data generated, image or sound stored, received '
          'or sent in an electronic form or microfilm or '
          'computer-generated microfiche',
      'Only a digital signature certificate issued by a certifying '
          'authority',
      'A printed copy of an email',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 2(1)(t) defines "electronic record" broadly to '
          'include data, images, sound, or records stored, generated, '
          'received, or sent in electronic form, or as microfilm/'
          'computer-generated microfiche.',
      reference: 'Information Technology Act, 2000, Section 2(1)(t)',
    ),
  ),
  const QuizQuestion(
    id: 'cyber-technology-neutral-signature',
    stem:
        'The Information Technology (Amendment) Act, 2008 introduced '
        'Section 3A to the IT Act, 2000 primarily to:',
    options: [
      'Abolish digital signatures entirely',
      'Make "digital signature" (based only on an asymmetric '
          'cryptosystem) the sole recognized method of authentication',
      'Introduce technology-neutral "electronic signatures", allowing '
          'authentication methods other than the asymmetric '
          'cryptosystem-based digital signature',
      'Require every electronic record to be notarized',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Section 3A, inserted by the 2008 amendment, made the IT Act '
          'technology-neutral by recognizing "electronic signatures" '
          'generally, rather than confining authentication only to the '
          'asymmetric cryptography-based digital signature under '
          'Section 3.',
      reference: 'Information Technology Act, 2000, Section 3A',
    ),
  ),
  const QuizQuestion(
    id: 'cyber-section-66a-struck-down',
    stem:
        'What is the current status of Section 66A of the Information '
        'Technology Act, 2000, which criminalized sending "offensive" '
        'messages through a computer resource?',
    options: [
      'It remains fully valid and enforceable',
      'It was struck down as unconstitutional by the Supreme Court in '
          'Shreya Singhal v. Union of India (2015)',
      'It was amended to apply only to government officials',
      'It was upheld by the Supreme Court but is rarely enforced',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Supreme Court struck down Section 66A in its entirety '
          'as unconstitutional for violating freedom of speech and '
          'expression under Article 19(1)(a), holding it vague and '
          'overbroad; it is no longer valid law.',
      reference: 'Shreya Singhal v. Union of India, (2015) 5 SCC 1',
    ),
  ),
  const QuizQuestion(
    id: 'cyber-identity-theft',
    stem:
        "Fraudulently or dishonestly using another person's electronic "
        'signature, password, or any other unique identification feature '
        'is punishable under which provision of the IT Act, 2000?',
    options: ['Section 66B', 'Section 66C', 'Section 66D', 'Section 67'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "Section 66C penalizes identity theft — the fraudulent or "
          "dishonest use of another person's electronic signature, "
          'password, or other unique identification feature.',
      reference: 'Information Technology Act, 2000, Section 66C',
    ),
  ),
  const QuizQuestion(
    id: 'cyber-cheating-by-personation',
    stem:
        'A person creates a fake profile impersonating another '
        'individual and uses it to cheat victims out of money through a '
        'computer resource. Which provision of the IT Act, 2000 '
        'specifically addresses this?',
    options: ['Section 66C', 'Section 66D', 'Section 66E', 'Section 66F'],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 66D punishes cheating by personation using a '
          'computer resource or communication device, distinct from '
          'Section 66C, which addresses identity theft as such.',
      reference: 'Information Technology Act, 2000, Section 66D',
    ),
  ),
  const QuizQuestion(
    id: 'cyber-blocking-power',
    stem:
        'The power to direct blocking of public access to online '
        'information "in the interest of the sovereignty and integrity '
        'of India" is conferred on the Central Government under which '
        'provision of the IT Act, 2000?',
    options: ['Section 67', 'Section 69', 'Section 69A', 'Section 79'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Section 69A empowers the Central Government (or its '
          'authorized officers) to direct blocking of public access to '
          'information through any computer resource, on specified '
          'grounds and following a prescribed procedure.',
      reference: 'Information Technology Act, 2000, Section 69A',
    ),
  ),
  const QuizQuestion(
    id: 'cyber-intermediary-safe-harbor',
    stem:
        'Under Section 79 of the IT Act, 2000, an intermediary is '
        'exempt from liability for third-party content hosted on its '
        'platform, provided that:',
    options: [
      'The intermediary actively creates and edits all content itself',
      'The intermediary observes due diligence, including the '
          'obligations prescribed under the Information Technology '
          '(Intermediary Guidelines and Digital Media Ethics Code) '
          'Rules, 2021, and does not initiate or select the transmission',
      'The intermediary charges no fee for its services',
      'The intermediary is owned entirely by an Indian company',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The "safe harbor" under Section 79 is conditional on the '
          'intermediary observing due diligence — including compliance '
          'with the IT Rules, 2021, such as appointing a grievance '
          'officer — and not initiating, selecting the receiver of, or '
          'modifying the transmitted content.',
      reference: 'Information Technology Act, 2000, Section 79',
    ),
  ),
  const QuizQuestion(
    id: 'cyber-dpdp-act',
    stem:
        "Which enactment is India's dedicated statute currently "
        'governing the processing of digital personal data?',
    options: [
      'The Information Technology Act, 2000 alone',
      'The Digital Personal Data Protection Act, 2023',
      'The Right to Information Act, 2005',
      'The Consumer Protection Act, 2019',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "The Digital Personal Data Protection Act, 2023 is India's "
          'dedicated legislation governing the processing of digital '
          'personal data, laying down obligations of data fiduciaries '
          'and rights of data principals, supplementing the general '
          'framework of the IT Act, 2000.',
      reference: 'Digital Personal Data Protection Act, 2023',
    ),
  ),
  const QuizQuestion(
    id: 'ip-idea-expression-dichotomy',
    stem:
        'Under the Copyright Act, 1957, copyright protection subsists '
        'in:',
    options: [
      'The underlying idea, concept, or fact itself',
      'The original expression of an idea, such as a literary, '
          'dramatic, musical, or artistic work',
      'Any information available in the public domain',
      'Facts and news events as such',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Copyright protects the original expression of an idea — '
          'not the idea, concept, procedure, or fact itself — a '
          'principle known as the idea-expression dichotomy.',
      reference: 'Copyright Act, 1957',
    ),
  ),
  const QuizQuestion(
    id: 'ip-fair-dealing',
    stem:
        'Which of the following is a recognized "fair dealing" '
        'exception to copyright infringement under Section 52 of the '
        'Copyright Act, 1957?',
    options: [
      'Reproduction of a literary work for private use or research',
      'Reproducing an entire book for commercial resale',
      'Selling pirated copies of a film for profit',
      "Removing an author's name from a published work",
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Section 52 exempts specified fair dealing uses, such as '
          'private use, research, criticism, review, and reporting of '
          'current events, from constituting copyright infringement; '
          'commercial exploitation or piracy is not covered.',
      reference: 'Copyright Act, 1957, Section 52',
    ),
  ),
  const QuizQuestion(
    id: 'ip-non-patentable-subject-matter',
    stem:
        'Under Section 3 of the Patents Act, 1970, which of the '
        'following is expressly excluded from being a patentable '
        'invention?',
    options: [
      'A novel mechanical device with an inventive step and industrial '
          'application',
      'A mathematical or business method, or a computer programme per '
          'se',
      'A pharmaceutical compound with a new therapeutic use meeting all '
          'patentability criteria',
      'A new industrial process for manufacturing a chemical',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 3(k) of the Patents Act, 1970 excludes mathematical '
          'or business methods, computer programmes per se, and '
          'algorithms from patentability, even if otherwise novel.',
      reference: 'Patents Act, 1970, Section 3(k)',
    ),
  ),
  const QuizQuestion(
    id: 'ip-patent-exclusive-rights',
    stem:
        'Under Section 48 of the Patents Act, 1970, the grant of a '
        'patent confers on the patentee the exclusive right to prevent '
        'third parties from, among other things:',
    options: [
      'Publishing academic articles about the invention',
      'Making, using, offering for sale, selling, or importing the '
          'patented product or process in India without consent',
      'Filing a patent application for a similar invention',
      'Displaying the patented product in a museum',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 48 grants the patentee the exclusive right to '
          'prevent unauthorized making, using, offering for sale, '
          'selling, or importing the patented invention in India, '
          'forming the basis for a patent infringement action.',
      reference: 'Patents Act, 1970, Section 48',
    ),
  ),
  const QuizQuestion(
    id: 'ip-passing-off',
    stem:
        'An action for "passing off" under Indian trademark law is '
        'primarily available to protect:',
    options: [
      'Only a registered trademark, through the statutory infringement '
          'remedy',
      'The goodwill and reputation attached to a trademark against '
          'misrepresentation likely to cause confusion, regardless of '
          'registration',
      'A patented invention against unauthorized use',
      "An author's moral rights in a literary work",
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Passing off is a common law remedy protecting the goodwill '
          'of a mark against misrepresentation causing confusion, '
          'distinct from the statutory infringement remedy under the '
          'Trade Marks Act, 1999, which specifically applies to '
          'registered trademarks.',
      reference: 'Trade Marks Act, 1999',
    ),
  ),
  const QuizQuestion(
    id: 'ip-geographical-indications',
    stem:
        'Under the Geographical Indications of Goods (Registration and '
        'Protection) Act, 1999, an application for registration of a '
        'geographical indication may ordinarily be made by:',
    options: [
      'Any single individual claiming to be the sole producer',
      'Any association of persons, producers, or organisation '
          'representing the interest of the producers of the goods',
      'Only a government ministry',
      'Only a foreign entity',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "Under the GI Act, 1999, registration may be sought by an "
          "association of persons, producers, or an organisation "
          "representing the producers' interests, reflecting the "
          'collective nature of geographical indication rights (e.g., '
          'Darjeeling tea, Basmati rice).',
      reference:
          'Geographical Indications of Goods (Registration and '
          'Protection) Act, 1999',
    ),
  ),
  const QuizQuestion(
    id: 'ip-designs-act-subject-matter',
    stem: 'Under the Designs Act, 2000, protection is granted to:',
    options: [
      'The underlying technical function of an article',
      'Features of shape, configuration, pattern, or ornament applied '
          'to an article, judged solely by the eye',
      'The brand name used to sell an article',
      'The literary description accompanying an article',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "The Designs Act, 2000 protects the visual appearance of an "
          "article — its shape, configuration, pattern, or "
          'ornamentation — as judged solely by the eye, excluding '
          'purely functional features, trademarks, or artistic works '
          'protected under copyright.',
      reference: 'Designs Act, 2000',
    ),
  ),
];
