# ADR 0004 Platform Plugins Behind Function Seams

Status: Accepted
Date: 2026-09-29
Supersedes:
Superseded By:

## Context

Porting `nisha-frontend` needs device features: photo picking (edit
profile), local notifications (daily reminders), opening phone, email and
web links (help resources), and the app version (About). Each needs a
third-party plugin with platform setup, and tests can't run the real
plugins.

## Options Considered

1. Use the Flutter-team or widely used plugins (`image_picker`,
   `flutter_local_notifications` + `timezone`, `url_launcher`,
   `package_info_plus`), each wrapped in a small function the feature
   injects; tests pass fakes.
2. Write platform channels ourselves.
3. Call plugins directly from pages and skip testing those paths.

## Decision

Adopt option 1.

- Add a plugin only when the feature using it lands.
- Each plugin sits behind one typedef'd function or tiny class in the
  feature's `data/` folder (e.g. `PhotoPicker`), created in the shell and
  injected into the page or view model. Pages never import a plugin.
- Platform setup (Info.plist usage strings, Android manifest entries) goes
  in the same commit as the plugin.

## Consequences

- Positive: Features stay testable with plain fakes; no plugin mocks.
- Positive: Swapping a plugin touches one file.
- Negative: The real plugin paths are only checked on devices.
- Negative: Each plugin adds native build setup and permission prompts.

## Links

- `../features/027-edit-profile/spec.md`
- `0002-data-layer.md`
