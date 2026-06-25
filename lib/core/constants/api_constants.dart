import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // IAM Service — autenticación corporativa (no usado por el flujo embajador).
  static String get authBaseUrl =>
      dotenv.env['AUTH_BASE_URL'] ?? 'http://localhost:8080';

  // TechMarket-IA (vertical embajadores) — login + datos. Local = 8082.
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8082';

  static String get tenantId =>
      dotenv.env['TENANT_ID'] ?? '00000000-0000-0000-0000-000000000000';

  static bool get enableMockFallback =>
      dotenv.env['ENABLE_MOCK_FALLBACK'] == 'true';

  // ── Auth (IA) ───────────────────────────────────────────────
  // POST → {accessToken, refreshToken, userId, email, firstName, lastName}
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // ── Dashboard / actividad (API mobile, identidad por JWT) ───
  static const String dashboard = '/api/ambassadors/me/dashboard';
  static const String activity = '/api/ambassadors/me/activity';
  static const String weeklyActivity = '/api/ambassadors/me/weekly-activity';
  static const String referredBusinesses =
      '/api/ambassadors/me/referred-businesses';

  // ── Misiones / oportunidades (API mobile) ───────────────────
  static const String missions = '/api/ambassadors/me/missions';
  static const String opportunities = '/api/ambassadors/me/opportunities';

  // ── Ganancias / comisiones (API admin, identidad por X-User-Id) ──
  static const String commissions = '/api/ambassadors/earnings/commissions';
  static const String commissionsSummary =
      '/api/ambassadors/earnings/commissions/summary';
  static const String wallet = '/api/ambassadors/earnings/wallet';
  static const String payouts = '/api/ambassadors/earnings/payouts';
}
