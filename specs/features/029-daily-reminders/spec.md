# 029-daily-reminders Daily Practice Reminders

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0003-localization.md`, `../../adr/0004-platform-plugins.md`
Source: GitHub issue #36 (parent #24). Ported from `nisha-frontend`
(`notifications_service`); Nisha fixed the time at 9:00, this adds a time
picker.

## Problem

Nothing brings learners back each day.

## Goals

- Profile → Daily reminders: turn a reminder on or off and pick a time.
- A local notification fires daily at that local time.
- A refused notification permission is explained.

## Non-Goals

- Server push notifications.
- Re-translating an already scheduled reminder when the language changes
  (it updates the next time the learner changes a setting).

## Assumptions

- `flutter_local_notifications` + `timezone` + `flutter_timezone` schedule
  on-device (ADR 0004). Android uses inexact alarms, so no exact-alarm
  permission is needed.

## Functional Requirements

- FR-001: The screen shall show the saved on/off and time (default off,
  9:00 AM), formatted for the locale.
- FR-002: Turning on shall ask for notification permission; if granted,
  schedule a daily reminder at the chosen local time and save.
- FR-003: If permission is refused, reminders stay off and a localized
  explanation shows.
- FR-004: Turning off shall cancel the reminder and save.
- FR-005: Picking a new time shall save it and reschedule if on.
- FR-006: The reminder text and Android channel name shall be in the app
  language.
- FR-007: If scheduling fails, the choice stays as it was and a localized
  message shows; one change runs at a time, and nothing changes before the
  saved settings load.
- FR-008: If the time zone name can't be read, a zone with the device's
  current offset is used.

## Acceptance Criteria

- AC-001: The view model persists choices, schedules/cancels, and flags a
  refused permission (fake scheduler).
- AC-002: The page shows the saved choice, schedules a localized reminder,
  explains denial, and changes the time via the picker.
- AC-003: Profile → Daily reminders opens the screen (shell).
- AC-004: Strings are localized (e.g. Hindi).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/settings/presentation/reminders_view_model_test.dart` |
| AC-002, AC-004 | Widget | `test/features/settings/presentation/reminders_page_test.dart` |
| AC-003 | Widget | `test/app/main_shell_test.dart` |

## Open Questions

- Should reminders skip days the learner already practised?
