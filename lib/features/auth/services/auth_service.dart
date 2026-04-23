import '../models/ambassador_user.dart';
import '../../../data/mock/mock_data.dart';

class AuthService {
  /// Simula login con credenciales fijas.
  Future<AmbassadorUser?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Credenciales de demo: admin / admin123
    if (email == 'admin' && password == 'admin123') {
      return MockData.currentUser;
    }
    return null;
  }

  /// Simula registro multi-paso.
  Future<AmbassadorUser?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? refId,
    AttributionSource source = AttributionSource.organic,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.currentUser;
  }

  /// Verifica código de invitación.
  Future<String?> verifyInvitationCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (code == 'AF-00042') return 'Ana López';
    if (code.startsWith('AF-')) return 'Embajador verificado';
    return null;
  }

  /// Simula verificación de email.
  Future<bool> sendEmailVerification(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// Simula verificación de teléfono (envío OTP).
  Future<bool> sendPhoneOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// Simula verificación de código OTP.
  Future<bool> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return code == '123456';
  }
}
