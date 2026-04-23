import '../models/earning.dart';
import '../../../data/mock/mock_data.dart';

class EarningsService {
  Future<List<ActivityEvent>> getActivityEvents() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.activityEvents;
  }

  Future<List<HistoricalPeriod>> getHistoricalPeriods() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.historicalPeriods;
  }

  Future<List<MonthlyEarning>> getMonthlyEarnings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.monthlyEarnings;
  }

  Future<List<PaymentRecord>> getPayments() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.payments;
  }
}
