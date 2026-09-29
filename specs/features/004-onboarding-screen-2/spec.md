# 004-onboarding-screen-2 Onboarding Screen 2

Status: Draft
Last Updated: 2026-04-29
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

After the first onboarding screen introduces the Nyaya brand and its core concept, users need to understand what the app actually offers. Screen 2 shifts from brand introduction to value proposition — explaining that Nyaya provides case-based quizzes, real-life scenarios, and expertly crafted content for learning law. This screen also introduces navigation controls (SKIP/NEXT) for the first time.

## Goals

- Communicate the app's educational value proposition clearly and concisely.
- Introduce the "Learn → Understand → Apply Law" progression message.
- Provide navigation controls (SKIP to exit onboarding, NEXT to advance).
- Maintain visual continuity with Screen 1 (same background, decorative elements, page indicator).
- Present a larger, more prominent illustration without the brand lockup.

## Non-Goals

- Feature-specific details (reserved for later screens).
- User registration or login.
- Interactive elements beyond SKIP/NEXT navigation.

## Actors

- New user going through onboarding for the first time.
- Returning user who has cleared app data.

## Assumptions

- The user reaches this screen by swiping from Screen 1 or tapping NEXT.
- The onboarding flow consists of 4 screens total (indicated by the page indicator).
- The brand lockup is intentionally omitted on this screen to give more space to the illustration and messaging.

## Functional Requirements

- FR-001: The screen shall NOT display the brand lockup (logo, wordmark, tagline) — it is removed to provide more illustration space.
- FR-002: The screen shall display a large hero illustration (law books with scales of justice, gavel, and laurel branch) occupying the top ~45–50% of the screen.
- FR-003: The screen shall display a faded courthouse/temple watermark on the right side at low opacity (~10–15%).
- FR-004: The screen shall display the heading "Learn. Understand." in dark navy serif bold font.
- FR-005: The screen shall display the heading "Apply Law." in gold serif bold font, directly below FR-004.
- FR-006: The screen shall display a decorative gold divider with an outlined diamond icon, centered below the headings.
- FR-007: The screen shall display body text: "Nyaya makes legal learning simple with case-based quizzes, real-life scenarios and expertly crafted content." in muted grey sans-serif.
- FR-008: The screen shall display a "SKIP" text button on the bottom-left in dark navy.
- FR-009: The screen shall display a "NEXT >" text button on the bottom-right in gold.
- FR-010: The screen shall display the page indicator with 4 dots, with the second dot active (gold, elongated).
- FR-011: The screen shall maintain all background decorative elements from Screen 1 (dot patterns, sparkle stars, background wave).
- FR-012: Tapping SKIP shall exit the onboarding flow and navigate to the main app.
- FR-013: Tapping NEXT shall navigate to the next onboarding screen (Screen 3).
- FR-014: Swiping left shall navigate to Screen 3; swiping right shall return to Screen 1.

## Non-Functional Requirements

- NFR-001: The layout shall be responsive across various screen sizes, ensuring text and illustration are not clipped or cramped.
- NFR-002: Typography and colors must strictly adhere to the brand guidelines (Navy: #1A2C3D, Gold: #C89B3C, Ivory: #FBF7F1, Body grey: #4A5568).
- NFR-003: The hero illustration asset must be high-resolution and optimized for mobile performance (PNG with transparency).
- NFR-004: Accessibility semantics must be provided for headings, body text, and navigation buttons.
- NFR-005: The transition between Screen 1 and Screen 2 should feel smooth and continuous (PageView swipe or animated transition).

## UX Notes

- **No brand lockup**: Unlike Screen 1, the brand identity is already established. Screen 2 uses the freed space for a larger illustration.
- **Navigation introduction**: This is the first screen where SKIP and NEXT appear, giving users control over the onboarding flow.
- **Content hierarchy**: Illustration → Heading → Divider → Body text → Navigation. The divider creates a visual break between the emotional heading and the informational body text.
- **Body text tone**: The description is concise and feature-focused, using accessible language.

## Data and Integration Impact

- Local storage: None.
- Remote APIs: None.
- Analytics/telemetry: May track if the user taps SKIP vs NEXT for onboarding completion metrics (future consideration).

## Acceptance Criteria

- AC-001: Brand lockup is NOT present on the screen.
- AC-002: Hero illustration (scales, books, gavel, laurel) is displayed prominently at the top, occupying ~45–50% of the screen.
- AC-003: Faded courthouse/temple watermark is visible on the right at low opacity.
- AC-004: Heading "Learn. Understand." is rendered in dark navy (#1A2C3D) serif bold.
- AC-005: Heading "Apply Law." is rendered in gold (#C89B3C) serif bold.
- AC-006: An outlined diamond divider is displayed centered below the headings.
- AC-007: Body text matches the exact copy and is styled in muted grey (#4A5568) sans-serif.
- AC-008: "SKIP" button is on the left, styled in navy bold sans-serif.
- AC-009: "NEXT >" button is on the right, styled in gold bold sans-serif with a chevron.
- AC-010: Page indicator shows 4 dots with the second dot active (gold, elongated).
- AC-011: Background decorative elements (dots, stars, wave) match Screen 1.
- AC-012: SKIP navigates out of onboarding; NEXT navigates to Screen 3.
- AC-013: Screen background is warm ivory (#FBF7F1).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | Verify brand lockup is NOT rendered |
| AC-002 | Widget | Verify presence of hero illustration asset |
| AC-003 | Golden | Visual check for temple watermark presence |
| AC-004 | Widget | Verify text "Learn. Understand." with correct color |
| AC-005 | Widget | Verify text "Apply Law." with correct color |
| AC-006 | Widget | Verify presence of content divider widget |
| AC-007 | Widget | Verify body text content and color |
| AC-008 | Widget | Verify SKIP button presence and tap callback |
| AC-009 | Widget | Verify NEXT button presence, chevron icon, and tap callback |
| AC-010 | Widget | Verify page indicator with index 1 active |
| AC-011 | Golden | Visual regression for decorative alignment |
| AC-012 | Integration | Verify navigation on SKIP and NEXT taps |
| AC-013 | Widget | Verify background color |

## Open Questions

- Should the SKIP button skip all remaining screens or just skip to the last one?
- What is the exact illustration asset for Screen 2? Is it the same as Screen 1 or a different composition?
- Should there be a transition animation between screens (e.g., fade, slide)?
