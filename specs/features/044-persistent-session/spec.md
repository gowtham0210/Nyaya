# 044-persistent-session Stay Signed In

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`

## Problem

Learners were logged out on nearly every app open. Tokens lived only in
memory, but the "signed in" flag was saved, so after iOS closed the app it
reopened on Home with no token: the first call got 401, refresh had
nothing to use, and the app sent the learner to sign-in.

## Goals

- Stay signed in across restarts until the refresh token expires (30
  days on the backend, renewed on each refresh) or the learner logs out.

## Non-Goals

- Biometric unlock.
- Skipping goal selection on sign-in for returning learners.

## Decisions

- `AuthTokenStore` writes the access token, refresh token and its expiry
  through a `TokenVault`; the app uses `SecureTokenVault`
  (`flutter_secure_storage`: iOS Keychain, Android Keystore). Tests keep
  the default in-memory vault.
- `main` loads the tokens before the first screen.
- The Keychain outlives an uninstall, but the "signed in" flag doesn't:
  tokens found without that flag are cleared at startup.
- An expired refresh token (by its saved expiry) is cleared at startup,
  so the app opens on sign-in instead of failing on Home.
- The Firebase ID token stays in memory only.

## Functional Requirements

- FR-001: Saving or rotating a session shall persist it; logout and
  expiry shall erase it.
- FR-002: On startup the app shall restore a saved session.
- FR-003: Tokens without the signed-in flag, or past their expiry, shall
  be cleared at startup.

## Acceptance Criteria

- AC-001: save → a new store load restores all three values.
- AC-002: clear → the vault is empty.
- AC-003: Refresh rotation persists the new tokens.
- AC-004: Not signed in → restored tokens are dropped.
- AC-005: Expired refresh token → dropped.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-005 | Unit | `test/features/auth/data/auth_token_store_test.dart` |
| On device | Manual | Sign in, force-quit, reopen → still signed in |
