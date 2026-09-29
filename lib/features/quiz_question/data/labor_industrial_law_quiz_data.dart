import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Labor & Industrial Law" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> laborIndustrialLawQuizQuestions = [
  const QuizQuestion(
    id: 'labor-collective-bargaining',
    stem:
        'Under Indian labour law, what is the primary purpose of '
        'collective bargaining?',
    options: [
      'To settle criminal disputes',
      'To negotiate employment conditions between workers and employers',
      'To appoint judges',
      'To regulate consumer prices',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Collective bargaining is the process by which organized '
          'workers, usually through a trade union, negotiate wages and '
          'working conditions directly with their employer.',
    ),
  ),
  const QuizQuestion(
    id: 'labor-strike-meaning',
    stem: 'Which of the following best describes a strike?',
    options: [
      'Temporary closure of an establishment by an employer',
      "Termination of an employee's service",
      'Collective cessation of work by workers',
      'Transfer of workers to another establishment',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'A strike is a concerted, collective refusal by workers to '
          'continue working, used to press their demands on the employer.',
      reference:
          'Industrial Relations Code, 2020 (formerly Section 2(q), '
          'Industrial Disputes Act, 1947)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-lockout-meaning',
    stem: 'What is a lockout?',
    options: [
      'A temporary closing or suspension of work by an employer',
      'A collective refusal to work by employees',
      "A worker's resignation",
      'A government ban on an industry',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          "A lockout is the employer's counterpart to a strike — the "
          'temporary closing of a place of employment or suspension of '
          'work to pressure workers during a dispute.',
      reference:
          'Industrial Relations Code, 2020 (formerly Section 2(l), '
          'Industrial Disputes Act, 1947)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-dispute-resolution-method',
    stem:
        'Which of the following is a recognized method of resolving '
        'industrial disputes?',
    options: [
      'Conciliation',
      'Criminal prosecution of workers',
      'Consumer litigation',
      'Company liquidation',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Conciliation, mediation, arbitration, and adjudication are '
          "the recognized mechanisms for resolving industrial disputes "
          'under Indian labour law.',
    ),
  ),
  const QuizQuestion(
    id: 'labor-conciliation-officer',
    stem:
        'What is the main function of a Conciliation Officer in an '
        'industrial dispute?',
    options: [
      'To punish employees',
      'To promote settlement between the parties',
      'To terminate workers',
      'To determine criminal liability',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A Conciliation Officer mediates between the employer and '
          'workers to help them reach a fair, amicable settlement — they '
          'do not adjudicate or punish.',
      reference:
          'Industrial Relations Code, 2020 (formerly Section 4, '
          'Industrial Disputes Act, 1947)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-trade-union',
    stem:
        'Which organization primarily represents the collective '
        'interests of workers?',
    options: [
      'Trade Union',
      'Consumer Forum',
      'Registrar of Companies',
      'Election Commission',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'A trade union is an association of workers formed to protect '
          'and advance their collective interests in matters like wages, '
          'working conditions, and job security.',
      reference:
          'Trade Unions Act, 1926 (now part of the Industrial '
          'Relations Code, 2020)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-retrenchment',
    stem: 'What does "retrenchment" generally refer to in industrial law?',
    options: [
      'Promotion of a worker',
      'Termination of service by an employer for reasons recognized by '
          'labour law',
      'Grant of additional leave',
      'Increase in wages',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Retrenchment is the termination of a workman\'s service by '
          'the employer for reasons such as surplus staff, distinct from '
          'dismissal as punishment, voluntary retirement, or '
          'superannuation.',
      reference:
          'Industrial Relations Code, 2020 (formerly Section '
          '2(oo), Industrial Disputes Act, 1947)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-minimum-wage',
    stem: 'What is the primary objective of minimum wage legislation?',
    options: [
      'To guarantee maximum profits to employers',
      'To prevent workers from forming unions',
      'To ensure workers receive at least the legally prescribed minimum '
          'remuneration',
      'To increase working hours',
    ],
    correctOption: 2,
    explanation: QuizExplanation(
      core:
          'Minimum wage laws protect workers from exploitation by '
          'guaranteeing a statutorily fixed floor on their remuneration.',
      reference: 'Code on Wages, 2019 (formerly Minimum Wages Act, 1948)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-welfare-objective',
    stem:
        'Which of the following is an important objective of labour '
        'welfare measures?',
    options: [
      "Improving workers' health, safety and working conditions",
      'Increasing industrial disputes',
      'Reducing worker protection',
      'Eliminating trade unions',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          "Labour welfare measures aim to improve workers' health, "
          'safety, and general working and living conditions.',
    ),
  ),
  const QuizQuestion(
    id: 'labor-arbitration',
    stem: 'What is arbitration in the context of industrial disputes?',
    options: [
      'Settlement of a dispute by a mutually accepted arbitrator',
      'Dismissal of all employees',
      'A strike organized by workers',
      'Closure of an industry by the government',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'In arbitration, the employer and workers voluntarily refer '
          'their dispute to an arbitrator of their mutual choice, whose '
          'decision (award) is binding on them.',
      reference:
          'Industrial Relations Code, 2020 (formerly Section 10A, '
          'Industrial Disputes Act, 1947)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-occupational-safety',
    stem:
        'Which of the following is most closely associated with '
        'occupational safety?',
    options: [
      'Providing a safe and healthy working environment',
      'Increasing employee working hours without limits',
      'Reducing workplace facilities',
      'Preventing workers from receiving wages',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Occupational safety concerns the measures taken to provide '
          'workers with a safe and healthy workplace, free from '
          'preventable hazards.',
      reference:
          'Occupational Safety, Health and Working Conditions '
          'Code, 2020 (formerly the Factories Act, 1948)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-social-security',
    stem:
        'What is the basic purpose of social security legislation for '
        'workers?',
    options: [
      'To provide protection against certain social and economic risks',
      'To increase industrial disputes',
      'To eliminate employment contracts',
      'To regulate elections',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Social security legislation protects workers against risks '
          'such as sickness, old age, disability, unemployment, and '
          'maternity.',
      reference:
          'Code on Social Security, 2020 (formerly the EPF Act, '
          '1952, ESI Act, 1948, and Maternity Benefit Act, 1961)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-industrial-dispute-definition',
    stem:
        'Which of the following can be considered an industrial '
        'dispute?',
    options: [
      'A disagreement between two consumers',
      'A dispute between employer and workers concerning employment or '
          'working conditions',
      'A dispute between two students',
      'A disagreement between two unrelated businesses',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An industrial dispute is a dispute or difference between '
          'employers and workmen, or between workmen and workmen, '
          'connected with employment, non-employment, or the terms and '
          'conditions of labour.',
      reference:
          'Industrial Relations Code, 2020 (formerly Section 2(k), '
          'Industrial Disputes Act, 1947)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-court-tribunal',
    stem:
        'What is the primary purpose of a Labour Court or Industrial '
        'Tribunal?',
    options: [
      'To hear and adjudicate certain labour and industrial disputes',
      'To conduct criminal investigations',
      'To regulate stock markets',
      'To issue passports',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Labour Courts and Industrial Tribunals are adjudicatory '
          'bodies constituted to hear and decide specified categories of '
          'industrial and labour disputes referred to them.',
      reference:
          'Industrial Relations Code, 2020 (formerly Sections 7 '
          'and 7A, Industrial Disputes Act, 1947)',
    ),
  ),
  const QuizQuestion(
    id: 'labor-equal-pay',
    stem:
        'Which principle aims to prevent unjustified discrimination in '
        'remuneration for workers performing substantially similar work?',
    options: [
      'Right to property',
      'Equal pay for equal work',
      'Freedom of contract only',
      'Rule against perpetuity',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Equal pay for equal work requires that workers performing '
          'substantially similar work be paid equally, without '
          'discrimination based on gender or other irrelevant factors.',
      reference:
          'Constitution of India, Article 39(d); Equal '
          'Remuneration Act, 1976 (now part of the Code on Wages, 2019)',
    ),
  ),
];
