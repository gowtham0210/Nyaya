# 047-legal-update-detail Legal Update Detail Screen

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Extends: `../020-legal-updates/spec.md`

## Problem

Legal update cards weren't tappable, so learners couldn't read the full
summary or see the update's image (`imageUrl` was dropped).

## Decisions

- Tapping a card on Home or the see-all list opens `LegalUpdateDetailPage`.
- Detail: 16:9 image (when sent), category pill, full title, date · source,
  full summary. No line limits.
- `imageUrl` is mapped; relative upload paths become absolute
  (`ApiConfig.absoluteUrl`, shared with Profile). Blank means no image.
- Image loading shows a spinner; a failed load shows a broken-image icon.
- Tapping the image opens a black full-screen viewer: pinch or double-tap
  to zoom, close button top-left.

## Acceptance Criteria

- AC-001: `imageUrl` is absolute; blank is null.
- AC-002: Tap a card → detail shows full summary, title, source; back
  returns.
- AC-003: The image is a labelled button ("View image"); it opens the
  zoomable viewer, which closes.
- AC-004: An update without an image shows text only.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/legal_updates/data/legal_updates_repository_test.dart` |
| AC-002–AC-004 | Widget | `test/features/legal_updates/presentation/legal_update_detail_page_test.dart` |
