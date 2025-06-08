import 'package:flutter/material.dart';

/// Helper functions to handle opacity while avoiding precision loss
extension ColorWithAlpha on Color {
  Color withAlphaValue(double opacity) {
    return withAlpha((opacity * 255).round());
  }

  Color get opacity10 => withAlpha(26); // 0.1 opacity
  Color get opacity15 => withAlpha(38); // 0.15 opacity
  Color get opacity20 => withAlpha(51); // 0.2 opacity
  Color get opacity40 => withAlpha(102); // 0.4 opacity
  Color get opacity60 => withAlpha(153); // 0.6 opacity
  Color get opacity80 => withAlpha(204); // 0.8 opacity
}

/// Utility class for color operations
class ColorUtils {
  static Color withAlpha(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  static Color withAlpha10(Color color) => color.withAlpha(26); // 0.1 opacity
  static Color withAlpha15(Color color) => color.withAlpha(38); // 0.15 opacity
  static Color withAlpha20(Color color) => color.withAlpha(51); // 0.2 opacity
  static Color withAlpha40(Color color) => color.withAlpha(102); // 0.4 opacity
  static Color withAlpha60(Color color) => color.withAlpha(153); // 0.6 opacity
  static Color withAlpha70(Color color) => color.withAlpha(179); // 0.7 opacity
  static Color withAlpha80(Color color) => color.withAlpha(204); // 0.8 opacity
}
