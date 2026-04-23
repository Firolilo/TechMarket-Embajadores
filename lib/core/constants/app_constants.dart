/// Constantes globales de la aplicación.
class AppConstants {
  AppConstants._();

  // ── App ────────────────────────────────────────────────────
  static const String appName = 'TechMarket Embajadores';
  static const String appVersion = '0.1.0';

  // ── Durations ──────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(seconds: 2);

  // ── Sizes ──────────────────────────────────────────────────
  static const double paddingXS = 4;
  static const double paddingSM = 8;
  static const double paddingMD = 16;
  static const double paddingLG = 24;
  static const double paddingXL = 32;
  static const double paddingXXL = 48;

  static const double radiusSM = 8;
  static const double radiusMD = 12;
  static const double radiusLG = 16;
  static const double radiusXL = 20;
  static const double radiusXXL = 28;

  static const double iconSM = 18;
  static const double iconMD = 24;
  static const double iconLG = 32;
  static const double iconXL = 48;

  // ── Referral ───────────────────────────────────────────────
  static const String referralBaseUrl = 'https://techmarket.app/ref/';

  // ── Tiers ──────────────────────────────────────────────────
  static const int tierPlataMin = 10;
  static const int tierOroMin = 25;
  static const int tierPlatinoMin = 50;
}
