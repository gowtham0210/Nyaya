# 042-phone-otp-login Phone Sign-In by OTP

Status: Implemented (app side); waiting on backend
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`
Supersedes: 041's phone + password sign-in.

## Problem

The sign-in phone tab asked for a password. Phone users should get a code
by SMS instead, like most apps.

## Goals

- Phone tab: number only → Send OTP → OTP screen → signed in.

## Non-Goals

- The backend endpoint (owner decision 2026-10-06: app UI first).
- Phone sign-up (sign-up stays email, spec 041).

## Decisions

- Planned backend contract, `POST /auth/phone-login`:
  - Body: `{ "firebase_id_token": "<token>", "phone": "+91XXXXXXXXXX" }`.
  - Verify the token with Firebase Admin, check its phone matches, find the
    user by `firebase_uid` or phone, and return the same body as
    `/auth/login` (`accessToken`, `refreshToken`, `refreshTokenExpiresAt`,
    `user`).
  - Unknown phone: 404 or 401 with a message, e.g. "No account for this
    phone. Sign up with email."
- Until it exists, the backend answers 404, and the app says "Phone
  sign-in isn't available yet. Please use email." in the app language.
- The OTP page now takes a `completeAuth(firebaseIdToken)` callback instead
  of sign-up fields, so it serves login (and sign-up later).
- `FirebasePhoneAuthService` reads `FirebaseAuth.instance` on first use, so
  tests can fake it.

## Functional Requirements

- FR-001: The phone tab shall show the number and Send OTP, no password.
- FR-002: Send OTP shall text the code to `+91…` and open the OTP page.
- FR-003: A verified code shall call `/auth/phone-login`, save the session
  and open goal selection.
- FR-004: A missing endpoint shall show the localized "use email" message.

## Acceptance Criteria

- AC-001: Phone tab: no password field; button "Send OTP".
- AC-002: 9876543210 → code sent to +919876543210 → OTP page → code
  verified → `{firebase_id_token, phone}` posted → session saved → goals.
- AC-003: A short number shows an error and sends no code.
- AC-004: A 404 shows "Phone sign-in isn't available yet…", stays on the
  OTP page, no session.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-004 | Widget | `test/features/auth/presentation/sign_in_page_test.dart` |
| OTP page in Hindi | Widget | `test/features/auth/presentation/auth_localization_test.dart` |
| Real SMS on device | Manual | Pending: owner's iPhone; needs the backend endpoint to finish |
