// All colors used in the application are defined here. This is to ensure that
// the colors are consistent throughout the application. This is also to ensure
// that the colors are easily changed in the future.

// Stdlib
import 'package:flutter/widgets.dart';

/// Class for streamlining the colors used in the app (for consistency).
class AppColors {
  // Private constructor to prevent instances from this class
  AppColors._();

  // General colors
  static const Color white = Color(0xFFFFFFFF); // white
  static const Color black = Color(0xFF000000); // black

  // Widget theme colors
  static const Color widgetPrimary = Color(0xFF235668); // business green
  static const Color widgetSecondary = Color(0xFF235668); // dark green
  static const Color widgetLightPrimary = Color(0xFF3685A1); // dark green

  // Text theme colors
  static const Color textPrimary = Color(0xFF1A2E35); // dark business green
  static const Color textSecondary = Color(0xFFA3ABAE); // light gray

  // Card colors
  static Color cardBackgroundColor = const Color(0xFF235668).withOpacity(0.1);
  static const Color cardPrimaryButtonColor = Color(0xFFFF735C);
  static const Color ForExit = Color(0xFF3685A1);
  static final Color cardTextColor = const Color(0xFF1A2E35).withOpacity(0.6);
}
