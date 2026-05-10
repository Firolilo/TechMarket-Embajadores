import 'package:flutter/material.dart';
import '../../../core/network/api_exception.dart';
import '../models/ambassador_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;

  AuthProvider({required AuthService service}) : _service = service;

  AmbassadorUser? _user;
  bool _isLoading = false;
  String? _error;
  bool _hasSeenOnboarding = false;
  bool _sessionChecked = false;

  // Registro multi-paso
  String? _refId;
  AttributionSource _source = AttributionSource.organic;
  String? _inviterName;
  ParticipationType? _participationType;

  // Verificación
  bool _emailSent = false;
  bool _emailVerified = false;
  bool _otpSent = false;
  bool _phoneVerified = false;

  AmbassadorUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get sessionChecked => _sessionChecked;

  // Registro
  String? get refId => _refId;
  AttributionSource get source => _source;
  String? get inviterName => _inviterName;
  ParticipationType? get participationType => _participationType;
  bool get hasInviter => _refId != null || _inviterName != null;

  // Verificación
  bool get emailSent => _emailSent;
  bool get emailVerified => _emailVerified;
  bool get otpSent => _otpSent;
  bool get phoneVerified => _phoneVerified;

  void completeOnboarding() {
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  /// Verifica al arrancar la app si ya hay sesión guardada.
  Future<void> checkExistingSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final authenticated = await _service.isAuthenticated();
      if (!authenticated) _user = null;
    } finally {
      _sessionChecked = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── ATRIBUCIÓN ───
  void setAttribution(String? refId, AttributionSource source) {
    _refId = refId;
    _source = source;
    notifyListeners();
  }

  // ─── LOGIN ───
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _service.login(email, password);
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        _error = 'Credenciales inválidas';
      } else if (e.isNetworkError) {
        _error = 'Sin conexión. Verifica tu red.';
      } else {
        _error = e.message;
      }
    } catch (_) {
      _error = 'Error inesperado. Intenta de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── REGISTRO ───
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _service.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        refId: _refId,
        source: _source,
      );
    } on ApiException catch (e) {
      _error = e.isNetworkError ? 'Sin conexión. Verifica tu red.' : e.message;
    } catch (_) {
      _error = 'Error inesperado. Intenta de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── VERIFICAR CÓDIGO INVITACIÓN ───
  Future<bool> verifyInvitationCode(String code) async {
    _isLoading = true;
    notifyListeners();
    try {
      final name = await _service.verifyInvitationCode(code);
      if (name != null) {
        _refId = code;
        _inviterName = name;
        _source = AttributionSource.manual;
        return true;
      }
      return false;
    } on ApiException {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── TIPO DE PARTICIPACIÓN ───
  void setParticipationType(ParticipationType type) {
    _participationType = type;
    notifyListeners();
  }

  // ─── VERIFICACIÓN EMAIL ───
  void confirmEmailVerified() {
    _emailVerified = true;
    notifyListeners();
  }

  // ─── LOGOUT ───
  Future<void> logout() async {
    await _service.logout();
    _user = null;
    _refId = null;
    _inviterName = null;
    _source = AttributionSource.organic;
    _participationType = null;
    _emailSent = false;
    _emailVerified = false;
    _otpSent = false;
    _phoneVerified = false;
    _error = null;
    notifyListeners();
  }
}
