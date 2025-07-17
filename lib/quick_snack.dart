/// A Flutter library for displaying beautiful, animated snackbars with ease.
///
/// This library provides a simple API for showing customizable snackbars
/// with predefined styles and smooth animations. It consists of two main classes:
/// - [QuickSnack]: A high-level, simplified API for common use cases
/// - [QuickSnackBarUtil]: A low-level API with extensive customization options
///
/// ## Quick Start:
/// ```dart
/// QuickSnack.show(
///   context: context,
///   title: "Success",
///   message: "Operation completed successfully!",
///   type: QuickSnackBarType.success,
/// );
/// ```
library quick_snack;

import 'package:flutter/material.dart';
import 'package:quick_snack/snackbar_util.dart';

/// A simplified utility class for displaying snackbars with predefined color schemes.
///
/// [QuickSnack] provides a high-level API that wraps [QuickSnackBarUtil] with
/// opinionated defaults and simplified color management. It's designed for developers
/// who want beautiful snackbars without extensive customization.
///
/// ## Key Features:
/// - Simplified API with sensible defaults
/// - Predefined color schemes for each message type
/// - Automatic color mapping based on snackbar type
/// - Consistent styling across your application
/// - All the animation benefits of [QuickSnackBarUtil]
///
/// ## Color Scheme:
/// - **Success**: Material Green for positive feedback
/// - **Failure**: Material Red for errors and failures
/// - **Warning**: Material Amber for cautions and warnings
/// - **Custom**: User-defined color or blue-grey fallback
///
/// ## Comparison with QuickSnackBarUtil:
/// - **QuickSnack**: Simple, opinionated, fewer parameters
/// - **QuickSnackBarUtil**: Full control, extensive customization, more parameters
///
/// Choose [QuickSnack] for consistency and simplicity, or [QuickSnackBarUtil]
/// for maximum flexibility and control.
///
/// ## Example Usage:
/// ```dart
/// // Simple success message
/// QuickSnack.show(
///   context: context,
///   title: "Success",
///   message: "Profile updated successfully!",
///   type: QuickSnackBarType.success,
/// );
///
/// // Error message at top of screen
/// QuickSnack.show(
///   context: context,
///   title: "Error",
///   message: "Failed to save changes. Please try again.",
///   type: QuickSnackBarType.failure,
///   snackBarPosition: SnackBarPosition.top,
/// );
///
/// // Warning without icon
/// QuickSnack.show(
///   context: context,
///   title: "Warning",
///   message: "This action cannot be undone.",
///   type: QuickSnackBarType.warning,
///   showIcon: false,
/// );
///
/// // Custom colored message
/// QuickSnack.show(
///   context: context,
///   title: "Custom",
///   message: "This is a custom styled message.",
///   type: QuickSnackBarType.custom,
///   customColor: Colors.purple,
/// );
/// ```
class QuickSnack {
  /// Displays a beautifully animated snackbar with predefined styling.
  ///
  /// This method provides a simplified interface for showing snackbars with
  /// consistent, predefined color schemes. It automatically maps snackbar types
  /// to appropriate colors and delegates to [QuickSnackBarUtil] for rendering.
  ///
  /// ## Parameters:
  ///
  /// ### Required Parameters:
  /// - [context]: The BuildContext for accessing the Overlay. Must have an Overlay ancestor.
  /// - [title]: The title text displayed prominently at the top of the snackbar.
  /// - [message]: The main message content displayed below the title.
  ///
  /// ### Optional Parameters:
  /// - [showIcon]: Whether to display the type-appropriate icon. Defaults to `true`.
  /// - [type]: The visual style and color scheme. Defaults to [QuickSnackBarType.success].
  /// - [snackBarPosition]: Screen position (top/bottom). Defaults to [SnackBarPosition.bottom].
  /// - [customColor]: Background color for [QuickSnackBarType.custom]. Ignored for other types.
  /// - [duration]: Visibility duration before auto-dismiss. Defaults to 3 seconds.
  ///
  /// ## Color Mapping:
  /// The method automatically selects colors based on the [type] parameter:
  /// - `QuickSnackBarType.success` → Material Green (Colors.green)
  /// - `QuickSnackBarType.failure` → Material Red (Colors.red)
  /// - `QuickSnackBarType.warning` → Material Amber (Colors.amber)
  /// - `QuickSnackBarType.custom` → [customColor] or blue-grey fallback
  ///
  /// ## Examples:
  /// ```dart
  /// // Basic success notification
  /// QuickSnack.show(
  ///   context: context,
  ///   title: "Success",
  ///   message: "Your changes have been saved successfully!",
  /// );
  ///
  /// // Error notification at top of screen
  /// QuickSnack.show(
  ///   context: context,
  ///   title: "Error",
  ///   message: "Network connection failed. Please check your internet.",
  ///   type: QuickSnackBarType.failure,
  ///   snackBarPosition: SnackBarPosition.top,
  /// );
  ///
  /// // Custom styled notification
  /// QuickSnack.show(
  ///   context: context,
  ///   title: "Custom Alert",
  ///   message: "This is a custom purple notification.",
  ///   type: QuickSnackBarType.custom,
  ///   customColor: Colors.deepPurple,
  ///   duration: Duration(seconds: 5),
  /// );
  ///
  /// // Warning without icon
  /// QuickSnack.show(
  ///   context: context,
  ///   title: "Attention",
  ///   message: "This action will permanently delete your data.",
  ///   type: QuickSnackBarType.warning,
  ///   showIcon: false,
  /// );
  /// ```
  ///
  /// ## Notes:
  /// - The [customColor] parameter only affects [QuickSnackBarType.custom]
  /// - For other types, predefined Material Design colors are used
  /// - All animations and behaviors are inherited from [QuickSnackBarUtil]
  /// - Multiple snackbars can be displayed simultaneously
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    bool showIcon = true,
    QuickSnackBarType type = QuickSnackBarType.success,
    SnackBarPosition snackBarPosition = SnackBarPosition.bottom,
    Color? customColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Map snackbar types to their corresponding Material Design colors
    // This provides consistent, accessible color schemes across the app
    Color backgroundColor =
        {
          QuickSnackBarType.success: Colors.green,
          // Positive feedback color
          QuickSnackBarType.failure: Colors.red,
          // Error and danger color
          QuickSnackBarType.warning: Colors.amber,
          // Caution and warning color
          QuickSnackBarType.custom: customColor ?? Colors.blueGrey,
          // User-defined or neutral fallback
        }[type] ??
        Colors.green; // Fallback to success color if type is null

    // Alternative implementation using switch statement (commented out)
    // This approach is more verbose but may be preferred in some codebases
    //
    // switch (type) {
    //   case QuickSnackBarType.success:
    //     backgroundColor = Colors.green;
    //     break;
    //   case QuickSnackBarType.failure:
    //     backgroundColor = Colors.red;
    //     break;
    //   case QuickSnackBarType.warning:
    //     backgroundColor = Colors.amber;
    //     break;
    //   case QuickSnackBarType.custom:
    //     backgroundColor = customColor ?? Colors.blueGrey;
    //     break;
    //   default:
    //     backgroundColor = Colors.green;
    //     break;
    // }

    // Delegate to the full-featured QuickSnackBarUtil with our simplified parameters
    QuickSnackBarUtil.show(
      context: context,
      title: title,
      message: message,
      type: type,
      position: snackBarPosition,
      customColor: backgroundColor,
      // Use our mapped color
      duration: duration,
      showIcon: showIcon,
    );
  }
}
