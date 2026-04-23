import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final _service = DashboardService();
  DashboardStats? _stats;
  List<ActivityItem> _activities = [];
  List<DailyActivity> _weeklyActivity = [];
  bool _isLoading = false;

  DashboardStats? get stats => _stats;
  List<ActivityItem> get activities => _activities;
  List<DailyActivity> get weeklyActivity => _weeklyActivity;
  bool get isLoading => _isLoading;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _service.getDashboardStats(),
      _service.getRecentActivity(),
      _service.getWeeklyActivity(),
    ]);

    _stats = results[0] as DashboardStats;
    _activities = results[1] as List<ActivityItem>;
    _weeklyActivity = results[2] as List<DailyActivity>;
    _isLoading = false;
    notifyListeners();
  }
}
