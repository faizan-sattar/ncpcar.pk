import 'package:flutter/material.dart';

/// Warm, certification-inspired palette: stamp red against paper neutrals,
/// with verified-green and amber kept strictly semantic (never used as accent).
class AppColors {
  final Color red;
  final Color redStrong;
  final Color redTint;
  final Color paper;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color inkSoft;
  final Color ash;
  final Color ashSoft;
  final Color verified;
  final Color verifiedBg;
  final Color amber;
  final Color amberBg;

  const AppColors({
    required this.red,
    required this.redStrong,
    required this.redTint,
    required this.paper,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.inkSoft,
    required this.ash,
    required this.ashSoft,
    required this.verified,
    required this.verifiedBg,
    required this.amber,
    required this.amberBg,
  });

  static const light = AppColors(
    red: Color(0xFF0EA5E9),
    redStrong: Color(0xFF0369A1),
    redTint: Color(0xFFE0F2FE),
    paper: Color(0xFFF7F4EC),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFEFEAE0),
    ink: Color(0xFF1C1A17),
    inkSoft: Color(0xFF5B564C),
    ash: Color(0xFF8B8579),
    ashSoft: Color(0xFFD9D3C4),
    verified: Color(0xFF1E7A46),
    verifiedBg: Color(0xFFE4F1E8),
    amber: Color(0xFFA66A00),
    amberBg: Color(0xFFF5E9D2),
  );

  static const dark = AppColors(
    red: Color(0xFF38BDF8),
    redStrong: Color(0xFF7DD3FC),
    redTint: Color(0xFF0C3A56),
    paper: Color(0xFF16140F),
    surface: Color(0xFF211E19),
    surface2: Color(0xFF2B2721),
    ink: Color(0xFFF3EFE6),
    inkSoft: Color(0xFFC7C0B0),
    ash: Color(0xFF8F897B),
    ashSoft: Color(0xFF3A352C),
    verified: Color(0xFF3FBE79),
    verifiedBg: Color(0xFF153422),
    amber: Color(0xFFE0A23B),
    amberBg: Color(0xFF3A2C10),
  );
}

extension AppColorsContext on BuildContext {
  AppColors get colors =>
      Theme.of(this).brightness == Brightness.dark ? AppColors.dark : AppColors.light;
}

class AppRadius {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double pill = 999;
}

class AppSpace {
  static const double s1 = 4, s2 = 8, s3 = 12, s4 = 16, s5 = 20, s6 = 24, s7 = 32;
}

/// Bebas Neue — condensed display face, used only for prices, hero headline
/// and section numerals. Deliberately not used for running text.
TextStyle displayStyle({required double size, Color? color, double letterSpacing = 0.4}) {
  return TextStyle(
    fontFamily: 'BebasNeue',
    fontSize: size,
    color: color,
    letterSpacing: letterSpacing,
    height: 1.0,
  );
}

/// Manrope is shipped as a variable font; weight must be driven via
/// [FontVariation] rather than the plain [FontWeight] enum.
TextStyle bodyStyle({
  required double size,
  double weight = 400,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: 'Manrope',
    fontSize: size,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    fontVariations: [FontVariation('wght', weight)],
    fontWeight: weight >= 700 ? FontWeight.w700 : (weight >= 500 ? FontWeight.w500 : FontWeight.w400),
  );
}

/// JetBrains Mono for VIN/mileage/price figures — a data-sheet register with
/// tabular numerals so columns of digits line up.
TextStyle monoStyle({required double size, double weight = 400, Color? color}) {
  return TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: size,
    color: color,
    fontVariations: [FontVariation('wght', weight)],
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

TextStyle eyebrowStyle(Color color) => TextStyle(
      fontFamily: 'Manrope',
      fontSize: 11,
      color: color,
      fontVariations: const [FontVariation('wght', 700)],
      letterSpacing: 1.1,
    );

ThemeData buildAppTheme(AppColors c, Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: c.paper,
    fontFamily: 'Manrope',
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: c.red,
      onPrimary: Colors.white,
      secondary: c.verified,
      onSecondary: Colors.white,
      error: c.red,
      onError: Colors.white,
      surface: c.surface,
      onSurface: c.ink,
    ),
    splashFactory: InkRipple.splashFactory,
    dividerColor: c.ashSoft,
    textSelectionTheme: TextSelectionThemeData(selectionColor: c.red.withValues(alpha: 0.3)),
  );
}
