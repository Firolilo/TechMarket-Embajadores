import '../../../core/network/api_client.dart';
import '../models/opportunity.dart';

class OpportunityService {
  final ApiClient _client;

  OpportunityService({required ApiClient client}) : _client = client;

  Future<List<Opportunity>> getOpportunities() async {
    final response = await _client.get('/api/ambassadors/me/opportunities');
    return (response.data as List)
        .map((e) => _mapOpportunity(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsFollowing(String id) async {
    await _client.patch(
      '/api/ambassadors/me/opportunities/$id/status',
      data: {'status': 'enSeguimiento'},
    );
  }

  Future<void> markAsAttended(String id) async {
    await _client.patch(
      '/api/ambassadors/me/opportunities/$id/status',
      data: {'status': 'atendida'},
    );
  }

  Future<void> saveForLater(String id, bool isSaved) async {
    await _client.patch(
      '/api/ambassadors/me/opportunities/$id/save',
      data: {'saved': isSaved},
    );
  }

  Opportunity _mapOpportunity(Map<String, dynamic> j) {
    final String rawType = (j['type'] as String? ?? 'SERVICES').toUpperCase();
    final OpportunityType type = switch (rawType) {
      'HARDWARE' => OpportunityType.hardware,
      'SOFTWARE' => OpportunityType.software,
      _ => OpportunityType.servicios,
    };

    final String rawPotential = (j['potential'] as String? ?? 'medio').toLowerCase();
    final OpportunityPotential potential = switch (rawPotential) {
      'alto' => OpportunityPotential.alto,
      'bajo' => OpportunityPotential.bajo,
      _ => OpportunityPotential.medio,
    };

    final String rawStatus = (j['status'] as String? ?? 'nueva').toLowerCase();
    final OpportunityStatus status = switch (rawStatus) {
      'enseguimiento' || 'en_seguimiento' || 'enseguimiento' => OpportunityStatus.enSeguimiento,
      'atendida' => OpportunityStatus.atendida,
      _ => OpportunityStatus.nueva,
    };

    return Opportunity(
      id: j['id'] as String? ?? '',
      type: type,
      zone: j['zone'] as String? ?? '',
      description: j['description'] as String? ?? '',
      potential: potential,
      dataSource: j['dataSource'] as String? ?? '',
      status: status,
      isSaved: j['isSaved'] as bool? ?? false,
    );
  }
}
