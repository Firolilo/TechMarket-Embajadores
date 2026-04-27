import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../services/opportunity_service.dart';

class OpportunityProvider extends ChangeNotifier {
  final _service = OpportunityService();
  List<Opportunity> _opportunities = [];
  bool _isLoading = false;
  OpportunityType? _filterType;
  OpportunityPotential? _filterPotential;
  OpportunityStatus? _filterStatus;

  List<Opportunity> get opportunities {
    var filtered = _opportunities;
    if (_filterType != null) filtered = filtered.where((o) => o.type == _filterType).toList();
    if (_filterPotential != null) filtered = filtered.where((o) => o.potential == _filterPotential).toList();
    if (_filterStatus != null) filtered = filtered.where((o) => o.status == _filterStatus).toList();
    return filtered;
  }

  List<Opportunity> get allOpportunities => _opportunities;
  List<Opportunity> get savedOpportunities => _opportunities.where((o) => o.isSaved).toList();
  List<Opportunity> get attendedOpportunities => _opportunities.where((o) => o.status == OpportunityStatus.atendida).toList();
  
  bool get isLoading => _isLoading;
  OpportunityType? get filterType => _filterType;
  OpportunityPotential? get filterPotential => _filterPotential;
  OpportunityStatus? get filterStatus => _filterStatus;

  int get newCount => _opportunities.where((o) => o.status == OpportunityStatus.nueva).length;
  int get followingCount => _opportunities.where((o) => o.status == OpportunityStatus.enSeguimiento).length;
  int get attendedCount => attendedOpportunities.length;
  int get savedCount => savedOpportunities.length;

  void setTypeFilter(OpportunityType? type) { 
    _filterType = type; 
    notifyListeners(); 
  }

  void setPotentialFilter(OpportunityPotential? potential) { 
    _filterPotential = potential; 
    notifyListeners(); 
  }

  void setStatusFilter(OpportunityStatus? status) { 
    _filterStatus = status; 
    notifyListeners(); 
  }

  Future<void> loadOpportunities() async {
    _isLoading = true;
    notifyListeners();
    _opportunities = await _service.getOpportunities();
    _isLoading = false;
    notifyListeners();
  }

  /// Marcar oportunidad como atendida
  Future<void> markAsAttended(String id) async {
    final index = _opportunities.indexWhere((o) => o.id == id);
    if (index != -1) {
      _opportunities[index] = _opportunities[index].copyWith(
        status: OpportunityStatus.atendida,
      );
      await _service.markAsAttended(id);
      notifyListeners();
    }
  }

  /// Marcar oportunidad como en seguimiento
  Future<void> markAsFollowing(String id) async {
    final index = _opportunities.indexWhere((o) => o.id == id);
    if (index != -1) {
      _opportunities[index] = _opportunities[index].copyWith(
        status: OpportunityStatus.enSeguimiento,
      );
      await _service.markAsFollowing(id);
      notifyListeners();
    }
  }

  /// Guardar/quitar de guardadas
  Future<void> toggleSaved(String id) async {
    final index = _opportunities.indexWhere((o) => o.id == id);
    if (index != -1) {
      _opportunities[index] = _opportunities[index].copyWith(
        isSaved: !_opportunities[index].isSaved,
      );
      await _service.saveForLater(id, !_opportunities[index].isSaved);
      notifyListeners();
    }
  }

  /// Obtener una oportunidad específica
  Opportunity? getOpportunityById(String id) {
    try {
      return _opportunities.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
}
