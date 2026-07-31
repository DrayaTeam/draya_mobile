import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Arabic-first typography tokens from the Draya design system.
abstract final class AppTextStyles {
  static const String fontFamily = 'Cairo';

  static TextStyle get h1 => _style(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.25,
  );

  static TextStyle get h2 => _style(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );

  static TextStyle get h3 => _style(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    height: 1.44,
  );

  static TextStyle get h4 => _style(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  static TextStyle get h5 => _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle get body => _style(fontSize: 14, height: 1.5);

  static TextStyle get button => _style(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static TextStyle get label => _style(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextTheme get textTheme {
    final base = GoogleFonts.cairoTextTheme();
    return base.copyWith(
      displaySmall: h1,
      headlineMedium: h2,
      headlineSmall: h3,
      titleSmall: h5,
      titleMedium: h4,
      bodyLarge: body,
      bodyMedium: body,
      labelLarge: button,
      labelMedium: label,
    );
  }

  static TextStyle _style({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    required double height,
  }) {
    return GoogleFonts.cairo(
      color: AppColors.textPrimary,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
