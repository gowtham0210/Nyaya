# 038-real-quiz-progress Real Quizzes, One Source of Progress

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: UI/UX audit `docs/ui-audit/ui-ux-audit.md` §5 Week 1, item 6.
Supersedes: the sample data in 010 (topic) and the app's use of 011's
sample session.

## Problem

Home and Profile read real progress (`/users/me/progress`), but the topic
page and the quiz were hard-coded samples: "No quizzes yet" on Home next to
a topic showing quiz 1 done, 33% and "Resume"; finishing a quiz changed
nothing; category taps said "coming soon".

## Goals

- The topic page and the quiz run on the backend (`nyaya_backend`
  `/quizzes`, `/quiz-attempts`).
- Finishing a quiz submits an attempt, then Home, Profile and the topic
  reload, so all three agree.
- Category taps open their topic.

## Non-Goals

- Resuming an open attempt mid-way: Continue starts a fresh attempt.
- Showing the right option after a wrong answer: the backend withholds the
  answer key and the answer response only says right/wrong. The
  explanation still shows. Backend follow-up: return `correctOptionId`
  from `POST /quiz-attempts/:id/answers`.
- Answer review (hidden since 035), points/achievements on the result.
- Home's sample "Explore by Category" strip (still sample data).

## Decisions

- Topic = backend category. Quizzes from `GET /categories/:id/quizzes`,
  oldest first so numbering is stable.
- Status per quiz from `GET /quiz-attempts?size=100`: completed once any
  attempt is `submitted`, else in progress while one is `in_progress`.
- Bottom button: Continue quiz N (open attempt) → Start quiz N (first new)
  → Practice again (all done). Locked quizzes are skipped and show "Unlocks
  at N points".
- Continue Learning (Home) opens the topic of the latest attempt
  (`/quiz-attempts?size=1` → `/quizzes/:id` → category), or the Categories
  tab when there is none.
- The bookmark button is removed: it never saved (spec 035 rule).
- `QuizSession` interface: the sample session (tests, spec 011) and
  `RemoteQuizSession` (app). A failed answer keeps the question open; a
  failed submit keeps Next to retry.

## Functional Requirements

- FR-001: The topic page shall list the category's quizzes with status,
  count, typical difficulty and percent complete from attempts.
- FR-002: Tapping an unlocked quiz or the bottom button shall start a
  backend attempt; locked quizzes shall not open.
- FR-003: Each answer shall be recorded; the page shows right/wrong and
  the explanation.
- FR-004: After the last question the attempt shall be submitted, then the
  result shows, and topic, Home progress and Profile reload.
- FR-005: Continue Learning shall open the latest attempt's topic, else
  Categories.
- FR-006: Categories-tab and Recommended taps shall open the topic.
- FR-007: New strings in all five languages.

## Acceptance Criteria

- AC-001: Repository: order, statuses (submitted wins), locks, latest
  category.
- AC-002: View model: progress, continue target (open → new → first
  again), locks skipped, typical difficulty, empty.
- AC-003: Page: header, row statuses, taps, Start/Continue, lock, Retry.
- AC-004: Play: answers recorded, submit once, failed answer/submit
  recoverable, load Retry.
- AC-005: Shell: category → topic → quiz → result reloads progress;
  Continue opens the latest topic or Categories.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/topic_detail/data/topic_repository_test.dart` |
| AC-002 | Unit | `test/features/topic_detail/presentation/topic_detail_view_model_test.dart` |
| AC-003 | Widget | `test/features/topic_detail/presentation/topic_detail_page_test.dart`, `learning_localization_test.dart` (Telugu) |
| AC-004 | Unit / Widget | `test/features/quiz_question/data/quiz_play_repository_test.dart`, `quiz_play_page_test.dart` |
| AC-005 | Widget | `test/app/main_shell_test.dart` |

Manual: not yet run against the hosted API on a device (simulator off at
the owner's request; the dev account belongs to the local backend).
