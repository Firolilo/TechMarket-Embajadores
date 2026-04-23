import 'package:flutter/material.dart';
import '../models/ambassador_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();
  AmbassadorUser? _user;
  bool _isLoading = false;
  String? _error;
  bool _hasSeenOnboarding = false;

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

  // ─── ATRIBUCIÓN (P0) ───
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

    _user = await _service.login(email, password);
    if (_user == null) {
      _error = 'Credenciales inválidas';
    }
    _isLoading = false;
    notifyListeners();
  }

  // ─── REGISTRO (P1) ───
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _user = await _service.register(
      name: name, email: email, phone: phone, password: password,
      refId: _refId, source: _source,
    );
    if (_user == null) {
      _error = 'Error al crear la cuenta';
    }
    _isLoading = false;
    notifyListeners();
  }

  // ─── VERIFICAR CÓDIGO INVITACIÓN (P2) ───
  Future<bool> verifyInvitationCode(String code) async {
    _isLoading = true;
    notifyListeners();

    final name = await _service.verifyInvitationCode(code);
    if (name != null) {
      _refId = code;
      _inviterName = name;
      _source = AttributionSource.manual;
    }
    _isLoading = false;
    notifyListeners();
    return name != null;
  }

  // ─── TIPO DE PARTICIPACIÓN (P3) ───
  void setParticipationType(ParticipationType type) {
    _participationType = type;
    notifyListeners();
  }

  // ─── VERIFICACIÓN EMAIL ───
  Future<void> sendEmailVerification() async {
    _isLoading = true;
    notifyListeners();
    _emailSent = await _service.sendEmailVerification(_user?.email ?? '');
    _isLoading = false;
    notifyListeners();
  }

  void confirmEmailVerified() {
    _emailVerified = true;
    notifyListeners();
  }

  // ─── VERIFICACIÓN TELÉFONO ───
  Future<void> sendPhoneOtp() async {
    _isLoading = true;
    notifyListeners();
    _otpSent = await _service.sendPhoneOtp(_user?.phone ?? '');
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyOtp(String code) async {
    _isLoading = true;
    notifyListeners();
    final result = await _service.verifyOtp(code);
    if (result) _phoneVerified = true;
    _isLoading = false;
    notifyListeners();
    return result;
  }

  // ─── LOGOUT ───
  void logout() {
    _user = null;
    _refId = null;
    _inviterName = null;
    _source = AttributionSource.organic;
    _participationType = null;
    _emailSent = false;
    _emailVerified = false;
    _otpSent = false;
    _phoneVerified = false;
    notifyListeners();
  }
}
