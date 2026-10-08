# 040-home-layout Home Layout: Greeting, Content First

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`
Source: UI/UX audit `docs/ui-audit/ui-ux-audit.md` §4 Home, §5 item 12.
Supersedes: 008's sample "Explore by Category" strip and 026's
"Recommended for you" section and its see-all grid.

## Problem

- The logo, wordmark and tagline took about 15% of the first screen and
  said nothing about the learner.
- Two category sections: a sample strip (taps said "coming soon") and the
  real backend strip, both category cards.
- Categories sat above the Daily Question, so the daily habit was below
  the fold.

## Goals

- A compact header: small logo, a time-of-day greeting with the learner's
  first name, and a streak chip.
- One category section with real backend categories.
- Content first: Continue → Daily Question → Popular (when wired) →
  Categories → Legal Updates.

## Non-Goals

- One offline banner instead of one Retry per section (audit §4 Home P1).
- A streak invitation for new learners (zero streak hides the chip).
- Notifications (the bell stays hidden until wired, spec 035).

## Decisions

- Greeting by device time: morning before 12:00, afternoon before 17:00,
  else evening. First word of the profile's full name; no name (loading,
  failed, blank) shows the greeting alone. No error UI: the profile is
  optional here.
- The greeting reads from the shell's Profile view model, so a saved name
  or a finished quiz updates both screens.
- Streak chip (`home.streak`): flame + days, shown when the streak is
  above zero; screen readers hear "4-day streak".
- The section is titled "Explore by Category" and uses the real cards;
  View All opens the Categories tab. The see-all grid (`RecommendedPage`)
  and the `homeRecommended` string are removed.
- Section titles shrink from 28 to 22 pt so the greeting leads.

## Functional Requirements

- FR-001: The header shall show the logo, greeting and first name, and
  the streak chip when the streak is above zero.
- FR-002: Without a name the header shall show the greeting alone.
- FR-003: Home shall show one category section of backend categories;
  taps open the topic, View All opens Categories.
- FR-004: Sections shall follow Continue → Daily → Popular → Categories →
  Legal Updates.
- FR-005: New strings in all five languages.

## Acceptance Criteria

- AC-001: At 09:00 with "Asha Rao" and streak 4 → "Good morning",
  "Asha", chip "4" labelled "4-day streak"; 14:00 → afternoon; 20:00 →
  evening.
- AC-002: Streak 0 → no chip; no profile → greeting only, no crash.
- AC-003: No sample categories; one category section with backend cards;
  taps and View All report.
- AC-004: Continue, Daily, Categories and Legal Updates appear top to
  bottom in that order.
- AC-005: Hindi shows the Hindi greeting and streak label.
- AC-006: Shell: Home greets the signed-in learner by name.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001, AC-002, AC-004 | Widget | `test/features/home/presentation/home_page_test.dart` |
| AC-003 | Widget | `test/features/home/presentation/home_progress_recommended_test.dart` |
| AC-005 | Widget | `test/features/learning_localization_test.dart` |
| AC-006 | Widget | `test/app/main_shell_test.dart` |
| Look on device | Manual | Pending: simulator off at the owner's request |
