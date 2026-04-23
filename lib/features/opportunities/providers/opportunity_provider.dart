import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../services/opportunity_service.dart';

class OpportunityProvider extends ChangeNotifier {
  final _service = OpportunityService();
  List<Opportunity> _opportunities = [];
  bool _isLoading = false;
  OpportunityType? _filterType;
  OpportunityPotential? _filterPotential;

  List<Opportunity> get opportunities {
    var filtered = _opportunities;
    if (_filterType != null) filtered = filtered.where((o) => o.type == _filterType).toList();
    if (_filterPotential != null) filtered = filtered.where((o) => o.potential == _filterPotential).toList();
    return filtered;
  }

  List<Opportunity> get allOpportunities => _opportunities;
  bool get isLoading => _isLoading;
  OpportunityType? get filterType => _filterType;
  OpportunityPotential? get filterPotential => _filterPotential;

  int get newCount => _opportunities.where((o) => o.status == OpportunityStatus.nueva).length;
  int get followingCount => _opportunities.where((o) => o.status == OpportunityStatus.enSeguimiento).length;

  void setTypeFilter(OpportunityType? type) { _filterType = type; notifyListeners(); }
  void setPotentialFilter(OpportunityPotential? potential) { _filterPotential = potential; notifyListeners(); }

  Future<void> loadOpportunities() async {
    _isLoading = true;
    notifyListeners();
    _opportunities = await _service.getOpportunities();
    _isLoading = false;
    notifyListeners();
  }
}
