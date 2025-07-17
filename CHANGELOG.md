# Changelog

All notable changes to this project will be documented in this file.

## [0.0.2]

### Changed
- **Removed `get` package dependency**: The library no longer requires `GetX`, reducing bloat and simplifying integration.
- Refactored internal toast/snackbar system to use Flutter's core `Overlay` and `Navigator` APIs.
- Enabled global usage using `navigatorKey` for easier integration without `BuildContext`.

### Fixed
- Improved animation smoothness and layering for snackbars in complex widget trees.
- Resolved issue where multiple snackbars stacked incorrectly when triggered rapidly.

### Added
- Introduced `position` option: display snackbars at either the `top` or `bottom` of the screen.
- Added support for optional `icon`, `dismiss on tap`, and custom `duration` settings.

---

## [0.0.1]

- Introduced basic snackbar/toast utility using GetX.
- Supported types: success, failure, warning, info, and custom.
