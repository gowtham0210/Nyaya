# 007-signup-screen Sign Up Screen

Status: Draft
Last Updated: 2026-05-10
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

New users need a trustworthy, visually polished account-creation screen that feels consistent with Nyaya's onboarding and sign-in experience. The screen must make registration feel clear and low-friction while still reinforcing the premium legal-learning brand.

## Goals

- Provide a clear account-creation form for first-time users.
- Reuse the Nyaya brand language established across onboarding and sign-in.
- Offer a prominent primary sign-up action and a secondary Google continuation option.
- Preserve a clear path back to sign-in for returning users.
- Define the UI precisely enough for a high-fidelity implementation and golden-test coverage.

## Non-Goals

- Backend account-creation logic and API contract details.
- Phone verification, OTP flows, or email verification flows.
- Terms of Service and Privacy Policy content authoring.
- Social auth implementation details beyond the presence of the Google CTA.

## Actors

- New learner creating a Nyaya account for the first time.
- Returning learner who accidentally lands on sign-up and needs to switch to sign-in.
- User who prefers Google-based account creation.

## Assumptions

- The user reaches this screen from onboarding ("GET STARTED") or from the sign-in screen.
- The page must remain usable with the software keyboard open, so vertical scrolling is allowed.
- Brand tokens and shared decorative widgets from the existing auth/onboarding screens should be reused where possible.
- The visual design shown in the provided mockup is the source of truth for layout and copy.

## Functional Requirements

- FR-001: The screen shall display a back navigation affordance in the top-left safe area.
- FR-002: The screen shall display the Nyaya brand lockup near the upper-left quadrant of the page.
- FR-003: The screen shall display a faded courthouse/temple watermark in the upper-right background.
- FR-004: The screen shall display a hero illustration on the right featuring law books, a gavel, and gold laurel accents.
- FR-005: The screen shall display the heading `Create Your Account` in dark navy serif text.
- FR-006: The screen shall display the subtext `Start your legal learning journey with Nyaya`, with `Nyaya` highlighted in gold.
- FR-007: The screen shall display an elevated white sign-up card below the hero/introduction area.
- FR-008: The sign-up card shall display the heading `Let's get you started`.
- FR-009: The sign-up card shall display the subtext `Create an account to begin your journey`.
- FR-010: The form shall display a `Full Name` field with a user-outline leading icon and placeholder `Enter your full name`.
- FR-011: The form shall display an `Email Address` field with a mail-outline leading icon and placeholder `Enter your email address`.
- FR-012: The form shall display a `Phone Number` field with a phone-outline leading icon and placeholder `Enter your phone number`.
- FR-013: The form shall display a `Password` field with a lock-outline leading icon, placeholder `Create a password`, and a trailing visibility-toggle icon.
- FR-014: The form shall display a `Confirm Password` field with a lock-outline leading icon, placeholder `Confirm your password`, and a trailing visibility-toggle icon.
- FR-015: The form shall display password helper text reading `Password must be at least 8 characters with letters and numbers` with a small security/shield icon.
- FR-016: The card shall display a full-width `SIGN UP` primary button with dark navy background and white uppercase text.
- FR-017: The card shall display an `or` divider separating the primary button from social sign-up.
- FR-018: The card shall display a secondary `Continue with Google` button with Google iconography.
- FR-019: The card shall display a terms acknowledgment row with a checkbox control and inline links for `Terms of Service` and `Privacy Policy`.
- FR-020: The screen shall display the footer prompt `Already have an account? Sign in`, with `Sign in` styled as a tappable gold link.
- FR-021: The screen shall display decorative background elements consistent with the auth design language, including bottom waves, a lower-left dot pattern, and a gold star accent.
- FR-022: The layout shall be vertically scrollable so all fields and actions remain reachable on shorter devices or when the keyboard is visible.

## Non-Functional Requirements

- NFR-001: The layout shall remain visually balanced across common mobile widths from 320dp through tablet portrait layouts.
- NFR-002: Typography, colors, radii, shadows, and spacing shall align with existing Nyaya auth/onboarding tokens.
- NFR-003: The card and input styling shall preserve clear default, focused, and error states.
- NFR-004: All tappable controls shall meet a minimum 48dp touch target.
- NFR-005: The implementation shall support autofill hints for name, email, phone, password, and new-password confirmation where appropriate.
- NFR-006: The screen shall expose accessible semantics for the back button, form labels, password visibility toggles, checkbox, primary CTA, Google CTA, and sign-in link.
- NFR-007: The hero illustration and decorative assets shall be optimized for mobile performance and rendered without visible distortion.

## UX Notes

- Trust and clarity should dominate the experience: the top illustration supports the brand, but the form card is the interaction focal point.
- The primary action hierarchy is `SIGN UP` first, Google second, sign-in tertiary.
- The screen should feel premium but calm: warm ivory background, restrained gold accents, and soft card elevation rather than heavy gradients or noisy decoration.
- Error and validation states should be visually clear without disrupting the calm overall composition.

## Data and Integration Impact

- Local storage: None for rendering; later registration flows may persist onboarding-complete or session state.
- Remote APIs: Future sign-up submission and Google auth endpoints.
- Analytics/telemetry: Track screen view, sign-up CTA tap, Google CTA tap, back tap, and sign-in link tap.

## Acceptance Criteria

- AC-001: A back button is visible in the top-left safe area.
- AC-002: The brand lockup is rendered above the intro copy and visually matches the established Nyaya branding.
- AC-003: The background includes a faint temple watermark on the right and auth-style decorative ornaments.
- AC-004: The intro area shows `Create Your Account` and the exact supporting line `Start your legal learning journey with Nyaya`.
- AC-005: A rounded elevated white card is rendered below the intro area.
- AC-006: The card contains the exact header copy `Let's get you started` and `Create an account to begin your journey`.
- AC-007: The card contains five labeled fields: Full Name, Email Address, Phone Number, Password, Confirm Password.
- AC-008: The Password and Confirm Password fields each include a visibility toggle icon.
- AC-009: The password helper row is displayed below the password field.
- AC-010: The `SIGN UP` button is full-width, dark navy, and uses white uppercase text.
- AC-011: An `or` divider is rendered below the primary button.
- AC-012: A `Continue with Google` button with Google iconography is rendered below the divider.
- AC-013: A checkbox row referencing `Terms of Service` and `Privacy Policy` is rendered below the Google button.
- AC-014: The footer prompt `Already have an account? Sign in` is displayed below the card, with `Sign in` visually differentiated in gold.
- AC-015: The page remains scrollable and usable with the on-screen keyboard visible.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | Verify back button is rendered and tappable |
| AC-002 | Golden | Verify brand lockup placement and sizing |
| AC-003 | Golden | Verify temple watermark and decorative ornaments |
| AC-004 | Widget | Verify intro copy matches exact text |
| AC-005 | Widget | Verify sign-up card styling and border radius |
| AC-006 | Widget | Verify card header copy |
| AC-007 | Widget | Verify presence of all five labeled input fields |
| AC-008 | Widget | Verify password fields expose visibility toggle icons |
| AC-009 | Widget | Verify password helper text row is rendered |
| AC-010 | Widget | Verify primary button text and styling |
| AC-011 | Widget | Verify divider with `or` text |
| AC-012 | Widget | Verify Google CTA presence and label |
| AC-013 | Widget | Verify terms row and linked text segments |
| AC-014 | Widget | Verify sign-in prompt text and styling |
| AC-015 | Widget | Verify scroll behavior with keyboard inset |

## Open Questions

- Should the `Phone Number` field be mandatory, optional, or conditionally required?
- Should the terms checkbox ship preselected as shown in the mockup, or start unchecked for legal/compliance reasons?
- Does `Continue with Google` create a new account only, or also sign in existing Google-linked users?
