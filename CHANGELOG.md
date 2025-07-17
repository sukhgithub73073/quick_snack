# Changelog

All notable changes to this project will be documented in this file.

## [0.0.2] - 2025-07-17

### Changed
- **Removed `get` package dependency**. The library no longer requires `GetX`, reducing bloat and simplifying integration.
- Refactored internal toast/snackbar mechanism to use Flutter's core `Overlay` and `Navigator` APIs.
- Global usage supported via `navigatorKey` for easier integration without `context`.

### Fixed
- Improved snackbar animation smoothness and layering in complex widget trees.
- Fixed snackbar stacking issue when showing multiple snackbars quickly.

### Added
- Added `position` option: show snackbars at `top` or `bottom`.
- Added support for optional `icon`, `dismiss on tap`, and custom `duration`.

---

## [0.0.1] - Initial release

- Introduced basic snackbar/toast utility using GetX.
- Supported types: success, failure, warning, info, and custom.
