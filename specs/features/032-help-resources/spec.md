# 032-help-resources Legal Help Resources

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`,
`../../adr/0004-platform-plugins.md`
Source: GitHub issue #39 (parent #24). Ported from `nisha-frontend`
(`help_resources_screen`, `help_resource`, `help_resources_api_service`).

## Problem

Learners who need real legal help can't find who to contact near them.

## Goals

- Profile → Legal help resources: pick a state and a kind of help, see
  matching national and state contacts with verification info.
- Tap to call, email, or open the website or official source.

## Non-Goals

- Search within the list (Nisha's search sheet).
- Remembering the last state picked.

## Assumptions

- `GET /help-resources/states` → `{ items: [{ code, name }] }`;
  `GET /help-resources/categories` → `{ items: [{ slug, name }] }`;
  `GET /help-resources?state=&category=` → `{ items: [{ id, resourceName,
  isNational, tollFree, phoneNumber, email, websiteUrl, serviceHours,
  sourceName, sourceUrl, verificationStatus, lastVerifiedAt }] }`.
- Links open through `url_launcher` behind a `LinkOpener` (ADR 0004).

## Functional Requirements

- FR-001: The screen shall load states and categories, pick the first of
  each, and load matching contacts; loading, empty and error-with-Retry
  states shall show for both.
- FR-002: Changing the state or category shall reload contacts; the latest
  choice wins.
- FR-003: Each contact shall show its name, a "National helpline" chip when
  national, "Source verified <date>" or "Needs verification", numbers,
  hours, and source.
- FR-004: "Call" dials the toll-free number, else the phone; email opens
  mail; website and source open the browser (web links only).
- FR-005: A link that can't open shall show a localized message.
- FR-006: An emergency note shall dial 112 on tap.

## Acceptance Criteria

- AC-001: The repository loads options, filters with query parameters, and
  maps contacts (toll-free first; only web links kept).
- AC-002: The view model picks defaults, reloads on change, empties on no
  match, and keeps the latest filter's result.
- AC-003: The page shows filters, contacts, chips, and opens the right
  links; failure to open is explained; 112 dials.
- AC-004: The page shows empty and error-with-Retry states.
- AC-005: From Profile, a contact's Call opens `tel:` (shell).
- AC-006: Hindi and large text on a small phone work.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/help/data/help_resources_repository_test.dart` |
| AC-002 | Unit | `test/features/help/presentation/help_resources_view_model_test.dart` |
| AC-003, AC-004, AC-006 | Widget | `test/features/help/presentation/help_resources_page_test.dart` |
| AC-005 | Widget | `test/app/main_shell_test.dart` |
