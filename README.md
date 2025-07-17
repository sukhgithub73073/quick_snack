# Quick Snack

Quick Snack is a customizable toast/snackbar utility for Flutter. It's cleaner than
`ScaffoldMessenger` or `Get.snackbar`, and supports global usage without needing `BuildContext`.

Display animated snackbars such as success, error, warning, info, or custom messages with modern UI
and smooth animations.

---

## Features

- Built-in types:
    - Success (green)
    - Failure (red)
    - Warning (amber)
    - Info (blue)
    - Custom (use your own color)
- Smooth slide, fade, and scale animations
- Optional icons and progress bar
- Tap to dismiss
- Display at top or bottom
- Minimal setup

---

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  quick_snack: any
```

## Usage

You can show snackbars anywhere using `QuickSnackBarUtil.show()`.

### Show a success snackbar

```
QuickSnackBarUtil.show(
  context: context,
  title: 'Success',
  message: 'Data saved successfully!',
  type: QuickSnackBarType.success,
);
```

### Show a failure snackbar

```
QuickSnackBarUtil.show(
  context: context,
  title: 'Error',
  message: 'Something went wrong!',
  type: QuickSnackBarType.failure,
);
```

### Show a warning snackbar

```
QuickSnackBarUtil.show(
  context: context,
  title: 'Warning',
  message: 'Please check your input',
  type: QuickSnackBarType.warning,
);
```

### Show a custom-colored snackbar

```
QuickSnackBarUtil.show(
  context: context,
  title: 'Custom',
  message: 'This is a custom-colored snackbar',
  type: QuickSnackBarType.custom,
  customColor: Colors.purple,
);
```

✅ Paste this section into your `README.md` under the "Usage" heading. Let me know if you want to add
screenshots or badges next.
