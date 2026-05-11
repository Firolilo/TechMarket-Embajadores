import '../../../core/network/api_client.dart';
import '../../../data/mock/mock_data.dart';
import '../models/earning.dart';

class EarningsService {
  final ApiClient _client;

  EarningsService({required ApiClient client}) : _client = client;

  Future<List<ActivityEvent>> getActivityEvents() async {
    final response = await _client.get(
      '/api/ambassadors/me/activity',
      queryParameters: {'limit': 100},
    );
    return (response.data as List)
        .map((e) => _mapEvent(e as Map<String, dynamic>))
        .toList();
  }

  ActivityEvent _mapEvent(Map<String, dynamic> j) {
    final String title = j['title'] as String? ?? 'Comisión';
    final String subtitle = j['subtitle'] as String? ?? '';
    final DateTime date = DateTime.parse(j['timestamp'] as String);
    final double amount =
        j['amount'] != null ? (j['amount'] as num).toDouble() : 0.0;
    final String refType =
        (j['referralType'] as String?)?.toUpperCase() ?? 'SERVICES';

    final ActivityType type;
    final tl = title.toLowerCase();
    if (tl.contains('suscripci') || tl.contains('nueva')) {
      type = ActivityType.suscripcion;
    } else if (tl.contains('renov')) {
      type = ActivityType.suscripcion;
    } else if (tl.contains('venta')) {
      type = ActivityType.venta;
    } else {
      type = ActivityType.servicio;
    }

    final ActivityOrigin origin;
    switch (refType) {
      case 'HARDWARE':
        origin = ActivityOrigin.hardware;
        break;
      case 'SOFTWARE':
        origin = ActivityOrigin.software;
        break;
      default:
        origin = ActivityOrigin.servicios;
    }

    final int level = (j['level'] as int?) ?? 1;

    return ActivityEvent(
      id: 'comm_${date.millisecondsSinceEpoch}',
      date: date,
      type: type,
      origin: origin,
      description: '$title – $subtitle',
      impactGenerated: amount > 0 ? amount / 0.05 : 0.0,
      incomeAssociated: amount,
      isConfirmed: true,
      level: level,
    );
  }

  Future<List<HistoricalPeriod>> getHistoricalPeriods() async {
    return MockData.historicalPeriods;
  }

  // Chart data is computed from events in the screen; return empty list.
  Future<List<MonthlyEarning>> getMonthlyEarnings() async => [];

  Future<List<PaymentRecord>> getPayments() async {
    return MockData.payments;
  }
}
