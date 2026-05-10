import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // IAM Service — autenticación y gestión de usuarios
  static String get authBaseUrl =>
      dotenv.env['AUTH_BASE_URL'] ?? 'http://localhost:8080';

  // IA Vertical — ambassadors, referrals, commissions, etc.
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8092';

  static String get tenantId =>
      dotenv.env['TENANT_ID'] ?? '00000000-0000-0000-0000-000000000000';

  static bool get enableMockFallback =>
      dotenv.env['ENABLE_MOCK_FALLBACK'] == 'true';

  // ── Auth (IA Vertical) ─────────────────────────────────────
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // ── Ambassadors (IA Vertical) ───────────────────────────────
  static const String ambassadorMe = '/api/ambassadors/me';

  static String ambassadorById(String id) => '/api/ambassadors/$id';
  static String ambassadorReferrals(String id) => '/api/ambassadors/$id/referrals';
  static String ambassadorCommissions(String id) => '/api/ambassadors/$id/commissions';
}
