import '../models/mission.dart';
import '../../../data/mock/mock_data.dart';

class MissionService {
  Future<List<Mission>> getMissions() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.missions;
  }

  Future<void> startMission(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> completeMission(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
