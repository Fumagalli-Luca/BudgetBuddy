import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const purple = Color(0xFF6C4DFF);
  static const lime = Color(0xFFC8F560);
  static const ink = Color(0xFF18171F);
  static const paper = Color(0xFFFFFBFF);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: purple,
      brightness: Brightness.light,
      primary: purple,
      secondary: lime,
      surface: paper,
    );

    return _base(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: purple,
      brightness: Brightness.dark,
      primary: const Color(0xFFB7A7FF),
      secondary: lime,
      surface: const Color(0xFF121118),
    );

    return _base(scheme);
  }

  static ThemeData _base(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      visualDensity: VisualDensity.standard,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest.withOpacity(0.56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
