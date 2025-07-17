library quick_snack;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The type of Snack to be displayed.
///
/// - [success] — Green background
/// - [failure] — Red background
/// - [warning] — Amber (yellow) background
/// - [custom] — Custom color (must be provided)
enum SnackType {
  /// Green background for success messages
  success,

  /// Red background for error/failure messages
  failure,

  /// Amber background for warning messages
  warning,

  /// Custom background color (requires `customColor`)
  custom,
}

/// A utility class to show Snack/snackbar messages using GetX.
///
/// This class supports different Snack types like success, failure,
/// warning, and custom styles.
class EasySnack {
  /// Shows a Snack message using GetX's `Get.snackbar()`.
  ///
  /// [message] is the main content of the Snack.
  ///
  /// [type] determines the style and background color:
  /// - `SnackType.success` (green)
  /// - `SnackType.failure` (red)
  /// - `SnackType.warning` (amber)
  /// - `SnackType.custom` (uses `customColor`)
  ///
  /// [customColor] is only used when `type` is set to `SnackType.custom`.
  ///
  /// [duration] sets how long the Snack is visible (default: 2 seconds).
  static void show({
    required String title,
    required String message,
    SnackType type = SnackType.success,
    Color? customColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    Color backgroundColor;

    switch (type) {
      case SnackType.success:
        backgroundColor = Colors.green;
        break;
      case SnackType.failure:
        backgroundColor = Colors.red;
        break;
      case SnackType.warning:
        backgroundColor = Colors.amber;
        break;
      case SnackType.custom:
        backgroundColor = customColor ?? Colors.blueGrey;
        break;
    }

    Get.snackbar(
      '',
      '',
      titleText: title == ""
          ? const SizedBox.shrink()
          : Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: duration,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
