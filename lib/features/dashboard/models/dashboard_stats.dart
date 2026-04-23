// Modelos del Dashboard — Resumen de Impacto Económico.
// Alineado con la especificación: impacto por tipo, desglose por nivel, variación.

/// Impacto económico desglosado por nivel (sin mostrar personas).
class LevelImpact {
  final int level; // 1, 2 o 3
  final double economicImpact;
  final double percentageApplied;
  final double incomeGenerated;

  LevelImpact({
    required this.level,
    required this.economicImpact,
    required this.percentageApplied,
    required this.incomeGenerated,
  });
}

/// Actividad por tipo (restaurantes, conductores, usuarios).
class ActivityByType {
  final int activeHardware;
  final int activeSoftware;
  final int activeServices;

  ActivityByType({
    required this.activeHardware,
    required this.activeSoftware,
    required this.activeServices,
  });
}

/// Estado de actividad del embajador.
enum ActivityState { sinActividad, actividadInicial, actividadConstante }

extension ActivityStateExt on ActivityState {
  String get displayName {
    switch (this) {
      case ActivityState.sinActividad: return 'Sin actividad';
      case ActivityState.actividadInicial: return 'Actividad inicial';
      case ActivityState.actividadConstante: return 'Actividad constante';
    }
  }
}

/// Stats del dashboard principal.
class DashboardStats {
  final double economicImpact;
  final double estimatedIncome;
  final bool isIncomeConfirmed;
  final ActivityByType activityByType;
  final double variationPercent;
  final ActivityState activityState;
  final List<LevelImpact> levelBreakdown;
  final String selectedPeriod;

  DashboardStats({
    required this.economicImpact,
    required this.estimatedIncome,
    required this.isIncomeConfirmed,
    required this.activityByType,
    required this.variationPercent,
    required this.activityState,
    required this.levelBreakdown,
    this.selectedPeriod = 'Mes',
  });
}

/// Actividad diaria para gráficos de impacto.
class DailyActivity {
  final DateTime date;
  final double impact;
  final double income;

  DailyActivity({required this.date, required this.impact, required this.income});
}

/// Feed de actividad reciente del dashboard.
class ActivityItem {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final double? amount;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.amount,
  });
}
