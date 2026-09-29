# 005-onboarding-screen-3 Onboarding Screen 3

Status: Draft
Last Updated: 2026-04-29
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

After Screen 2 explains the app's learning approach, users need a final motivational push that highlights the app's gamification and progress-tracking features. Screen 3 is the last onboarding screen and serves as the conversion point — users either tap "GET STARTED" to create an account or "Sign in" if they already have one. This screen must effectively communicate engagement features (streaks, badges, mastery tracking) while providing a clear call-to-action.

## Goals

- Showcase the app's gamification features: progress tracking, streaks, badges, and mastery.
- Provide a strong call-to-action ("GET STARTED") to convert onboarding viewers into registered users.
- Offer an alternative path for existing users ("Sign in").
- Remove the SKIP/NEXT navigation in favor of the primary CTA.
- Maintain visual continuity with previous screens (background, decorative elements, page indicator).

## Non-Goals

- Actual user registration/login on this screen (those are separate screens).
- Displaying live/real progress data (the illustration shows a static mockup).
- Detailed feature walkthroughs beyond the headline messaging.

## Actors

- New user completing onboarding for the first time.
- Returning user who has cleared app data.
- Existing user who wants to sign in directly.

## Assumptions

- The user reaches this screen by swiping from Screen 2 or tapping NEXT on Screen 2.
- This is the final screen in the onboarding flow (page 3 of 4 indicator dots — 4th may be reserved for future use or the flow ends here).
- The progress dashboard in the illustration is purely decorative/aspirational — not connected to real data.
- The GET STARTED button leads to a signup/registration flow.
- The Sign in link leads to a login screen.

## Functional Requirements

- FR-001: The screen shall NOT display the brand lockup (logo, wordmark, tagline).
- FR-002: The screen shall NOT display SKIP/NEXT text navigation buttons.
- FR-003: The screen shall display a large hero illustration featuring:
  - A mobile phone mockup showing a "YOUR PROGRESS" dashboard (85% mastery ring, 12 Day Streak, 26 Quizzes Completed, 8 Badges Earned).
  - A golden trophy with a star emblem.
  - Golden laurel branches framing the composition.
  - Three law books labeled "JUSTICE", "KNOWLEDGE", "IMPACT".
- FR-004: The screen shall display a faded courthouse/temple watermark on the right side at low opacity (~10–15%).
- FR-005: The screen shall display the heading "Track Progress." in dark navy serif bold font.
- FR-006: The screen shall display the heading "Achieve Excellence." in gold serif bold font, directly below FR-005.
- FR-007: The screen shall display a decorative gold divider with an outlined diamond icon, centered below the headings (reusing `ContentDivider` widget).
- FR-008: The screen shall display body text: "Track your performance, build streaks, earn badges and become the best version of your legal knowledge." in muted grey sans-serif.
- FR-009: The screen shall display a "GET STARTED" button — full-width, gold background, white uppercase text, pill/rounded shape.
- FR-010: The screen shall display "Already have an account? Sign in" below the button, where "Sign in" is a tappable gold link.
- FR-011: The screen shall display the page indicator with 4 dots, with the third dot active (gold, elongated).
- FR-012: The screen shall maintain all background decorative elements from previous screens (dot patterns, sparkle stars, background wave).
- FR-013: Tapping "GET STARTED" shall navigate to the signup/registration flow.
- FR-014: Tapping "Sign in" shall navigate to the login screen.
- FR-015: Swiping right shall return to Screen 2.

## Non-Functional Requirements

- NFR-001: The layout shall be responsive across various screen sizes, ensuring the CTA button remains fully visible above the page indicator.
- NFR-002: Typography and colors must strictly adhere to the brand guidelines (Navy: #1A2C3D, Gold: #C89B3C, Ivory: #FBF7F1, Body grey: #4A5568).
- NFR-003: The hero illustration asset must be high-resolution and optimized for mobile performance (PNG with transparency).
- NFR-004: Accessibility semantics must be provided for headings, body text, CTA button, and Sign in link.
- NFR-005: The "GET STARTED" button must have adequate touch target size (minimum 48px height).
- NFR-006: The transition from Screen 2 to Screen 3 should feel smooth via PageView swipe.

## UX Notes

- **Final conversion screen**: This is the most important screen for user acquisition. The CTA must be prominent and immediately visible without scrolling.
- **No SKIP/NEXT**: Unlike Screen 2, navigation buttons are removed. The user's only forward actions are GET STARTED or Sign in. Swiping back to Screen 2 is still possible.
- **Aspirational illustration**: The progress dashboard mockup shows what users can achieve, creating motivation to sign up.
- **Dual path**: New users tap GET STARTED; existing users tap Sign in. Both paths must be clearly visible.

## Data and Integration Impact

- Local storage: On completing onboarding (tapping GET STARTED or Sign in), store a flag indicating onboarding has been completed.
- Remote APIs: None on this screen.
- Analytics/telemetry: Track which CTA the user taps (GET STARTED vs Sign in) for conversion metrics.

## Acceptance Criteria

- AC-001: Brand lockup is NOT present on the screen.
- AC-002: SKIP/NEXT navigation buttons are NOT present on the screen.
- AC-003: Hero illustration (phone dashboard, trophy, books, laurel) is displayed prominently at the top.
- AC-004: Faded courthouse/temple watermark is visible on the right at low opacity.
- AC-005: Heading "Track Progress." is rendered in dark navy (#1A2C3D) serif bold.
- AC-006: Heading "Achieve Excellence." is rendered in gold (#C89B3C) serif bold.
- AC-007: An outlined diamond divider (same as Screen 2) is displayed centered below the headings.
- AC-008: Body text matches the exact copy and is styled in muted grey (#4A5568) sans-serif.
- AC-009: "GET STARTED" button is full-width, gold (#C89B3C) background, white text, pill-shaped, ~52–56px tall.
- AC-010: "Already have an account? Sign in" is displayed below the button with "Sign in" in gold (#C89B3C).
- AC-011: Page indicator shows 4 dots with the third dot active (gold, elongated).
- AC-012: Background decorative elements (dots, stars, wave) match previous screens.
- AC-013: GET STARTED navigates to signup/registration; "Sign in" navigates to login.
- AC-014: Screen background is warm ivory (#FBF7F1).
- AC-015: Swiping right returns to Screen 2.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | Verify brand lockup is NOT rendered |
| AC-002 | Widget | Verify SKIP/NEXT buttons are NOT rendered |
| AC-003 | Widget | Verify presence of hero illustration asset |
| AC-004 | Golden | Visual check for temple watermark presence |
| AC-005 | Widget | Verify text "Track Progress." with correct color |
| AC-006 | Widget | Verify text "Achieve Excellence." with correct color |
| AC-007 | Widget | Verify presence of ContentDivider widget |
| AC-008 | Widget | Verify body text content and color |
| AC-009 | Widget | Verify GET STARTED button styling (color, shape, text) |
| AC-010 | Widget | Verify Sign in link presence and styling |
| AC-011 | Widget | Verify page indicator with index 2 active |
| AC-012 | Golden | Visual regression for decorative alignment |
| AC-013 | Integration | Verify navigation on GET STARTED and Sign in taps |
| AC-014 | Widget | Verify background color |
| AC-015 | Widget | Verify PageView allows swipe back to Screen 2 |

## Open Questions

- Does GET STARTED go directly to a signup screen, or does it go to a "choose signup method" screen?
- Should the onboarding completion flag be set on GET STARTED tap or after successful registration?
- Is there a 4th onboarding screen planned for the future (4 dots suggest room for one more)?
