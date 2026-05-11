import '../../../core/network/api_client.dart';
import '../models/dashboard_stats.dart';
import '../models/referred_business.dart';

class DashboardService {
  final ApiClient _client;

  DashboardService({required ApiClient client}) : _client = client;

  Future<DashboardStats> getDashboardStats() async {
    final response = await _client.get('/api/ambassadors/me/dashboard');
    return DashboardStats.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ActivityItem>> getRecentActivity() async {
    final response = await _client.get('/api/ambassadors/me/activity');
    return (response.data as List)
        .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DailyActivity>> getWeeklyActivity() async {
    final response = await _client.get('/api/ambassadors/me/weekly-activity');
    return (response.data as List)
        .map((e) => DailyActivity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ReferredBusiness>> getReferredBusinesses() async {
    final response =
        await _client.get('/api/ambassadors/me/referred-businesses');
    return (response.data as List)
        .map((e) => ReferredBusiness.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
