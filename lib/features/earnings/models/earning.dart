// Modelos de Ganancias e Ingresos.
// Desglose por nivel, estados de liquidación, historial auditable.

/// Estado de liquidación del periodo.
enum LiquidationStatus { pending, processing, paid }

extension LiquidationStatusExt on LiquidationStatus {
  String get displayName {
    switch (this) {
      case LiquidationStatus.pending: return 'Pendiente';
      case LiquidationStatus.processing: return 'En proceso';
      case LiquidationStatus.paid: return 'Pagado';
    }
  }
}

/// Tipo de actividad que genera ingreso.
enum ActivityType { venta, suscripcion, servicio, registroActivo }

extension ActivityTypeExt on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.venta: return 'Venta';
      case ActivityType.suscripcion: return 'Suscripción';
      case ActivityType.servicio: return 'Servicio';
      case ActivityType.registroActivo: return 'Registro activo';
    }
  }
}

/// Origen de la actividad.
enum ActivityOrigin { hardware, software, servicios }

extension ActivityOriginExt on ActivityOrigin {
  String get displayName {
    switch (this) {
      case ActivityOrigin.hardware: return 'Hardware';
      case ActivityOrigin.software: return 'Software';
      case ActivityOrigin.servicios: return 'Servicios';
    }
  }
}

/// Resumen financiero de un periodo.
class PeriodSummary {
  final String period;
  final double periodIncome;
  final bool isConfirmed;
  final double economicImpact;
  final LiquidationStatus liquidationStatus;
  final DateTime? paymentDate;

  PeriodSummary({
    required this.period,
    required this.periodIncome,
    required this.isConfirmed,
    required this.economicImpact,
    required this.liquidationStatus,
    this.paymentDate,
  });
}

/// Evento de actividad detallado (tabla de ingresos).
class ActivityEvent {
  final String id;
  final DateTime date;
  final ActivityType type;
  final ActivityOrigin origin;
  final String description;
  final double impactGenerated;
  final double incomeAssociated;
  final bool isConfirmed;
  final int level;

  ActivityEvent({
    required this.id,
    required this.date,
    required this.type,
    required this.origin,
    required this.description,
    required this.impactGenerated,
    required this.incomeAssociated,
    required this.isConfirmed,
    required this.level,
  });
}

/// Resumen histórico para reportes.
class HistoricalPeriod {
  final String period;
  final double economicImpact;
  final double ambassadorIncome;
  final LiquidationStatus status;
  final DateTime? paymentDate;

  HistoricalPeriod({
    required this.period,
    required this.economicImpact,
    required this.ambassadorIncome,
    required this.status,
    this.paymentDate,
  });
}

/// Método de pago para liquidaciones (separado de payment method del perfil).
class PaymentRecord {
  final String id;
  final double amount;
  final String method;
  final LiquidationStatus status;
  final DateTime requestedAt;
  final DateTime? paidAt;

  PaymentRecord({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.requestedAt,
    this.paidAt,
  });
}

/// Ganancia mensual para gráfico de barras.
class MonthlyEarning {
  final String month;
  final double amount;

  MonthlyEarning({required this.month, required this.amount});
}
