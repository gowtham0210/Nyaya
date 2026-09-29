import '../presentation/quiz_session_view_model.dart';

/// The 15 questions behind Home's "Property & Real Estate" category quiz.
///
/// Hardcoded on purpose: no backend or database exists yet. This is a
/// separate list from the other sample sessions so those (and their tests)
/// keep behaving exactly as before.
final List<QuizQuestion> propertyRealEstateLawQuizQuestions = [
  const QuizQuestion(
    id: 'property-transfer-definition',
    stem:
        'Under Section 5 of the Transfer of Property Act, 1882, '
        '"transfer of property" means an act by which a living person '
        'conveys property:',
    options: [
      'Only to the State Government',
      'In present or in future, to one or more other living persons, '
          'or to himself and one or more other living persons',
      'Only by way of a registered will',
      'Only through a court decree',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 5 defines transfer of property as an act by which '
          'a living person conveys property, in present or in future, '
          'to one or more other living persons (including to himself).',
      reference: 'Transfer of Property Act, 1882, Section 5',
    ),
  ),
  const QuizQuestion(
    id: 'property-sale-registration',
    stem:
        'Under Section 54 of the Transfer of Property Act, 1882, a '
        '"sale" of tangible immovable property of the value of one '
        'hundred rupees or more can be made only by:',
    options: [
      'Delivery of possession alone',
      'A registered instrument',
      'An oral agreement witnessed by two persons',
      'Payment of the full price in cash',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 54 requires a sale of tangible immovable property '
          'valued at Rs. 100 or more to be effected only through a '
          'registered instrument; for property below that value, sale '
          'may be made by registered instrument or by delivery of the '
          'property.',
      reference: 'Transfer of Property Act, 1882, Section 54',
    ),
  ),
  const QuizQuestion(
    id: 'property-mortgage-definition',
    stem:
        'Under Section 58(a) of the Transfer of Property Act, 1882, a '
        '"mortgage" is defined as:',
    options: [
      'An absolute transfer of ownership in immovable property',
      'The transfer of an interest in specific immovable property for '
          'the purpose of securing the payment of money advanced or to '
          'be advanced by way of loan, or the performance of an '
          'engagement giving rise to a pecuniary liability',
      'A lease of immovable property for a fixed term',
      'A gift of immovable property without consideration',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A mortgage transfers only an interest in specific '
          'immovable property, as security for a debt or the '
          'performance of a pecuniary obligation — ownership does not '
          'pass to the mortgagee.',
      reference: 'Transfer of Property Act, 1882, Section 58(a)',
    ),
  ),
  const QuizQuestion(
    id: 'property-usufructuary-mortgage',
    stem:
        'In a "usufructuary mortgage" under Section 58(d) of the '
        'Transfer of Property Act, 1882, the mortgagee is entitled to:',
    options: [
      'Sue the mortgagor personally for the mortgage debt',
      'Retain possession of the mortgaged property and receive its '
          'rents or profits in lieu of interest or in payment of the '
          'mortgage money',
      'Immediately become the absolute owner of the property',
      'Foreclose the property without any notice',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'In a usufructuary mortgage, the mortgagor delivers '
          'possession to the mortgagee, who retains it and appropriates '
          'the rents/profits towards interest or the principal, without '
          'any personal liability on the mortgagor to repay.',
      reference: 'Transfer of Property Act, 1882, Section 58(d)',
    ),
  ),
  const QuizQuestion(
    id: 'property-lease-definition',
    stem:
        'Under Section 105 of the Transfer of Property Act, 1882, a '
        '"lease" of immovable property is a transfer of:',
    options: [
      'Ownership of the property to the lessee',
      'A right to enjoy the property, made for a certain time or in '
          'perpetuity, in consideration of a price paid or promised, '
          'or money, a share of crops, service, or other thing of '
          'value, rendered periodically or on specified occasions',
      'Only a personal license to use the property temporarily',
      'A mortgage interest in the property',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A lease transfers only the right to enjoy the property for '
          'the agreed term or in perpetuity, in exchange for rent or '
          'other consideration — ownership remains with the lessor.',
      reference: 'Transfer of Property Act, 1882, Section 105',
    ),
  ),
  const QuizQuestion(
    id: 'property-lease-vs-license',
    stem:
        'Which of the following is the key legal test used by Indian '
        'courts to distinguish a "lease" from a "license" in respect of '
        'immovable property?',
    options: [
      'Whether the agreement is in writing',
      'Whether the grantee has been given exclusive possession of the '
          'property, coupled with an intention to create an interest '
          'in the land',
      'Whether rent is paid monthly or annually',
      'Whether the property is residential or commercial',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Courts primarily examine whether exclusive possession was '
          'granted with an intention to create an interest in the '
          'property (a lease) or merely permission to use it without '
          'transferring any interest (a license).',
      reference:
          'Associated Hotels of India Ltd. v. R.N. Kapoor, AIR '
          '1959 SC 1262',
    ),
  ),
  const QuizQuestion(
    id: 'property-gift-registration',
    stem:
        'Under Sections 122 and 123 of the Transfer of Property Act, '
        '1882, a gift of immovable property is valid only if it is:',
    options: [
      'Made orally before two witnesses',
      "Effected by a registered instrument, signed by or on behalf of "
          "the donor and attested by at least two witnesses, and "
          "accepted by the donee during the donor's lifetime",
      'Made only in favour of a blood relative',
      "Recorded in the donor's will",
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 123 mandates that a gift of immovable property be '
          'made through a registered and attested instrument, and '
          'Section 122 requires the gift to be accepted by the donee '
          "while the donor is still alive and competent to give.",
      reference: 'Transfer of Property Act, 1882, Sections 122-123',
    ),
  ),
  const QuizQuestion(
    id: 'property-exchange-definition',
    stem:
        'Under Section 118 of the Transfer of Property Act, 1882, an '
        '"exchange" occurs when:',
    options: [
      'Two persons mutually transfer the ownership of one thing for '
          'the ownership of another, neither thing being money only',
      'One person sells property to another for a fixed price in money',
      'A person mortgages property in return for a loan',
      'A tenant sublets leased property to a third party',
    ],
    correctOption: 0,
    explanation: QuizExplanation(
      core:
          'Exchange is the mutual transfer of ownership of one thing '
          'for the ownership of another, where neither of the things '
          'exchanged is money alone; if one item is wholly money, the '
          'transaction is a sale.',
      reference: 'Transfer of Property Act, 1882, Section 118',
    ),
  ),
  const QuizQuestion(
    id: 'property-actionable-claim',
    stem:
        'Under Section 3 of the Transfer of Property Act, 1882, an '
        '"actionable claim" refers to:',
    options: [
      "A claim to any tangible movable property in the claimant's "
          'possession',
      'A claim to an unsecured debt, or to a beneficial interest in '
          'movable property not in the possession (actual or '
          'constructive) of the claimant, which a civil court '
          'recognizes as affording grounds for relief',
      'A claim that can only be enforced through arbitration',
      'A claim relating exclusively to immovable property',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          "An actionable claim covers unsecured debts and beneficial "
          "interests in movable property not in the claimant's "
          'possession, which civil courts recognize as a valid ground '
          'for relief — such claims are transferable under the Act.',
      reference: 'Transfer of Property Act, 1882, Section 3',
    ),
  ),
  const QuizQuestion(
    id: 'property-easement-definition',
    stem:
        'Under Section 4 of the Indian Easements Act, 1882, an '
        '"easement" is a right possessed by the owner or occupier of '
        'land for the beneficial enjoyment of that land, to:',
    options: [
      'Sell the land to a third party without restriction',
      'Do and continue to do something, or to prevent and continue to '
          'prevent something being done, in or upon certain other land '
          'not his own',
      'Mortgage the land to secure a loan',
      'Lease the land to a tenant',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'An easement is a right attached to the dominant land, '
          "exercisable over another person's (servient) land, allowing "
          'the holder to do or restrain something for the beneficial '
          'enjoyment of their own land.',
      reference: 'Indian Easements Act, 1882, Section 4',
    ),
  ),
  const QuizQuestion(
    id: 'property-lis-pendens',
    stem:
        'The doctrine of "lis pendens" under Section 52 of the '
        'Transfer of Property Act, 1882 provides that:',
    options: [
      'Property that is the subject matter of a pending suit can be '
          'freely transferred without any restriction',
      'Immovable property that is the subject matter of a suit in '
          'which a right to it is directly and specifically in '
          'question cannot be transferred so as to affect the rights '
          'of any other party to the suit, during its pendency',
      'A suit automatically becomes void if the disputed property is '
          'transferred',
      'Only the plaintiff can transfer the suit property during '
          'litigation',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Lis pendens prevents a party to a pending suit from '
          'transferring the disputed property in a manner that would '
          'prejudice the rights of the other party under any decree '
          'that may be passed in the suit.',
      reference: 'Transfer of Property Act, 1882, Section 52',
    ),
  ),
  const QuizQuestion(
    id: 'property-part-performance',
    stem:
        'Under Section 53A of the Transfer of Property Act, 1882, the '
        'doctrine of "part performance" protects a transferee who:',
    options: [
      'Has merely entered into an oral agreement to purchase property '
          'without taking possession',
      'Has taken possession of the property in part performance of a '
          'written contract for its transfer, has performed or is '
          'willing to perform their part of the contract, even though '
          'the transfer has not been completed by a registered '
          'instrument',
      'Has paid the full sale price but never entered into any written '
          'contract',
      'Has obtained possession through unlawful trespass',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 53A protects a transferee in possession under a '
          'written, signed contract who has performed (or is willing '
          'to perform) their obligations, by preventing the transferor '
          'from disturbing that possession merely because the formal '
          'registered transfer was not completed.',
      reference: 'Transfer of Property Act, 1882, Section 53A',
    ),
  ),
  const QuizQuestion(
    id: 'property-rule-against-perpetuities',
    stem:
        'The rule against perpetuities under Section 14 of the '
        'Transfer of Property Act, 1882 provides that no transfer of '
        'property can create an interest that is to take effect after '
        'the lifetime of one or more persons living at the date of the '
        'transfer, and:',
    options: [
      'An indefinite further period thereafter',
      'The minority of a person who is to be entitled to the interest '
          'created, such person being in existence at the expiration '
          'of that period',
      'A further period of exactly 100 years',
      "The lifetime of the transferor's grandchildren, regardless of "
          'when born',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 14 caps the permissible remoteness of vesting at '
          'the lifetime(s) of living persons plus the minority of the '
          'ultimate beneficiary, who must be in existence at the end '
          'of that period, to prevent property being tied up '
          'indefinitely.',
      reference: 'Transfer of Property Act, 1882, Section 14',
    ),
  ),
  const QuizQuestion(
    id: 'property-registration-act-section-17',
    stem:
        'Under Section 17 of the Registration Act, 1908, which of the '
        'following documents is compulsorily registrable?',
    options: [
      'A will disposing of immovable property',
      'A non-testamentary instrument that purports or operates to '
          'create, declare, assign, limit, or extinguish, whether in '
          'present or in future, any right, title, or interest, of the '
          'value of one hundred rupees or more, in immovable property',
      'A power of attorney authorizing the sale of movable goods',
      'An oral partition of ancestral property',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'Section 17 mandates registration of non-testamentary '
          'instruments creating or affecting rights of Rs. 100 or more '
          'in immovable property; wills are expressly excluded from '
          'compulsory registration under the Act.',
      reference: 'Registration Act, 1908, Section 17',
    ),
  ),
  const QuizQuestion(
    id: 'property-doctrine-of-election',
    stem:
        'The doctrine of "election" under Section 35 of the Transfer '
        'of Property Act, 1882 requires that a person who receives a '
        'benefit under an instrument must:',
    options: [
      'Accept only part of the instrument that benefits them, while '
          'rejecting the rest',
      'Either confirm the whole transaction contained in the '
          'instrument or dissent from it altogether, and cannot '
          'approbate and reprobate at the same time',
      'Always reject any instrument in which their own property is '
          'disposed of',
      'Seek prior court approval before accepting any benefit',
    ],
    correctOption: 1,
    explanation: QuizExplanation(
      core:
          'A person cannot both accept a benefit conferred by an '
          'instrument and simultaneously reject the burden it imposes '
          'on their own property — they must elect to either accept '
          'the whole transaction or reject it entirely.',
      reference: 'Transfer of Property Act, 1882, Section 35',
    ),
  ),
];
