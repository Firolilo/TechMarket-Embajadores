import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/services/token_service.dart';
import '../models/ambassador_user.dart';

class AuthService {
  final ApiClient _authClient;  // IAM  – puerto 8080
  final ApiClient _apiClient;   // IA Vertical – puerto 8092
  final TokenService _tokenService;

  AuthService({
    required ApiClient authClient,
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _authClient = authClient,
        _apiClient = apiClient,
        _tokenService = tokenService;

  Future<AmbassadorUser> login(String email, String password) async {
    final response = await _authClient.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    await _tokenService.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      userId: data['userId']?.toString() ?? '',
    );
    return _mapLoginResponseToUser(data);
  }

  Future<void> logout() => _tokenService.clearTokens();

  Future<bool> isAuthenticated() => _tokenService.hasValidToken();

  Future<AmbassadorUser> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? refId,
    AttributionSource source = AttributionSource.organic,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'attributionSource': source.name,
    };
    if (refId != null) body['refId'] = refId;
    final response = await _authClient.post(ApiConstants.register, data: body);
    final data = response.data as Map<String, dynamic>;
    await _tokenService.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      userId: data['userId']?.toString() ?? '',
    );
    return _mapLoginResponseToUser(data);
  }

  /// Verifica código de invitación (endpoint público).
  Future<String?> verifyInvitationCode(String code) async {
    try {
      final response = await _apiClient.get('/api/ambassadors/invitation/$code'); // IA vertical
      final data = response.data as Map<String, dynamic>;
      return data['inviterName'] as String?;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  AmbassadorUser _mapLoginResponseToUser(Map<String, dynamic> data) {
    return AmbassadorUser(
      id: data['userId']?.toString() ?? '',
      name: (data['username'] as String?)
          ?? '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
      email: (data['email'] as String?) ?? '',
      phone: (data['phone'] as String?) ?? '',
      tier: AmbassadorTier.bronce,
      attributionSource: AttributionSource.organic,
      participationType: ParticipationType.ambos,
      emailVerification: VerificationStatus.verified,
      phoneVerification: VerificationStatus.pending,
      onboardingStep: OnboardingStep.completed,
      totalReferrals: 0,
      activeBusinesses: 0,
      activeDrivers: 0,
      activeUsers: 0,
      totalEarnings: 0.0,
      ambassadorCode: (data['ambassadorCode'] as String?) ?? '',
      inviteUrl: (data['inviteUrl'] as String?) ?? '',
    );
  }
}
