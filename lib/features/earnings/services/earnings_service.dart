import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/earning.dart';

/// Ganancias del embajador: comisiones y pagos reales de TechMarket-IA.
/// Usa la API admin (`/api/ambassadors/earnings/...`), que resuelve la
/// identidad por el header `X-User-Id` inyectado en [ApiClient].
class EarningsService {
  final ApiClient _client;

  EarningsService({required ApiClient client}) : _client = client;

  Future<List<ActivityEvent>> getActivityEvents() async {
    final response = await _client.get(ApiConstants.commissions);
    return (response.data as List)
        .map((e) => _mapCommission(e as Map<String, dynamic>))
        .toList();
  }

  ActivityEvent _mapCommission(Map<String, dynamic> j) {
    final String rawType = (j['eventType'] as String? ?? 'venta').toLowerCase();
    final ActivityType type = switch (rawType) {
      'suscripcion' || 'subscription' => ActivityType.suscripcion,
      'servicio' || 'service' => ActivityType.servicio,
      'registroactivo' || 'registro_activo' => ActivityType.registroActivo,
      _ => ActivityType.venta,
    };

    final String rawOrigin =
        (j['referenceType'] as String? ?? 'servicios').toLowerCase();
    final ActivityOrigin origin = switch (rawOrigin) {
      'hardware' => ActivityOrigin.hardware,
      'software' => ActivityOrigin.software,
      _ => ActivityOrigin.servicios,
    };

    return ActivityEvent(
      id: j['id'] as String? ?? '',
      date: _parseDate(j['fecha']),
      type: type,
      origin: origin,
      description: j['descripcion'] as String? ?? '',
      impactGenerated: (j['impactoGenerado'] as num?)?.toDouble() ?? 0.0,
      incomeAssociated: (j['monto'] as num?)?.toDouble() ?? 0.0,
      isConfirmed: j['confirmado'] as bool? ?? false,
      level: (j['nivel'] as num?)?.toInt() ?? 1,
    );
  }

  Future<List<PaymentRecord>> getPayments() async {
    final response = await _client.get(ApiConstants.payouts);
    return (response.data as List)
        .map((e) => _mapPayout(e as Map<String, dynamic>))
        .toList();
  }

  PaymentRecord _mapPayout(Map<String, dynamic> j) {
    final String fechaPago = j['fechaPago'] as String? ?? '';
    return PaymentRecord(
      id: j['id'] as String? ?? '',
      amount: (j['monto'] as num?)?.toDouble() ?? 0.0,
      method: j['metodo'] as String? ?? 'Transferencia',
      status: _parseLiquidation(j['estado'] as String?),
      requestedAt: _parseDate(j['fechaSolicitada']),
      paidAt: fechaPago.isEmpty ? null : DateTime.tryParse(fechaPago),
    );
  }

  static LiquidationStatus _parseLiquidation(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'pagado':
      case 'completado':
        return LiquidationStatus.paid;
      case 'procesando':
      case 'processing':
      case 'en_proceso':
        return LiquidationStatus.processing;
      default:
        return LiquidationStatus.pending;
    }
  }

  static DateTime _parseDate(dynamic raw) {
    if (raw is String && raw.isNotEmpty) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    return DateTime.now();
  }

  // El histórico por periodos y el gráfico mensual se derivan en pantalla a
  // partir de los eventos; no hay endpoint dedicado en la versión de bolsillo.
  Future<List<HistoricalPeriod>> getHistoricalPeriods() async => [];

  Future<List<MonthlyEarning>> getMonthlyEarnings() async => [];
}
