import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    webOptions: const WebOptions(
      dbName: 'techmarket_secure',
      publicKey: 'TechMarketAmbassadors2024',
    ),
  );

  // En web el Web Crypto API puede fallar; este mapa actúa de fallback
  // para la sesión actual (se pierde al refrescar la página).
  static final _mem = <String, String>{};

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kUserId = 'user_id';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    // Guarda en memoria primero (siempre funciona)
    _mem[_kAccess] = accessToken;
    _mem[_kRefresh] = refreshToken;
    _mem[_kUserId] = userId;

    // Intenta persistir en secure storage (puede fallar en web)
    await Future.wait([
      _safeWrite(_kAccess, accessToken),
      _safeWrite(_kRefresh, refreshToken),
      _safeWrite(_kUserId, userId),
    ]);
  }

  Future<String?> getAccessToken() => _safeRead(_kAccess);
  Future<String?> getRefreshToken() => _safeRead(_kRefresh);
  Future<String?> getUserId() => _safeRead(_kUserId);

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearTokens() async {
    _mem.clear();
    try {
      await _storage.deleteAll();
    } catch (e) {
      if (kDebugMode) debugPrint('TokenService clearTokens error: $e');
    }
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  Future<String?> _safeRead(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value != null) return value;
    } catch (e) {
      if (kDebugMode) debugPrint('TokenService read($key) error: $e');
    }
    // Fallback: valor en memoria (misma sesión)
    return _mem[key];
  }

  Future<void> _safeWrite(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      if (kDebugMode) debugPrint('TokenService write($key) error: $e');
      // El valor ya está en _mem, no se pierde
    }
  }
}
