import '../models/dashboard_stats.dart';
import '../models/referred_business.dart';
import '../../../data/mock/mock_data.dart';

class DashboardService {
  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.dashboardStats;
  }

  Future<List<ActivityItem>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.recentActivity;
  }

  Future<List<DailyActivity>> getWeeklyActivity() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.weeklyActivity;
  }

  Future<List<ReferredBusiness>> getReferredBusinesses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.referredBusinesses;
  }
}
