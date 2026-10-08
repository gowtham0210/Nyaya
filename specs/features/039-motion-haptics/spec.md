# 039-motion-haptics Motion & Haptics

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: —
Source: UI/UX audit `docs/ui-audit/ui-ux-audit.md` §3.4 (scored 2/10).

## Problem

No haptics anywhere and almost no motion: answers, results, tabs and
loading all changed instantly, which reads as cheap.

## Goals

- Haptics with one meaning each, on the moments that matter.
- Short, consistent motion on the quiz, result, tabs and loading.
- Respect the OS "reduce motion" setting.

## Non-Goals

- Confetti/sparkle on the result (needs art; audit §3.5).
- Replacing spinners inside buttons and the dark progress card.
- An animated score arc (the ring stays a full gold border, as in the
  mockup).

## Decisions

- `lib/app/theme/app_motion.dart`: `NyayaMotion` (quick 150 ms, medium
  250 ms, slow 600 ms, `easeOutCubic`; `of()` returns zero when motion is
  reduced) and `NyayaHaptics` (select, correct, wrong, celebrate).
- Haptics: picking an answer → selection click; right → light impact;
  wrong → medium impact; result ≥ 70% → heavy impact, else a selection
  click (a heavy buzz for a low score would feel like a penalty); switching
  to another tab → selection click.
- Motion: answer options ease color/border; the explanation slides and
  fades up; the result score and percent count up from zero and the
  headline settles in; tabs fade in; one nav indicator slides between
  tabs; `LoadStateView` shows a pulsing skeleton instead of a spinner;
  routes use the Cupertino slide on iOS and fade-forwards on Android.

## Functional Requirements

- FR-001: Answering shall give a selection haptic, then light (right) or
  medium (wrong).
- FR-002: The result shall count up and fire one haptic by score band.
- FR-003: Switching tabs shall give a selection haptic (not when tapping
  the current tab) and slide the indicator.
- FR-004: Loading states shall show a skeleton.
- FR-005: With reduce motion on, durations shall be zero and the skeleton
  still.

## Acceptance Criteria

- AC-001: Right answer → selection + light; wrong → medium.
- AC-002: 9/12 starts at "0/12", ends at "9/12"/"75%", one heavy impact;
  2/12 → one selection click.
- AC-003: The indicator moves right on switching; one haptic; none for
  the same tab.
- AC-004: Reduce motion gives zero duration and no running animation.
- AC-005: Loading shows `NyayaSkeleton`, no spinner.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-004 | Widget | `test/app/theme/motion_test.dart` |
| AC-005 | Widget | `test/core/presentation/widgets/load_state_view_test.dart` |
| Feel on device | Manual | Pending: simulator off at the owner's request; haptics need a real phone |
