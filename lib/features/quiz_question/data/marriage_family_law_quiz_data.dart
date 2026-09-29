import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Marriage & Family Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> marriageFamilyLawQuizQuestions = [
  const QuizQuestion(
    id: 'hma-conditions-marriage',
    stem:
        'Under Section 5 of the Hindu Marriage Act, 1955, which of the '
        'following is NOT a condition for a valid Hindu marriage?',
    options: [
      'Neither party has a spouse living at the time of the marriage',
      'The bridegroom has completed 21 years and the bride 18 years of age',
      'The marriage must be registered within 30 days of solemnization',
      'Neither party is incapable of giving valid consent due to '
          'unsoundness of mind',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Registration is dealt with separately under Section 8 of the '
          'Act and is not a condition for validity — an unregistered Hindu '
          'marriage is still legally valid.',
      reference: 'Hindu Marriage Act, 1955, Section 5',
    ),
  ),
  const QuizQuestion(
    id: 'hma-sapinda-relationship',
    stem:
        'As per Section 3 of the Hindu Marriage Act, 1955, "sapinda '
        'relationship" extends to:',
    options: [
      'The third generation (inclusive) through the mother and the fifth '
          '(inclusive) through the father',
      'The fifth generation (inclusive) through the mother and the third '
          '(inclusive) through the father',
      'The fourth generation (inclusive) on both sides',
      'The seventh generation (inclusive) on both sides',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Section 3(f)(ii) counts generations upward from the person '
          'concerned — three through the mother\'s line and five through '
          'the father\'s line.',
      reference: 'Hindu Marriage Act, 1955, Section 3(f)(ii)',
    ),
  ),
  const QuizQuestion(
    id: 'hma-void-bigamy',
    stem:
        'A Hindu marriage solemnized while either party has a spouse '
        'living from an earlier subsisting marriage is:',
    options: [
      'Voidable at the instance of the aggrieved party',
      'Void ab initio',
      'Valid, but the second spouse cannot claim maintenance',
      'Valid if the marriage is consummated',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 11 read with Section 5(i) declares such a marriage '
          'void from its inception, as it violates the condition of '
          'monogamy.',
      reference: 'Hindu Marriage Act, 1955, Section 11',
    ),
  ),
  const QuizQuestion(
    id: 'hma-voidable-ground',
    stem:
        'Which of the following is a ground for a voidable marriage '
        'under Section 12 of the Hindu Marriage Act, 1955?',
    options: [
      'The marriage was performed without valid rites and ceremonies',
      'The respondent was pregnant by a person other than the petitioner '
          'at the time of marriage',
      'The parties are within the degrees of prohibited relationship',
      'One of the parties was already married at the time of the marriage',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 12(1)(d) makes such a marriage voidable at the '
          'petitioner\'s option, provided proceedings begin within one '
          'year of marriage and intercourse did not occur with knowledge '
          'of the fact.',
      reference: 'Hindu Marriage Act, 1955, Section 12(1)(d)',
    ),
  ),
  const QuizQuestion(
    id: 'sma-notice-period',
    stem:
        'Under the Special Marriage Act, 1954, the notice of an intended '
        'marriage must be published inviting objections for a period of:',
    options: ['15 days', '21 days', '30 days', '60 days'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Sections 5 and 6 require the Marriage Officer to publish the '
          'notice and keep it open for objections for 30 days before the '
          'marriage is solemnized.',
      reference: 'Special Marriage Act, 1954, Sections 5-6',
    ),
  ),
  const QuizQuestion(
    id: 'hama-married-female-adopt',
    stem:
        'Under Section 8 of the Hindu Adoptions and Maintenance Act, '
        '1956 (as amended in 2010), a married Hindu female may adopt a '
        'child:',
    options: [
      'Only with her husband\'s written consent, regardless of his mental '
          'condition',
      'Only if her husband is dead, has completely renounced the world, '
          'has ceased to be a Hindu, or has been declared of unsound mind '
          'by a court',
      'Under no circumstances while her husband is alive',
      'Only if she has no biological children',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The 2010 amendment gave Hindu women independent capacity to '
          'adopt, but a married woman may do so only in these specified '
          'circumstances relating to her husband\'s status.',
      reference: 'Hindu Adoptions and Maintenance Act, 1956, Section 8',
    ),
  ),
  const QuizQuestion(
    id: 'hama-adoption-age-gap',
    stem:
        'Under Section 11 of the Hindu Adoptions and Maintenance Act, '
        '1956, where a male person adopts a female child, the adoptive '
        'father must be older than the child by at least:',
    options: ['15 years', '18 years', '21 years', '25 years'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Section 11(iii) mandates a minimum 21-year age gap when a '
          'male adopts a female child, and a corresponding provision '
          'applies when a female adopts a male child.',
      reference:
          'Hindu Adoptions and Maintenance Act, 1956, Section '
          '11(iii)',
    ),
  ),
  const QuizQuestion(
    id: 'muslim-marriage-nature',
    stem:
        'Under Muslim personal law, marriage (nikah) is essentially '
        'regarded as a:',
    options: [
      'Sacrament that is indissoluble',
      'Civil contract requiring offer (ijab) and acceptance (qabul)',
      'Purely religious ceremony with no contractual element',
      'Union that cannot be made conditional or subject to terms',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Unlike Hindu marriage, nikah is treated as a civil contract '
          'between the parties, requiring free consent, competent parties, '
          'and consideration (mahr/dower).',
    ),
  ),
  const QuizQuestion(
    id: 'triple-talaq-act',
    stem:
        'The Muslim Women (Protection of Rights on Marriage) Act, 2019 '
        'makes the pronouncement of talaq-e-biddat (instant triple talaq) '
        'by a Muslim husband:',
    options: [
      'A valid mode of divorce, subject to registration',
      'Void, illegal, and a punishable offence',
      'Voidable at the instance of the wife',
      'Legal only if pronounced before witnesses',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Following Shayara Bano v. Union of India (2017), the 2019 '
          'Act declares instant triple talaq void and prescribes '
          'imprisonment of up to three years for the husband.',
      reference:
          'Muslim Women (Protection of Rights on Marriage) Act, '
          '2019',
    ),
  ),
  const QuizQuestion(
    id: 'hma-desertion-period',
    stem:
        'Under Section 13(1)(ib) of the Hindu Marriage Act, 1955, '
        '"desertion" as a ground for divorce requires the deserting '
        'spouse to have abandoned the petitioner for a continuous period '
        'of at least:',
    options: ['6 months', '1 year', '2 years', '3 years'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'The Act requires desertion without reasonable cause and '
          'without consent, continuing for not less than two years '
          'immediately preceding presentation of the divorce petition.',
      reference: 'Hindu Marriage Act, 1955, Section 13(1)(ib)',
    ),
  ),
  const QuizQuestion(
    id: 'bnss-maintenance-secular',
    stem:
        'Section 144 of the Bharatiya Nagarik Suraksha Sanhita, 2023 '
        '(corresponding to the earlier Section 125 CrPC), which empowers '
        'a Magistrate to order maintenance for wives, children, and '
        'parents:',
    options: [
      'Applies only to Hindus',
      'Applies irrespective of the religion of the parties, being a '
          'secular social welfare provision',
      'Excludes divorced wives from its scope entirely',
      'Applies only if the marriage was registered',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'This provision cuts across personal laws and applies to all '
          'wives, including divorced wives who have not remarried, '
          'regardless of religion, to prevent vagrancy and destitution.',
      reference: 'Bharatiya Nagarik Suraksha Sanhita, 2023, Section 144',
    ),
  ),
  const QuizQuestion(
    id: 'hmga-natural-guardian',
    stem:
        'Under Section 6 of the Hindu Minority and Guardianship Act, '
        '1956, who is recognized as the natural guardian of a minor Hindu '
        'boy or unmarried girl?',
    options: [
      'The mother alone, in all circumstances',
      'The father, and after him, the mother',
      'The eldest sibling',
      'Only a court-appointed guardian',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 6(a) names the father as natural guardian followed '
          'by the mother, though courts (e.g. Githa Hariharan v. RBI) '
          'have also read this to cover the father\'s absence or '
          'unsuitability; custody of a child under five ordinarily rests '
          'with the mother.',
      reference: 'Hindu Minority and Guardianship Act, 1956, Section 6(a)',
    ),
  ),
  const QuizQuestion(
    id: 'child-marriage-voidable',
    stem:
        'Under the Prohibition of Child Marriage Act, 2006, a child '
        'marriage is:',
    options: [
      'Void ab initio in all cases',
      'Voidable at the option of the party who was a child at the time '
          'of the marriage',
      'Valid and cannot be challenged',
      'Void only if the girl is below 15 years',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 3 allows the party who was a minor at the time of '
          'marriage to petition for annulment within two years of '
          'attaining majority; the marriage is not automatically void '
          '(except in specific aggravated situations under Section 12).',
      reference: 'Prohibition of Child Marriage Act, 2006, Section 3',
    ),
  ),
  const QuizQuestion(
    id: 'bns-dowry-death',
    stem:
        'Under Section 80 of the Bharatiya Nyaya Sanhita, 2023 '
        '(corresponding to the earlier Section 304B IPC), a "dowry death" '
        'is presumed when a woman dies under abnormal circumstances '
        'within how many years of her marriage, having been subjected to '
        'cruelty or harassment for dowry soon before her death?',
    options: ['2 years', '5 years', '7 years', '10 years'],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'If a married woman dies of burns, bodily injury, or '
          'otherwise than under normal circumstances within seven years '
          'of marriage, and was subjected to dowry-related cruelty soon '
          'before death, her husband or in-laws are deemed to have '
          'caused the death.',
      reference: 'Bharatiya Nyaya Sanhita, 2023, Section 80',
    ),
  ),
  const QuizQuestion(
    id: 'article-44-ucc',
    stem:
        'Article 44 of the Constitution of India, which deals with a '
        'Uniform Civil Code, is:',
    options: [
      'A justiciable Fundamental Right',
      'A non-justiciable Directive Principle of State Policy',
      'Part of the Fundamental Duties',
      'An enforceable provision under the Ninth Schedule',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Article 44 obliges the State to "endeavour to secure" a '
          'Uniform Civil Code but, being a Directive Principle under Part '
          'IV, it is not directly enforceable in courts.',
      reference: 'Constitution of India, Article 44',
    ),
  ),
];
