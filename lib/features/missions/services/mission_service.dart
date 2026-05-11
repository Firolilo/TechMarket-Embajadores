import '../../../core/network/api_client.dart';
import '../models/mission.dart';

class MissionService {
  final ApiClient _client;

  MissionService({required ApiClient client}) : _client = client;

  Future<List<Mission>> getMissions() async {
    final response = await _client.get('/api/ambassadors/me/missions');
    return (response.data as List)
        .map((e) => _mapMission(e as Map<String, dynamic>))
        .toList();
  }

  Future<Mission> startMission(String id) async {
    final response = await _client.patch('/api/ambassadors/me/missions/$id/start');
    return _mapMission(response.data as Map<String, dynamic>);
  }

  Future<Mission> completeMission(String id) async {
    final response = await _client.patch('/api/ambassadors/me/missions/$id/complete');
    return _mapMission(response.data as Map<String, dynamic>);
  }

  Mission _mapMission(Map<String, dynamic> j) {
    final String rawType = (j['type'] as String? ?? 'hardware').toLowerCase();
    final MissionType type = switch (rawType) {
      'software' => MissionType.software,
      'servicios' || 'services' => MissionType.servicios,
      _ => MissionType.hardware,
    };

    final MissionPriority priority =
        (j['priority'] as String? ?? 'normal').toLowerCase() == 'alta'
            ? MissionPriority.alta
            : MissionPriority.normal;

    final String rawStatus = (j['status'] as String? ?? 'disponible').toLowerCase();
    final MissionStatus status = switch (rawStatus) {
      'enprogreso' || 'en_progreso' => MissionStatus.enProgreso,
      'completada' => MissionStatus.completada,
      _ => MissionStatus.disponible,
    };

    final List<String> steps = (j['steps'] as List?)
            ?.map((s) => s as String)
            .toList() ??
        [];

    return Mission(
      id: j['id'] as String? ?? '',
      title: j['title'] as String? ?? '',
      description: j['description'] as String? ?? '',
      benefit: j['benefit'] as String? ?? '',
      type: type,
      priority: priority,
      status: status,
      steps: steps,
      completionCriteria: j['completionCriteria'] as String? ?? '',
      progress: (j['progress'] as num?)?.toDouble(),
    );
  }
}
