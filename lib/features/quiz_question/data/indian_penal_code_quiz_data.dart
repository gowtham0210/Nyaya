import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Indian Penal Code Quiz" popular-quiz
/// card.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> indianPenalCodeQuizQuestions = [
  const QuizQuestion(
    id: 'ipc-murder-definition',
    stem:
        'Culpable homicide amounts to murder when the act causing death '
        'is done with the intention of causing death, or with the '
        'intention of causing a bodily injury that:',
    options: [
      'The offender knows to be likely to cause death',
      'The offender knows is sufficient in the ordinary course of nature '
          'to cause death',
      'Was caused accidentally',
      'Was caused in self-defence',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'One of the clauses defining murder requires an intention to '
          'cause a bodily injury sufficient, in the ordinary course of '
          'nature, to cause death — a higher threshold than merely '
          'knowing death is likely.',
      reference:
          'Bharatiya Nyaya Sanhita, 2023, Section 101 (formerly '
          'Section 300, Indian Penal Code, 1860)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-grave-sudden-provocation',
    stem:
        'A person kills another in the heat of the moment after being '
        'suddenly and gravely provoked, losing self-control. This '
        'generally reduces the offence from murder to:',
    options: [
      'Culpable homicide not amounting to murder',
      'Theft',
      'Criminal conspiracy',
      'No offence at all',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Grave and sudden provocation that deprives a person of '
          'self-control is a recognized exception that brings the killing '
          'down from murder to culpable homicide not amounting to murder, '
          'provided the accused did not act in a cruel or unusual manner.',
      reference:
          'Bharatiya Nyaya Sanhita, 2023, Section 101, Exception 1 '
          '(formerly Section 300, Exception 1, Indian Penal Code, 1860)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-kidnapping-vs-abduction',
    stem:
        'Which of the following distinguishes kidnapping from '
        'abduction under Indian criminal law?',
    options: [
      'Kidnapping applies only to a minor or a person of unsound mind '
          'taken out of lawful guardianship, while abduction can involve '
          'a person of any age moved by force or deception',
      'They are legally identical with no difference',
      'Abduction always requires the use of a weapon',
      'Kidnapping applies only to adults',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Kidnapping is specifically about taking a minor or person of '
          'unsound mind out of the keeping of a lawful guardian without '
          'consent, whereas abduction covers compelling or deceptively '
          'inducing any person to go from any place, regardless of age.',
      reference:
          'Indian Penal Code, 1860, Sections 359-362 (now '
          'consolidated under the Bharatiya Nyaya Sanhita, 2023)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-criminal-breach-of-trust',
    stem: 'Criminal breach of trust essentially involves:',
    options: [
      'Taking property without any prior entrustment',
      'Dishonest misappropriation or conversion of property that was '
          'entrusted to the accused',
      'Making a false document',
      'Publishing defamatory material',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Criminal breach of trust requires that property first be '
          'entrusted to the accused, who then dishonestly misappropriates '
          'or converts it for their own use in violation of that trust — '
          'unlike theft, which involves no prior entrustment.',
      reference:
          'Indian Penal Code, 1860, Section 405 (now Bharatiya '
          'Nyaya Sanhita, 2023, Section 316)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-cheating',
    stem: 'The offence of cheating requires that the accused:',
    options: [
      'Dishonestly or fraudulently induces a person to deliver property '
          'or do something they would not otherwise have done',
      'Merely fails to repay a debt',
      'Breaches a civil contract without any deception',
      'Takes property forcibly',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Cheating requires fraudulent or dishonest inducement leading '
          'the victim to deliver property, consent to retention of '
          'property, or do or omit an act — mere non-payment of a debt, '
          'without deception, is not cheating.',
      reference:
          'Indian Penal Code, 1860, Section 415 (now Bharatiya '
          'Nyaya Sanhita, 2023, Section 318)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-forgery',
    stem: 'Forgery is committed when a person:',
    options: [
      'Makes a false document with intent to cause damage, support a '
          'claim, or commit fraud',
      'Loses an original document',
      'Signs their own document truthfully',
      'Destroys a document by accident',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Forgery is the making of a false document or electronic '
          'record with the intent to cause damage or injury, to support a '
          'claim, or to commit fraud.',
      reference:
          'Indian Penal Code, 1860, Section 463 (now consolidated '
          'under the Bharatiya Nyaya Sanhita, 2023)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-defamation-exception',
    stem:
        'Which of the following is a recognized exception to the '
        'offence of defamation?',
    options: [
      'Imputation of truth made for the public good',
      'Any false statement made in anger',
      'Rumours spread anonymously',
      'Statements made purely to harm reputation',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Truth is a defence to defamation only when the imputation is '
          'also made for the public good — truth alone, without public '
          'benefit, is not automatically a complete defence.',
      reference:
          'Indian Penal Code, 1860, Section 499, Exception 1 (now '
          'Bharatiya Nyaya Sanhita, 2023, Section 356)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-extortion-vs-theft',
    stem:
        'Extortion differs from theft primarily because extortion '
        'involves:',
    options: [
      'Taking property without the owner ever being aware',
      'Intentionally putting a person in fear of injury to dishonestly '
          'induce them to deliver property or valuable security',
      'No dishonest intention at all',
      'Only offences against public property',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Extortion requires putting a person in fear of injury to '
          'dishonestly induce them to hand over property — the victim '
          'parts with the property under that fear, unlike theft where '
          'property is taken without the owner\'s consent.',
      reference:
          'Indian Penal Code, 1860, Section 383 (now Bharatiya '
          'Nyaya Sanhita, 2023, Section 308)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-dacoity',
    stem:
        'Robbery is classified as dacoity when it is committed jointly '
        'by:',
    options: [
      'Any two persons',
      'Five or more persons',
      'A single person acting alone',
      'Only government officials',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Robbery becomes dacoity when it is committed, or attempted, '
          'jointly by five or more persons.',
      reference:
          'Indian Penal Code, 1860, Section 391 (now Bharatiya '
          'Nyaya Sanhita, 2023, Section 310)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-unsoundness-of-mind',
    stem:
        "The general exception of 'unsoundness of mind' excuses an "
        'accused from criminal liability when, at the time of the act, '
        'they were:',
    options: [
      'Merely angry or emotional',
      'Incapable, by reason of unsoundness of mind, of knowing the '
          'nature of the act or that it was wrong or contrary to law',
      'Under the influence of a lawful medical prescription',
      'Simply forgetful',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'This defence (based on the McNaughten Rule) applies only if, '
          'due to unsoundness of mind, the accused was incapable of '
          'knowing the nature of the act, or that it was wrong or '
          'contrary to law — not for mere emotional disturbance.',
      reference:
          'Bharatiya Nyaya Sanhita, 2023, Section 22 (formerly '
          'Section 84, Indian Penal Code, 1860)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-common-intention',
    stem:
        'For criminal liability to attach to several persons under the '
        'principle of "common intention", there must be:',
    options: [
      'Mere presence of the accused at the scene, without more',
      'A prior meeting of minds and a shared plan to commit the criminal '
          'act, however brief',
      'A written agreement signed by all accused',
      'At least one accused already convicted separately',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Common intention requires a prior meeting of minds — a '
          'shared plan, even if formed in a moment — before or during the '
          'act, so that each participant becomes liable for the act as if '
          'done by them alone.',
      reference:
          'Bharatiya Nyaya Sanhita, 2023, Section 3(5) (formerly '
          'Section 34, Indian Penal Code, 1860)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-attempt-to-murder',
    stem: 'The offence of attempt to murder requires:',
    options: [
      'Only an intention to kill, without any act',
      'An act done with the intention or knowledge required for murder, '
          'and under such circumstances that if death had resulted the '
          'offender would be guilty of murder',
      'That the victim must actually die',
      'That the accused merely threatened the victim verbally',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Attempt to murder requires a direct act done with the '
          'intention or knowledge that would make the offender guilty of '
          'murder if death had actually resulted — mere threats or '
          'intention alone are not enough.',
      reference:
          'Bharatiya Nyaya Sanhita, 2023, Section 109 (formerly '
          'Section 307, Indian Penal Code, 1860)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-grievous-hurt',
    stem:
        'Which of the following is specifically classified as '
        '"grievous hurt" rather than simple hurt?',
    options: [
      'A minor bruise that heals within a day',
      'Permanent loss of sight in one eye',
      'A slight scratch',
      'Temporary discomfort with no injury',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The law specifically enumerates certain injuries — such as '
          'permanent privation of sight or hearing, fracture, or '
          'emasculation — as grievous hurt, which carries a higher '
          'punishment than simple hurt.',
      reference:
          'Indian Penal Code, 1860, Section 320 (now consolidated '
          'under the Bharatiya Nyaya Sanhita, 2023)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-sedition-successor',
    stem:
        'The offence of sedition under the old Section 124A of the '
        'Indian Penal Code, 1860 has been:',
    options: [
      'Retained exactly as it was, unchanged',
      'Repealed and reformulated as a provision on acts endangering the '
          "sovereignty, unity, and integrity of India",
      'Converted into a purely civil wrong',
      'Abolished with no replacement provision at all',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'The Bharatiya Nyaya Sanhita, 2023 repealed the colonial-era '
          'sedition provision and replaced it with a reformulated offence '
          'targeting acts endangering the sovereignty, unity, and '
          'integrity of India.',
      reference:
          'Bharatiya Nyaya Sanhita, 2023, Section 152 (formerly '
          'Section 124A, Indian Penal Code, 1860)',
    ),
  ),
  const QuizQuestion(
    id: 'ipc-doli-incapax',
    stem: 'Under Indian criminal law, a child below the age of 7 years:',
    options: [
      'Can never be held criminally liable for any act, regardless of '
          'circumstances',
      'Is always treated the same as an adult offender',
      'Is punished more severely than an adult for the same act',
      'Requires no special protection at all',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Nothing done by a child below 7 years of age is an offence, '
          'reflecting the principle of doli incapax; a child between 7 '
          'and 12 is protected too, but only if they have not attained '
          'sufficient maturity to understand the nature and consequences '
          'of the act.',
      reference:
          'Bharatiya Nyaya Sanhita, 2023, Sections 20-21 (formerly '
          'Sections 82-83, Indian Penal Code, 1860)',
    ),
  ),
];
