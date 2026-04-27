import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import '../models/referred_business.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final _service = DashboardService();
  DashboardStats? _stats;
  List<ActivityItem> _activities = [];
  List<DailyActivity> _weeklyActivity = [];
  List<ReferredBusiness> _referredBusinesses = [];
  bool _isLoading = false;

  DashboardStats? get stats => _stats;
  List<ActivityItem> get activities => _activities;
  List<DailyActivity> get weeklyActivity => _weeklyActivity;
  List<ReferredBusiness> get referredBusinesses => _referredBusinesses;
  bool get isLoading => _isLoading;

  // Estadísticas de empresas
  int get totalBusinesses => _referredBusinesses.length;
  int get activeBusinesses =>
      _referredBusinesses.where((b) => b.status == BusinessStatus.activo).length;
  double get totalMonthlyIncome =>
      _referredBusinesses.fold(0.0, (sum, b) => sum + b.monthlyIncome);
  double get totalMonthlyImpact =>
      _referredBusinesses.fold(0.0, (sum, b) => sum + b.monthlyImpact);

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _service.getDashboardStats(),
      _service.getRecentActivity(),
      _service.getWeeklyActivity(),
      _service.getReferredBusinesses(),
    ]);

    _stats = results[0] as DashboardStats;
    _activities = results[1] as List<ActivityItem>;
    _weeklyActivity = results[2] as List<DailyActivity>;
    _referredBusinesses = results[3] as List<ReferredBusiness>;
    _isLoading = false;
    notifyListeners();
  }
}
