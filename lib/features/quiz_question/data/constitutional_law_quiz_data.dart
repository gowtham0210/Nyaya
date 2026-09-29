import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Constitutional Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> constitutionalLawQuizQuestions = [
  const QuizQuestion(
    id: 'const-dpsp-article-37',
    stem:
        'Article 37 of the Constitution of India provides that the '
        'Directive Principles of State Policy are:',
    options: [
      'Enforceable in a court of law like Fundamental Rights',
      'Not enforceable by any court, but nevertheless fundamental in '
          'the governance of the country',
      'Binding only on the Union government, not the States',
      'Automatically void if inconsistent with any ordinary law',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 37 declares DPSPs non-justiciable, yet fundamental '
          'in governance, obliging the State to apply them while making '
          'laws.',
      reference: 'Constitution of India, Article 37',
    ),
  ),
  const QuizQuestion(
    id: 'const-fundamental-duties-42nd-amendment',
    stem:
        'Fundamental Duties were inserted into the Constitution of '
        'India under Article 51A by which constitutional amendment?',
    options: [
      '24th Amendment, 1971',
      '42nd Amendment, 1976',
      '44th Amendment, 1978',
      '86th Amendment, 2002',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The 42nd Amendment, 1976, added Part IVA (Article 51A) '
          'listing the Fundamental Duties of citizens, based on the '
          'recommendations of the Swaran Singh Committee.',
      reference: 'Constitution of India, Article 51A',
    ),
  ),
  const QuizQuestion(
    id: 'const-money-bill-speaker',
    stem:
        'Under Article 110 of the Constitution, if a question arises '
        'whether a Bill is a Money Bill, the decision of which authority '
        'is final?',
    options: [
      'The President of India',
      'The Chairman of the Rajya Sabha',
      'The Speaker of the Lok Sabha',
      'The Supreme Court of India',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          "Article 110(3) makes the Speaker of the Lok Sabha's "
          'certification on whether a Bill is a Money Bill final, and '
          'the Rajya Sabha can only make recommendations, which the Lok '
          'Sabha may accept or reject.',
      reference: 'Constitution of India, Article 110(3)',
    ),
  ),
  const QuizQuestion(
    id: 'const-ordinance-article-123',
    stem:
        "The President's power to promulgate an Ordinance under "
        'Article 123 of the Constitution can be exercised only when:',
    options: [
      'Both Houses of Parliament are in session',
      'Either House of Parliament is not in session and the President '
          'is satisfied that immediate action is necessary',
      'The Supreme Court grants prior permission',
      'A national emergency has been proclaimed',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 123 empowers the President to promulgate '
          'Ordinances when Parliament (or either House) is not in '
          'session and immediate action is necessary; such an Ordinance '
          'must be laid before Parliament and ceases to operate six '
          'weeks after reassembly unless approved.',
      reference: 'Constitution of India, Article 123',
    ),
  ),
  const QuizQuestion(
    id: 'const-collective-responsibility',
    stem:
        'Under Article 75(3) of the Constitution, the Council of '
        'Ministers is collectively responsible to:',
    options: [
      'The President of India',
      'The Rajya Sabha',
      'The Lok Sabha',
      'The Supreme Court',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Article 75(3) establishes that the Council of Ministers is '
          'collectively responsible to the House of the People (Lok '
          'Sabha), the principle underlying parliamentary accountability '
          'of the executive.',
      reference: 'Constitution of India, Article 75(3)',
    ),
  ),
  const QuizQuestion(
    id: 'const-article-32-vs-226',
    stem:
        'Which of the following correctly distinguishes the writ '
        'jurisdiction of the Supreme Court under Article 32 from that of '
        'a High Court under Article 226?',
    options: [
      'The Supreme Court can issue writs only for enforcement of '
          'Fundamental Rights, while a High Court can issue writs for '
          'enforcement of Fundamental Rights and for any other purpose',
      'A High Court can issue writs only within the territory of Delhi',
      'Article 32 is a directive principle, while Article 226 is a '
          'fundamental right',
      'Only the Supreme Court can issue the writ of habeas corpus',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          "Article 32 confines the Supreme Court's writ jurisdiction "
          'to enforcement of Fundamental Rights, whereas Article 226 '
          'grants High Courts a wider power to issue writs both for '
          'Fundamental Rights and for any other legal purpose.',
      reference: 'Constitution of India, Articles 32 and 226',
    ),
  ),
  const QuizQuestion(
    id: 'const-judicial-review',
    stem:
        'The power of "judicial review" in Indian constitutional law '
        'refers to the power of courts to:',
    options: [
      'Draft new legislation on behalf of Parliament',
      'Examine the constitutional validity of legislative and executive '
          'action and declare it void if inconsistent with the '
          'Constitution',
      'Remove a sitting judge from office',
      'Amend the Constitution directly',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Judicial review empowers constitutional courts to test the '
          'validity of laws and executive actions against the '
          'Constitution, striking them down if inconsistent with it — '
          "recognized as part of the Constitution's basic structure.",
    ),
  ),
  const QuizQuestion(
    id: 'const-basic-structure-kesavananda',
    stem:
        'In Kesavananda Bharati v. State of Kerala (1973), the Supreme '
        'Court held that:',
    options: [
      'Parliament has unlimited power to amend any part of the '
          'Constitution, including Fundamental Rights, without '
          'restriction',
      "Parliament's power to amend the Constitution under Article 368 "
          'does not extend to altering its "basic structure"',
      'The Constitution can never be amended under any circumstances',
      'Only the President can amend the Constitution',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The 13-judge bench in Kesavananda Bharati held that while '
          'Parliament has wide amending power under Article 368, it '
          'cannot alter the "basic structure" of the Constitution, such '
          'as the supremacy of the Constitution or judicial review.',
      reference:
          'Kesavananda Bharati v. State of Kerala, (1973) 4 SCC '
          '225',
    ),
  ),
  const QuizQuestion(
    id: 'const-seventh-schedule',
    stem:
        'The distribution of legislative powers between the Union and '
        'the States in India is primarily set out in:',
    options: [
      'The Preamble',
      'The Seventh Schedule, through the Union List, State List, and '
          'Concurrent List',
      'The Ninth Schedule',
      'Part III of the Constitution',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Seventh Schedule divides legislative subjects among '
          'the Union List, State List, and Concurrent List, read with '
          "Article 246, forming the basis of India's federal "
          'distribution of powers.',
      reference: 'Constitution of India, Article 246, Seventh Schedule',
    ),
  ),
  const QuizQuestion(
    id: 'const-article-356-bommai',
    stem:
        'In S.R. Bommai v. Union of India (1994), the Supreme Court '
        'held that a Proclamation of President\'s Rule under Article 356:',
    options: [
      'Can never be reviewed by any court',
      "Is subject to judicial review, and the President's satisfaction "
          'must be based on relevant material',
      'Can only be challenged in the Lok Sabha, not in court',
      "Automatically dissolves the Supreme Court's jurisdiction over "
          'the state',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'S.R. Bommai held that a Proclamation under Article 356 is '
          'subject to judicial review and can be struck down if based '
          'on mala fide or irrelevant grounds, curbing its earlier '
          'misuse.',
      reference: 'S.R. Bommai v. Union of India, (1994) 3 SCC 1',
    ),
  ),
  const QuizQuestion(
    id: 'const-habeas-corpus',
    stem:
        'A person is taken into custody by the police and detained '
        'without being produced before a magistrate or informed of any '
        'charge. Which writ can be invoked to secure their release?',
    options: ['Mandamus', 'Certiorari', 'Habeas Corpus', 'Quo Warranto'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Habeas corpus ("to have the body") directs the detaining '
          'authority to produce the detained person before the court '
          'and justify the legality of the detention; unlawful '
          'detention warrants their release.',
    ),
  ),
  const QuizQuestion(
    id: 'const-mandamus',
    stem: 'The writ of "mandamus" is issued by a court primarily to:',
    options: [
      'Quash an order already passed by an inferior court or tribunal',
      'Command a public authority to perform a public duty it has '
          'failed or refused to perform',
      'Restrain a person from holding a public office to which they '
          'are not entitled',
      'Secure the release of a person from illegal detention',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Mandamus is a command issued by a court directing a public '
          'authority to perform a statutory or public duty that it has '
          'failed to discharge.',
    ),
  ),
  const QuizQuestion(
    id: 'const-amendment-federal-provisions',
    stem:
        'Which category of constitutional amendment under Article 368 '
        'requires ratification by the legislatures of not less than '
        'one-half of the States, in addition to a special majority in '
        'Parliament?',
    options: [
      'An amendment altering the boundaries of a State',
      'An amendment affecting federal provisions, such as the manner of '
          'election of the President or the distribution of legislative '
          'powers between the Union and the States',
      'An amendment to the Fundamental Duties',
      'An amendment inserting a new entry in the Union List alone, '
          'without affecting the States',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Amendments affecting specified federal provisions — such '
          'as the election of the President, or the distribution of '
          'powers between the Union and the States — require '
          'ratification by at least half the State legislatures, '
          'besides the special majority in Parliament under Article '
          '368.',
      reference: 'Constitution of India, Article 368',
    ),
  ),
  const QuizQuestion(
    id: 'const-pith-and-substance',
    stem:
        'The doctrine of "pith and substance" is applied by courts to '
        'resolve:',
    options: [
      'Conflicts between two Fundamental Rights',
      "A challenge to a law on the ground that it incidentally "
          "trenches upon a subject outside the enacting legislature's "
          'competence, by examining the true nature and substance of '
          'the legislation',
      'Disputes regarding the interpretation of a contract',
      'The validity of a Presidential Ordinance alone',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Under the pith and substance doctrine, courts examine the '
          'true nature and substance of an enactment to determine its '
          "dominant subject matter; if that falls within the "
          "legislature's competence, the law is not invalid merely "
          'because it incidentally touches upon a matter outside that '
          'competence.',
    ),
  ),
  const QuizQuestion(
    id: 'const-colourable-legislation',
    stem:
        'The doctrine of "colourable legislation" is based on the '
        'principle that:',
    options: [
      'A legislature can validly do indirectly what it is prohibited '
          'from doing directly',
      'What cannot be done directly by a legislature due to a '
          'constitutional limitation cannot be done indirectly by '
          'employing an indirect method or disguise',
      'All legislation must be printed in color for validity',
      'Courts cannot examine the motive behind any legislation',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The colourable legislation doctrine holds that a '
          'legislature cannot do indirectly what it is constitutionally '
          'prohibited from doing directly; courts examine the true '
          'legislative competence behind the form of the enactment, not '
          'its stated motive.',
    ),
  ),
];
