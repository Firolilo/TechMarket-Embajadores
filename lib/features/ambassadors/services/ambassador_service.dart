import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';

class AmbassadorProfile {
  final String id;
  final String userId;
  final String referralCode;
  final String status;
  final String level;
  final DateTime? activatedAt;

  const AmbassadorProfile({
    required this.id,
    required this.userId,
    required this.referralCode,
    required this.status,
    required this.level,
    this.activatedAt,
  });

  factory AmbassadorProfile.fromJson(Map<String, dynamic> json) {
    return AmbassadorProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      referralCode: (json['referralCode'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      level: (json['level'] as String?) ?? 'BRONCE',
      activatedAt: json['activatedAt'] != null
          ? DateTime.parse(json['activatedAt'] as String)
          : null,
    );
  }
}

class AmbassadorReferral {
  final String id;
  final String ambassadorId;
  final String? tenantId;
  final String? attributionChannel;
  final String? usedCode;
  final String status;
  final DateTime? createdAt;

  const AmbassadorReferral({
    required this.id,
    required this.ambassadorId,
    this.tenantId,
    this.attributionChannel,
    this.usedCode,
    required this.status,
    this.createdAt,
  });

  factory AmbassadorReferral.fromJson(Map<String, dynamic> json) {
    return AmbassadorReferral(
      id: json['id'] as String,
      ambassadorId: json['ambassadorId'] as String,
      tenantId: json['tenantId'] as String?,
      attributionChannel: json['attributionChannel'] as String?,
      usedCode: json['usedCode'] as String?,
      status: (json['status'] as String?) ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

class AmbassadorCommission {
  final String id;
  final String ambassadorId;
  final String? eventType;
  final String? referenceType;
  final String amount;
  final String status;
  final DateTime? generatedAt;

  const AmbassadorCommission({
    required this.id,
    required this.ambassadorId,
    this.eventType,
    this.referenceType,
    required this.amount,
    required this.status,
    this.generatedAt,
  });

  factory AmbassadorCommission.fromJson(Map<String, dynamic> json) {
    return AmbassadorCommission(
      id: json['id'] as String,
      ambassadorId: json['ambassadorId'] as String,
      eventType: json['eventType'] as String?,
      referenceType: json['referenceType'] as String?,
      amount: (json['amount'] as String?) ?? '0',
      status: (json['status'] as String?) ?? '',
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'] as String)
          : null,
    );
  }
}

class AmbassadorService {
  final ApiClient _apiClient;

  AmbassadorService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<AmbassadorProfile> getMyProfile() async {
    final response = await _apiClient.get(ApiConstants.ambassadorMe);
    return AmbassadorProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AmbassadorProfile> getById(String ambassadorId) async {
    final response = await _apiClient.get(ApiConstants.ambassadorById(ambassadorId));
    return AmbassadorProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<AmbassadorReferral>> getReferrals(String ambassadorId) async {
    final response = await _apiClient.get(ApiConstants.ambassadorReferrals(ambassadorId));
    final list = response.data as List<dynamic>;
    return list
        .map((item) => AmbassadorReferral.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<AmbassadorCommission>> getCommissions(String ambassadorId) async {
    final response = await _apiClient.get(ApiConstants.ambassadorCommissions(ambassadorId));
    final list = response.data as List<dynamic>;
    return list
        .map((item) => AmbassadorCommission.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
