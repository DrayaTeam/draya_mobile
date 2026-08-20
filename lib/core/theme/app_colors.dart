import "package:flutter/material.dart";

abstract final class AppColors {
  // Core teal brand scale.
  static const Color primary900 = Color(0xFF0F4F49);
  static const Color primary800 = Color(0xFF145A53);
  static const Color primary700 = Color(0xFF1B6D63);
  static const Color primary600 = Color(0xFF228174);
  static const Color primary500 = Color(0xFF2D9B8A);
  static const Color primary400 = Color(0xFF52B6A8);
  static const Color primary300 = Color(0xFF83D1C7);
  static const Color primary200 = Color(0xFFB7E8E1);
  static const Color primary100 = Color(0xFFDDF5F1);
  static const Color primary50 = Color(0xFFF5FCFB);

  static const Color primary = primary700;

  // AI-powered feature scale.
  static const Color ai900 = Color(0xFF5B21B6);
  static const Color ai700 = Color(0xFF7C3AED);
  static const Color ai500 = Color(0xFF8B5CF6);
  static const Color ai300 = Color(0xFFC4B5FD);
  static const Color ai100 = Color(0xFFEDE9FE);
  static const Color ai50 = Color(0xFFF7F3FF);

  // Subject and status semantics.
  static const Color mathPhysics = Color(0xFF3B82F6);
  static const Color amber = Color(0xFFF59E0B);
  static const Color chemistryBiology = Color(0xFF22C55E);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color humanities = Color(0xFFEC4899);
  static const Color success = chemistryBiology;
  static const Color error = Color(0xFFEF4444);
  static const Color secondary = amber;

  // Surface, border, and typography tokens.
  static const Color background = Color(0xFFFAFAF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF8FBFA);
  static const Color backgroundMuted = Color(0xFFF4F8F7);
  static const Color foregroundMuted = Color(0xFF525E5A);
  static const Color backgroundAccent = Color(0xFFEFF8F6);
  static const Color border = Color(0xFFEBEFEF);
  static const Color borderStrong = Color(0xFFDDE4E2);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
}
