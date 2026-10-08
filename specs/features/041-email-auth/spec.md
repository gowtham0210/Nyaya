# 041-email-auth Email-First Sign-In and Sign-Up

Status: Implemented
Note (2026-10-06): spec 042 replaced phone + password sign-in with phone +
OTP.
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`
Supersedes: the phone-only sign-in and the Firebase OTP step in sign-up
(owner decision 2026-10-06: phone login isn't fully integrated yet).

## Problem

Sign-in asked only for a phone number and password, and sign-up sent a
Firebase OTP before creating the account. Phone OTP isn't set up end to
end, so new learners could not get in.

## Goals

- Sign in with email (default) or phone, plus password.
- Sign up with name, email, profession, optional phone and password; the
  account is created right away, with no OTP.

## Non-Goals

- Usernames: the backend has no username field, so email is the login id.
- Email verification and password reset screens (the backend emails a
  code on register but doesn't require it).
- Removing the OTP page and Firebase service: kept, unused, for when phone
  sign-up is integrated.

## Decisions

- Sign-in: an Email | Phone switch (`signin.method.*`), Email selected.
  Email is trimmed and lowercased; phone keeps the `+91` normalization.
  Both go to `POST /auth/login` (`email` or `phone`).
- Sign-up: `POST /auth/register` (`fullName`, `email`, `password`,
  optional `phone` as `+91…`), then `PATCH /users/me` with the profession,
  since register has no profession field. A failed profession save doesn't
  fail sign-up: the account exists and Edit profile can fix it.
- Then the existing post-sign-up flow (goal selection → tabs).
- Pages take an optional `AuthRepository` for tests; the app uses
  `AppServices.authRepository`.

## Functional Requirements

- FR-001: Sign-in shall default to email and switch to phone.
- FR-002: Sign-in shall validate the chosen id and the password, then log
  in with it.
- FR-003: Sign-up shall require name, email, profession and password;
  phone is optional but must be valid if given.
- FR-004: Sign-up shall register, save the profession, and continue to
  goal selection, without Firebase.
- FR-005: New strings in all five languages.

## Acceptance Criteria

- AC-001: Sign-in shows the email field first; the switch shows `+91`
  phone.
- AC-002: Email login sends `{email, password}`; phone login sends
  `{phone: +91…, password}`; empty/invalid ids show a message and send
  nothing.
- AC-003: Empty sign-up shows name, email, profession and password errors,
  no phone error; a bad email or short phone shows its error.
- AC-004: A valid sign-up posts `/auth/register`, then the profession,
  and opens goal selection; a backend error shows its message.
- AC-005: Sign-in and sign-up render in Hindi.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001, AC-002 | Widget | `test/features/auth/presentation/sign_in_page_test.dart` |
| AC-003, AC-004 | Widget | `test/features/auth/presentation/sign_up_page_test.dart` |
| AC-004 | Unit | `test/features/auth/data/auth_repository_test.dart` |
| AC-005 | Widget | `test/features/auth/presentation/auth_localization_test.dart` |
| On device | Manual | Pending: owner's iPhone, hosted backend |
