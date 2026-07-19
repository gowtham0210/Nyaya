# 008-home-page Home Page

Status: Draft
Last Updated: 2026-05-10
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`

## Problem

After authentication and onboarding, users need a polished home page that immediately tells them what to do next. The current implemented home shell is a placeholder for the spec-driven baseline and does not reflect Nyaya's actual product experience. The app needs a premium post-auth dashboard that supports quick quiz entry, topic discovery, learning resumption, and bottom-navigation access to the rest of the product.

## Goals

- Replace the placeholder home shell with a branded, production-style home dashboard.
- Surface a strong hero CTA for starting or resuming legal-learning activity.
- Make legal topic discovery fast through high-visibility category shortcuts.
- Provide a visible "Continue Learning" module so returning users can resume progress immediately.
- Promote featured quizzes with concise metadata, difficulty cues, and ratings.
- Establish the visual and structural baseline for the authenticated bottom navigation experience.

## Non-Goals

- Implementing the actual quiz engine, resume logic, or leaderboard behavior.
- Defining the complete information architecture for every bottom-nav destination.
- Recommender-system logic for selecting popular quizzes.
- Notification center content or push-notification delivery logic.

## Actors

- Newly authenticated user arriving at the app's main dashboard for the first time.
- Returning learner resuming progress from a partially completed quiz.
- User browsing legal topics before choosing a quiz.

## Assumptions

- The home page is shown after successful authentication and initial session bootstrap.
- The visual design shown in the provided mockup is the source of truth for layout, hierarchy, and copy.
- The screen uses a vertically scrollable layout with the bottom navigation fixed to the bottom edge.
- Content modules may later be driven by remote data, but this spec defines the UI contract and default presentation only.
- The existing `001-home-shell` placeholder is functionally superseded by this feature.

## Functional Requirements

- FR-001: The screen shall display the Nyaya brand lockup at the top-left of the page.
- FR-002: The screen shall display a notification bell button at the top-right with a small gold unread indicator dot.
- FR-003: The screen shall display a primary hero banner directly below the top bar.
- FR-004: The hero banner shall use a dark navy background with rounded corners and include:
  - the text `Test Your Legal Knowledge. Master Justice.`
  - supporting copy `Quizzes on Law. Insights for Life.`
  - a prominent `Start Quiz` CTA with play icon
  - a legal-themed illustration featuring scales, law books, a temple silhouette, and a gavel
- FR-005: The screen shall display a section header `Explore by Category` with a right-aligned `View All` action.
- FR-006: The category section shall display five category shortcuts:
  - `Constitutional Law`
  - `Criminal Law`
  - `Civil Law`
  - `Contract Law`
  - `Legal Reasoning`
- FR-007: Each category shortcut shall include an icon container and a two-line label.
- FR-008: The screen shall display a section header `Continue Learning`.
- FR-009: The Continue Learning module shall display:
  - a circular progress indicator showing `65%`
  - the title `Indian Constitution Quiz`
  - the metadata `15 Questions`
  - a horizontal progress bar
  - a `Resume` button
- FR-010: The screen shall display a section header `Popular Quizzes` with a right-aligned `View All` action.
- FR-011: The Popular Quizzes section shall display at least three quiz cards in the order shown in the mockup:
  - `Fundamental Rights Quiz`
  - `Indian Penal Code Quiz`
  - `Contract Act Quiz`
- FR-012: Each quiz card shall display:
  - a leading icon tile
  - quiz title
  - question count
  - difficulty label
  - short descriptive summary
  - rating chip with star icon and rating value
  - trailing chevron/navigation affordance
- FR-013: The difficulty label colors shall visually distinguish `Medium`, `Hard`, and `Easy`.
- FR-014: The screen shall display a fixed bottom navigation bar with five destinations:
  - `Home`
  - `Categories`
  - `Leaderboard`
  - `Bookmarks`
  - `Profile`
- FR-015: The `Home` navigation item shall appear active by default.
- FR-016: Tapping the hero `Start Quiz` button shall route to the app's quiz-entry flow.
- FR-017: Tapping the `Resume` button shall route to the in-progress quiz/session flow.
- FR-018: Tapping any category shortcut shall route to the category/topic discovery surface.
- FR-019: Tapping any popular quiz card shall route to that quiz's detail or start screen.
- FR-020: Tapping the notification bell shall route to the notifications or alerts surface.
- FR-021: Tapping any bottom-navigation item shall switch to the corresponding top-level app section.
- FR-022: The content above the bottom navigation shall remain vertically scrollable when content exceeds the viewport.

## Non-Functional Requirements

- NFR-001: The layout shall remain visually balanced across common phone widths from 320dp through large portrait phones.
- NFR-002: Typography, spacing, color, icon treatment, shadows, and card radii shall align with the Nyaya premium brand language established in onboarding and auth.
- NFR-003: The home page shall maintain strong hierarchy so the hero CTA, section titles, and quiz cards remain scannable at a glance.
- NFR-004: All interactive surfaces shall meet a minimum 48dp touch target.
- NFR-005: Horizontal category cards and list cards shall not overflow or truncate critical content on compact devices.
- NFR-006: The bottom navigation shall remain anchored and readable above device safe-area insets.
- NFR-007: The page shall support loading, empty, and error states in a future implementation without requiring layout redesign.

## UX Notes

- The home page should feel like a curated legal-learning dashboard, not a generic course list.
- The hero banner is the primary momentum-builder and should create immediate confidence and direction.
- Category icons need to feel simple and recognizable so users can jump quickly without reading every line of copy.
- The Continue Learning module is the highest-value returning-user surface and should never be visually buried.
- Popular quiz cards should be information-dense but still breathable, with clean separation and restrained decorative noise.

## Data and Integration Impact

- Local storage: May read resume-progress data, selected category history, and last-active quiz summary.
- Remote APIs: Future home feed, categories, featured quizzes, ratings, notification badge count, and resume-session endpoints.
- Analytics/telemetry: Track home view, hero CTA taps, category taps, resume taps, popular quiz taps, notification taps, and bottom-nav selection.

## Acceptance Criteria

- AC-001: The top bar shows the Nyaya brand lockup on the left and a bell icon with an unread dot on the right.
- AC-002: A dark navy hero banner is displayed below the top bar with the exact headline, supporting copy, illustration, and `Start Quiz` CTA shown in the mockup.
- AC-003: The section `Explore by Category` is displayed with a right-aligned `View All` action.
- AC-004: Five category shortcuts are displayed in the correct order with icons and labels.
- AC-005: The section `Continue Learning` is displayed with the exact title `Indian Constitution Quiz`, `15 Questions`, `65%`, progress bar, and `Resume` CTA.
- AC-006: The section `Popular Quizzes` is displayed with a right-aligned `View All` action.
- AC-007: Three popular quiz cards are displayed with titles, metadata, difficulty labels, descriptions, ratings, and chevrons matching the mockup content.
- AC-008: The difficulty labels visually distinguish `Medium`, `Hard`, and `Easy`.
- AC-009: A five-item bottom navigation bar is displayed with `Home` visually active.
- AC-010: The content area is vertically scrollable while the bottom navigation remains fixed.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | Verify top bar brand lockup and notification badge |
| AC-002 | Golden | Verify hero banner composition and CTA placement |
| AC-003 | Widget | Verify `Explore by Category` header and `View All` action |
| AC-004 | Widget | Verify five category items and ordering |
| AC-005 | Widget | Verify Continue Learning card content and progress UI |
| AC-006 | Widget | Verify `Popular Quizzes` header and `View All` action |
| AC-007 | Widget | Verify popular quiz card content and rating chips |
| AC-008 | Widget | Verify difficulty labels use distinct semantic colors |
| AC-009 | Widget | Verify bottom navigation items and active state |
| AC-010 | Widget | Verify scrollable content with pinned bottom navigation |

## Open Questions

- Should the `Start Quiz` CTA route to a recommended quiz, a category chooser, or the last selected exam track?
- Is the `Continue Learning` module always shown, or should it collapse when the user has no in-progress session?
- Are the bottom-navigation destinations final, or will they later realign to the roadmap's `Learn / AI` wording?
