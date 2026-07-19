# 006-signin-screen Sign In Screen

Status: Draft
Last Updated: 2026-04-29
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

Users need a secure and accessible way to authenticate themselves to access their personalized learning journey, track progress, and participate in quizzes. The sign-in screen is the gateway for returning users and provides a clear path for new users to create an account.

## Goals

- Provide a clear, intuitive sign-in form for existing users.
- Display the brand identity prominently to reinforce trust.
- Provide a clear pathway to account recovery ("Forgot Password?").
- Provide a clear pathway to registration ("SIGN UP") for new users.
- Maintain visual consistency with the onboarding experience.

## Non-Goals

- Implementation of the actual authentication logic (covered in a separate functional spec).
- Implementation of the "Forgot Password" flow.
- Implementation of the "Sign Up" flow.

## Actors

- Returning user wanting to access their account.
- New user who needs to create an account but landed on this screen.

## Assumptions

- The user navigates to this screen from the Onboarding flow or application launch (if previously logged out).
- The keyboard behavior is handled gracefully (screen scrollable).

## Functional Requirements

- FR-001: The screen shall display the brand lockup (logo, wordmark, tagline) at the top left.
- FR-002: The screen shall display a hero illustration on the middle right featuring:
  - Three law books ("LAW", "JUSTICE", "KNOWLEDGE").
  - A dark brown wooden gavel and sound block.
  - Golden laurel branches.
- FR-003: The screen shall display a heading "Welcome to Nyaya" in dark navy serif font.
- FR-004: The screen shall display subtext "Test your knowledge. \nMaster justice." where "justice." is highlighted in gold.
- FR-005: The screen shall display a sign-in card containing a form.
- FR-006: The sign-in card shall display the heading "Already have an account?" and subtext "Sign in to continue your learning journey" ("learning journey" in gold).
- FR-007: The form shall include an "Email / Phone Number" text field with a user icon prefix.
- FR-008: The form shall include a "Password" text field with a lock icon prefix and an eye icon suffix (for password visibility toggle).
- FR-009: The form shall include a "Forgot Password?" text link aligned to the right.
- FR-010: The form shall include a "SIGN IN" button (dark navy background, white text).
- FR-011: The form shall include an "or" divider.
- FR-012: The form shall include a section for new users with heading "New to Nyaya?" and subtext "Create an account and start your legal learning journey".
- FR-013: The form shall include a "SIGN UP" button (outlined, gold text and icon).
- FR-014: The screen shall display a "Secure & trusted by learners" badge with a shield icon at the bottom.
- FR-015: The screen shall display background decorative elements (faded temple, bottom waves, dots, star).

## Non-Functional Requirements

- NFR-001: The layout shall be responsive across various screen sizes.
- NFR-002: The sign-in card must be elevated with a shadow to distinguish it from the background.
- NFR-003: Typography and colors must strictly adhere to the brand guidelines.
- NFR-004: The screen must gracefully handle keyboard appearance (scrollable view).
- NFR-005: Form fields must have clear focused, unfocused, and error states.

## UX Notes

- **Clear Hierarchy**: The brand and welcome message establish context, while the white card clearly delineates the interactive authentication area.
- **Visual Cues**: Using icons in text fields helps users quickly identify what input is expected.
- **Alternative Path**: The clear "SIGN UP" section ensures new users don't feel lost if they accidentally end up on the sign-in screen.

## Data and Integration Impact

- Local storage: None for UI rendering, but login action will store auth tokens.
- Remote APIs: Form submission will call the authentication endpoint.
- Analytics/telemetry: Track screen views and form submissions.

## Acceptance Criteria

- AC-001: Brand lockup is displayed at the top left.
- AC-002: Hero illustration (books, gavel) is displayed prominently on the right.
- AC-003: "Welcome to Nyaya" heading and two-line subtext are displayed on the left.
- AC-004: A white sign-in card with shadow is rendered.
- AC-005: The card contains all specified headings, form fields (Email, Password), icons, and links.
- AC-006: "SIGN IN" button is full-width, navy background, white text.
- AC-007: "SIGN UP" button is full-width, gold outline, gold text and icon.
- AC-008: "Secure & trusted by learners" text and shield icon are displayed below the card.
- AC-009: Background ornaments (temple, waves, dots, star) match the design.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | Verify brand lockup is rendered |
| AC-002 | Widget | Verify presence of hero illustration asset |
| AC-003 | Widget | Verify welcome heading and subtext |
| AC-004 | Widget | Verify sign-in card container styling |
| AC-005 | Widget | Verify all form fields and text elements are present |
| AC-006 | Widget | Verify SIGN IN button styling |
| AC-007 | Widget | Verify SIGN UP button styling |
| AC-008 | Widget | Verify secure trust badge at the bottom |
| AC-009 | Golden | Visual regression for decorative alignment |

## Open Questions

- Does the "Email / Phone Number" field support both inputs interchangeably, and how is validation handled?
- Are there specific error messages defined for authentication failures?
