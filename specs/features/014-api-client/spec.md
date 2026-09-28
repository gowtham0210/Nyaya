# 014-api-client Shared API Client

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`
Source: GitHub issue #24 (port `nisha-frontend`), foundation step.

## Problem

Every backend feature needs the same plumbing: base URL, JSON, bearer
token, token refresh, language and error handling. Without one client each
feature repeats it, and error handling drifts.

## Goals

- One client for all backend calls, including auth.
- Failures surface as a small typed set the UI can map to messages.
- Expired access tokens refresh once, silently.

## Non-Goals

- Persisting tokens (they stay in memory, see `AuthTokenStore`).
- Caching or offline storage.

## Actors

- Repositories calling the backend.

## Assumptions

- Backend errors return JSON `{ "message": "..." }`.
- `POST /auth/refresh` returns new tokens, or nulls when the refresh token
  is invalid.

## Functional Requirements

- FR-001: The client shall build URLs as `<API v1 base>/<path>` with optional
  query parameters, and decode JSON object bodies.
- FR-002: When an access token exists, the client shall send
  `Authorization: Bearer <token>`, unless the call opts out.
- FR-003: When the app language is not English, the client shall add
  `lang=<code>` to the query.
- FR-004: When a call gets 401, the client shall refresh the session once
  and retry with the new token.
- FR-005: When the refresh fails, the client shall report the session as
  expired and throw `ApiUnauthorizedException`.
- FR-006: The client shall map 404 to `ApiNotFoundException`, other non-2xx
  to `ApiServerException` with the backend message and status code, and
  transport errors or timeouts to `ApiOfflineException`. Each exception
  carries `serverMessage` only when the backend sent one, so UI never shows
  the client's English fallback text.
- FR-007: The client shall support GET, POST, PATCH, DELETE with JSON bodies
  and a multipart file upload.

## Non-Functional Requirements

- NFR-001: Requests time out after 15 seconds.
- NFR-002: Tests inject an `http.Client`; no real network in tests.

## Data and Integration Impact

- Remote APIs: all `/api/v1` endpoints.
- Auth client moves onto this client.

## Acceptance Criteria

- AC-001: GET returns the decoded body from `/api/v1/<path>`.
- AC-002: Bearer token is attached when a session exists.
- AC-003: `lang` is added for non-English, omitted for English.
- AC-004: 401 → refresh → retry succeeds with the new token.
- AC-005: 401 with failed refresh throws unauthorized and reports expiry.
- AC-006: 404, 500 (with message) and transport errors map to their types.
- AC-007: POST sends a JSON body.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-007 | Unit | `test/core/network/api_client_test.dart` |

## Open Questions

- None.
