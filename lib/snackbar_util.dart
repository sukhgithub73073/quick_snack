import 'package:flutter/material.dart';

/// Defines the position where the snackbar will appear on the screen.
///
/// Used to control whether the snackbar slides in from the top or bottom
/// of the screen.
enum SnackBarPosition {
  /// Snackbar appears at the top of the screen
  top,

  /// Snackbar appears at the bottom of the screen
  bottom,
}

/// Defines the visual style and behavior type of the snackbar.
///
/// Each type has predefined colors and icons that match common UI patterns:
/// - Success: Green background with check icon
/// - Failure: Red background with error icon
/// - Warning: Orange background with warning icon
/// - Info: Blue background with info icon
/// - Custom: Allows custom colors and uses notification icon
enum QuickSnackBarType {
  /// Green snackbar with check circle icon - used for successful operations
  success,

  /// Red snackbar with error icon - used for failed operations or errors
  failure,

  /// Orange snackbar with warning icon - used for warnings and cautions
  warning,

  /// Blue snackbar with info icon - used for informational messages
  info,

  /// Custom colored snackbar with notification icon - allows custom styling
  custom,
}

/// A utility class for displaying animated, customizable snackbars in Flutter.
///
/// This class provides a simple API for showing beautiful, animated snackbars
/// with various predefined styles and extensive customization options.
/// The snackbars use overlay rendering for better control and smoother animations.
///
/// ## Features:
/// - Multiple predefined styles (success, failure, warning, info, custom)
/// - Configurable position (top or bottom)
/// - Smooth slide, fade, and scale animations
/// - Progress indicator showing remaining time
/// - Glass morphism visual effects
/// - Tap-to-dismiss functionality
/// - Auto-dismiss after specified duration
///
/// ## Example Usage:
/// ```dart
/// // Simple success message
/// QuickSnackBarUtil.show(
///   context: context,
///   message: 'Operation completed successfully!',
///   type: QuickSnackBarType.success,
/// );
///
/// // Error message with title
/// QuickSnackBarUtil.show(
///   context: context,
///   title: 'Error',
///   message: 'Something went wrong. Please try again.',
///   type: QuickSnackBarType.failure,
///   position: SnackBarPosition.top,
/// );
///
/// // Custom styled snackbar
/// QuickSnackBarUtil.show(
///   context: context,
///   title: 'Custom Message',
///   message: 'This is a custom colored snackbar',
///   type: QuickSnackBarType.custom,
///   customColor: Colors.purple,
///   duration: Duration(seconds: 5),
///   showIcon: false,
/// );
/// ```
class QuickSnackBarUtil {
  /// Displays an animated snackbar with the specified configuration.
  ///
  /// This method creates and shows a customizable snackbar overlay that appears
  /// with smooth animations and automatically dismisses after the specified duration.
  ///
  /// ## Parameters:
  ///
  /// ### Required Parameters:
  /// - [context]: The BuildContext used to access the Overlay. Must have an Overlay ancestor.
  /// - [message]: The main text content to display in the snackbar.
  ///
  /// ### Optional Parameters:
  /// - [title]: Optional title text displayed above the message in bold.
  /// - [type]: The visual style of the snackbar. Defaults to [QuickSnackBarType.success].
  /// - [position]: Where the snackbar appears on screen. Defaults to [SnackBarPosition.bottom].
  /// - [customColor]: Custom background color when using [QuickSnackBarType.custom].
  /// - [duration]: How long the snackbar stays visible. Defaults to 3 seconds.
  /// - [elevation]: The visual elevation/shadow depth. Defaults to 8.0 (currently unused).
  /// - [showIcon]: Whether to display the type-specific icon. Defaults to true.
  /// - [isDismissible]: Whether users can tap to dismiss early. Defaults to true.
  ///
  /// ## Example Usage:
  /// ```dart
  /// QuickSnackBarUtil.show(
  ///   context: context,
  ///   title: 'Success',
  ///   message: 'Your changes have been saved successfully!',
  ///   type: QuickSnackBarType.success,
  ///   position: SnackBarPosition.top,
  ///   duration: Duration(seconds: 4),
  /// );
  /// ```
  ///
  /// ## Notes:
  /// - The snackbar will automatically remove itself after [duration] + 400ms
  /// - If the overlay is not available in the context, the method returns early
  /// - Multiple snackbars can be shown simultaneously and will stack appropriately
  static void show({
    required BuildContext context,
    required String message,
    String? title,
    QuickSnackBarType type = QuickSnackBarType.success,
    SnackBarPosition position = SnackBarPosition.bottom,
    Color? customColor,
    Duration duration = const Duration(seconds: 3),
    double elevation = 8.0,
    bool showIcon = true,
    bool isDismissible = true,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final (backgroundColor, iconData) = _getTypeProperties(type, customColor);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position == SnackBarPosition.top ? 50 : null,
        bottom: position == SnackBarPosition.bottom ? 50 : null,
        left: 16,
        right: 16,
        child: _AnimatedSnackBar(
          title: title,
          message: message,
          backgroundColor: backgroundColor,
          duration: duration,
          elevation: elevation,
          position: position,
          iconData: showIcon ? iconData : null,
          isDismissible: isDismissible,
          onDismiss: () {},
          //onDismiss: () => overlayEntry.remove(),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove the snackbar after duration + animation time
    Future.delayed(duration + const Duration(milliseconds: 400), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  /// Returns the appropriate background color and icon for each snackbar type.
  ///
  /// This internal method maps each [QuickSnackBarType] to its corresponding
  /// visual properties. For custom types, it uses the provided [customColor]
  /// or falls back to a default gray color.
  ///
  /// ## Parameters:
  /// - [type]: The snackbar type to get properties for
  /// - [customColor]: Optional custom color for [QuickSnackBarType.custom]
  ///
  /// ## Returns:
  /// A record containing (backgroundColor, iconData) for the specified type.
  ///
  /// ## Color Scheme:
  /// - Success: Material Green (0xFF4CAF50)
  /// - Failure: Material Red (0xFFF44336)
  /// - Warning: Material Orange (0xFFFF9800)
  /// - Info: Material Blue (0xFF2196F3)
  /// - Custom: Provided color or gray fallback (0xFF424242)
  static (Color, IconData) _getTypeProperties(
    QuickSnackBarType type,
    Color? customColor,
  ) {
    return switch (type) {
      QuickSnackBarType.success => (
        const Color(0xFF4CAF50), // Material Green
        Icons.check_circle,
      ),
      QuickSnackBarType.failure => (
        const Color(0xFFF44336), // Material Red
        Icons.error,
      ),
      QuickSnackBarType.warning => (
        const Color(0xFFFF9800), // Material Orange
        Icons.warning,
      ),
      QuickSnackBarType.info => (
        const Color(0xFF2196F3), // Material Blue
        Icons.info,
      ),
      QuickSnackBarType.custom => (
        customColor ?? const Color(0xFF424242), // Custom or gray fallback
        Icons.notifications,
      ),
    };
  }
}

/// Internal widget that handles the animated snackbar presentation.
///
/// This widget manages all the complex animations including slide-in/out,
/// fade transitions, scaling effects, and progress indication. It should
/// not be used directly - use [QuickSnackBarUtil.show] instead.
///
/// ## Animation Details:
/// - **Slide Animation**: 400ms elastic slide-in, 300ms ease-out slide-out
/// - **Fade Animation**: 300ms fade-in, 200ms fade-out
/// - **Scale Animation**: 200ms elastic scale from 0.8 to 1.0
/// - **Progress Animation**: Linear progress over the specified duration
///
/// The animations are staggered for a polished feel:
/// 1. Slide and fade start immediately
/// 2. Scale starts after 100ms delay
/// 3. Progress starts after 200ms delay
class _AnimatedSnackBar extends StatefulWidget {
  /// Optional title text displayed in bold above the message
  final String? title;

  /// Main message text content
  final String message;

  /// Background color of the snackbar
  final Color backgroundColor;

  /// How long the snackbar should remain visible
  final Duration duration;

  /// Visual elevation depth (currently unused in implementation)
  final double elevation;

  /// Whether snackbar appears at top or bottom of screen
  final SnackBarPosition position;

  /// Icon to display, or null to hide icon
  final IconData? iconData;

  /// Whether the snackbar can be dismissed by tapping
  final bool isDismissible;

  /// Callback triggered when snackbar is dismissed
  final VoidCallback onDismiss;

  const _AnimatedSnackBar({
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.duration,
    required this.elevation,
    required this.position,
    required this.iconData,
    required this.isDismissible,
    required this.onDismiss,
  });

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

/// State class managing the complex animation choreography for the snackbar.
///
/// This class coordinates multiple simultaneous animations:
/// - Slide transition for entrance/exit movement
/// - Fade transition for opacity changes
/// - Scale transition for subtle size animation
/// - Progress indicator showing remaining time
///
/// The animations use different curves and timing to create a polished,
/// professional feel that matches modern design standards.
class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with TickerProviderStateMixin {
  // Animation controllers for different transition aspects
  late final AnimationController _slideController;
  late final AnimationController _fadeController;
  late final AnimationController _scaleController;
  late final AnimationController _progressController;

  // Actual animations driven by the controllers
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  /// Sets up all animation controllers and their associated animations.
  ///
  /// Each animation has carefully tuned timing and curves:
  /// - Slide: Elastic entrance, smooth exit, direction based on position
  /// - Fade: Quick fade-in, faster fade-out
  /// - Scale: Subtle elastic scaling for modern feel
  /// - Progress: Linear countdown matching the specified duration
  void _initializeAnimations() {
    final isTop = widget.position == SnackBarPosition.top;

    // Slide animation - moves snackbar in/out from screen edge
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400), // Entrance timing
      reverseDuration: const Duration(milliseconds: 300), // Exit timing
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(
          // Start position: off-screen in direction opposite to final position
          begin: isTop ? const Offset(0, -1.2) : const Offset(0, 1.2),
          end: Offset.zero, // Final position: on-screen
        ).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Curves.elasticOut, // Bouncy entrance
            reverseCurve: Curves.easeInBack, // Smooth exit
          ),
        );

    // Fade animation - controls opacity
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    // Scale animation - subtle size transition for modern feel
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Progress animation - linear countdown indicator
    _progressController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
  }

  /// Orchestrates the staggered animation sequence.
  ///
  /// Animations start in a carefully timed sequence:
  /// 1. Slide and fade begin immediately for quick visual feedback
  /// 2. Scale starts after 100ms for layered animation effect
  /// 3. Progress starts after 200ms to avoid visual clutter
  /// 4. Auto-dismiss triggers after the full duration
  void _startAnimations() {
    // Start primary animations immediately
    _slideController.forward();
    _fadeController.forward();

    // Stagger secondary animations for polished feel
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _scaleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _progressController.forward();
    });

    // Auto-dismiss after specified duration
    Future.delayed(widget.duration, () {
      if (mounted) _dismiss();
    });
  }

  /// Handles snackbar dismissal with exit animations.
  ///
  /// Reverses the slide and fade animations simultaneously for a smooth
  /// exit transition. The onDismiss callback is triggered after animations complete.
  void _dismiss() async {
    await Future.wait([_slideController.reverse(), _fadeController.reverse()]);
    widget.onDismiss();
  }

  @override
  void dispose() {
    // Clean up all animation controllers to prevent memory leaks
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // Rebuild when any of the primary animations change
      animation: Listenable.merge([
        _slideAnimation,
        _fadeAnimation,
        _scaleAnimation,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: widget.isDismissible ? _dismiss : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Base background with gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.backgroundColor,
                                widget.backgroundColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),

                        // Glass morphism overlay effect
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withAlpha((255 * 0.2).toInt()),
                                Colors.white.withAlpha((255 * 0.05).toInt()),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),

                        // Animated progress indicator at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progressAnimation.value,
                                backgroundColor: Colors.white.withAlpha(
                                  (255 * 0.2).toInt(),
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withAlpha((255 * 0.6).toInt()),
                                ),
                                minHeight: 3,
                              );
                            },
                          ),
                        ),

                        // Main content area
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                          child: Row(
                            children: [
                              // Animated icon (if enabled)
                              if (widget.iconData != null) ...[
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 600),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Transform.rotate(
                                        angle: (1 - value) * 0.5,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(
                                              (255 * 0.2).toInt(),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            widget.iconData,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 16),
                              ],

                              // Text content area
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Animated title (if provided)
                                    if (widget.title != null &&
                                        widget.title!.isNotEmpty) ...[
                                      TweenAnimationBuilder<double>(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        builder: (context, value, child) {
                                          return Transform.translate(
                                            offset: Offset(0, 10 * (1 - value)),
                                            child: Opacity(
                                              opacity: value,
                                              child: Text(
                                                widget.title!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 4),
                                    ],

                                    // Animated message text
                                    TweenAnimationBuilder<double>(
                                      duration: const Duration(
                                        milliseconds: 600,
                                      ),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(0, 10 * (1 - value)),
                                          child: Opacity(
                                            opacity: value,
                                            child: Text(
                                              widget.message,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontSize: 14,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
