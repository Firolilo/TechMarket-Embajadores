import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Decoraciones reutilizables: glassmorphism, gradientes, sombras.
class AppDecorations {
  AppDecorations._();

  // ── Glassmorphism ──────────────────────────────────────────
  static BoxDecoration glass({
    double borderRadius = 20,
    double opacity = 0.05,
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder
          ? Border.all(color: AppColors.glassBorder, width: 1)
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Contenedor glass con blur (para usar con BackdropFilter)
  static BoxDecoration glassBlur({double borderRadius = 20}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColors.glassBorder, width: 1),
    );
  }

  // ── Cards ──────────────────────────────────────────────────
  static BoxDecoration card({
    double borderRadius = 16,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      gradient: gradient ?? AppColors.cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColors.border, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration cardFlat({double borderRadius = 16}) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColors.border, width: 1),
    );
  }

  // ── Stats Card con glow ────────────────────────────────────
  static BoxDecoration statCard({
    required Color glowColor,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      gradient: AppColors.cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: glowColor.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: glowColor.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ── Inputs ─────────────────────────────────────────────────
  static InputDecoration inputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
    Widget? suffix,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: AppColors.textTertiary,
        fontSize: 14,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColors.textTertiary, size: 22)
          : null,
      suffix: suffix,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // ── Botón primario (gradiente) ─────────────────────────────
  static BoxDecoration primaryButton({double borderRadius = 12}) {
    return BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ── Bottom Navigation ──────────────────────────────────────
  static BoxDecoration bottomNav() {
    return BoxDecoration(
      color: AppColors.background.withValues(alpha: 0.95),
      border: Border(
        top: BorderSide(color: AppColors.border, width: 1),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  // ── Badge / Chip ───────────────────────────────────────────
  static BoxDecoration badge({
    required Color color,
    double borderRadius = 8,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
    );
  }
}
