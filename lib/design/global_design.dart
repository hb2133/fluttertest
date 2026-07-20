import 'package:flutter/material.dart';

abstract final class GlobalDesign {
  static const Color CanvasColor = Color(0xFFF5F7FB);
  static const Color SurfaceColor = Colors.white;
  static const Color PrimaryColor = Color(0xFF5364E8);
  static const Color TextColor = Color(0xFF202334);
  static const Color MutedTextColor = Color(0xFF74798C);
  static const Color BorderColor = Color(0xFFE3E6EF);
  static const double NavigationWidth = 230;
  static const double EditorWidth = 360;
  static const double CornerRadius = 14;

  static ThemeData CreateTheme() {
    final ColorScheme ColorSchemeValue = ColorScheme.fromSeed(
      seedColor: PrimaryColor,
      brightness: Brightness.light,
      surface: SurfaceColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorSchemeValue,
      scaffoldBackgroundColor: CanvasColor,
      fontFamily: 'Segoe UI',
      dividerColor: BorderColor,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: SurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: BorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: BorderColor),
        ),
      ),
    );
  }
}
