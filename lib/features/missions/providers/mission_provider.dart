import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../services/mission_service.dart';

class MissionProvider extends ChangeNotifier {
  final _service = MissionService();
  List<Mission> _missions = [];
  bool _isLoading = false;
  MissionStatus? _filterStatus;
  MissionType? _filterType;

  List<Mission> get missions {
    var filtered = _missions;
    if (_filterStatus != null) filtered = filtered.where((m) => m.status == _filterStatus).toList();
    if (_filterType != null) filtered = filtered.where((m) => m.type == _filterType).toList();
    return filtered;
  }

  List<Mission> get availableMissions => _missions.where((m) => m.status == MissionStatus.disponible).toList();
  List<Mission> get inProgressMissions => _missions.where((m) => m.status == MissionStatus.enProgreso).toList();
  List<Mission> get completedMissions => _missions.where((m) => m.status == MissionStatus.completada).toList();
  bool get isLoading => _isLoading;

  void setStatusFilter(MissionStatus? status) { _filterStatus = status; notifyListeners(); }
  void setTypeFilter(MissionType? type) { _filterType = type; notifyListeners(); }

  Future<void> loadMissions() async {
    _isLoading = true;
    notifyListeners();
    _missions = await _service.getMissions();
    _isLoading = false;
    notifyListeners();
  }
}
