import 'package:flutter/material.dart';

/// Paleta de colores premium de TechMarket Embajadores.
/// Estilo dark-tech con acentos cyan eléctricos.
class AppColors {
  AppColors._();

  // ── Primarios ──────────────────────────────────────────────
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF00B8D4);
  static const Color primaryLight = Color(0xFF6EFFFF);

  // ── Fondos ─────────────────────────────────────────────────
  static const Color background = Color(0xFF0A1929);
  static const Color backgroundLight = Color(0xFF0D2137);
  static const Color surface = Color(0xFF132F4C);
  static const Color surfaceLight = Color(0xFF1A3A5C);
  static const Color card = Color(0xFF1E3A5F);
  static const Color cardHover = Color(0xFF254A73);

  // ── Textos ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textTertiary = Color(0xFF607D8B);
  static const Color textOnPrimary = Color(0xFF0A1929);

  // ── Estados ────────────────────────────────────────────────
  static const Color success = Color(0xFF66BB6A);
  static const Color successLight = Color(0xFF1B3A2D);
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFF3A2E1B);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFF3A1B1B);
  static const Color info = Color(0xFF42A5F5);

  // ── Bordes y divisores ─────────────────────────────────────
  static const Color border = Color(0xFF1E3A5C);
  static const Color borderLight = Color(0xFF2A4A6C);
  static const Color divider = Color(0xFF1A3050);

  // ── Tiers de embajador ─────────────────────────────────────
  static const Color tierBronce = Color(0xFFCD7F32);
  static const Color tierPlata = Color(0xFFC0C0C0);
  static const Color tierOro = Color(0xFFFFD700);
  static const Color tierPlatino = Color(0xFFE5E4E2);

  // ── Gradientes ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A1929), Color(0xFF0D2137), Color(0xFF132F4C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A3A5C), Color(0xFF132F4C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glassmorphism ──────────────────────────────────────────
  static Color glassWhite = Colors.white.withValues(alpha: 0.05);
  static Color glassBorder = Colors.white.withValues(alpha: 0.1);
  static Color glassHighlight = Colors.white.withValues(alpha: 0.15);
}
