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

  factory LevelImpact.fromJson(Map<String, dynamic> j) => LevelImpact(
        level: j['level'] as int,
        economicImpact: (j['economicImpact'] as num).toDouble(),
        percentageApplied: (j['percentageApplied'] as num).toDouble(),
        incomeGenerated: (j['incomeGenerated'] as num).toDouble(),
      );
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

  factory ActivityByType.fromJson(Map<String, dynamic> j) => ActivityByType(
        activeHardware: j['activeHardware'] as int,
        activeSoftware: j['activeSoftware'] as int,
        activeServices: j['activeServices'] as int,
      );
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

  factory DashboardStats.fromJson(Map<String, dynamic> j) => DashboardStats(
        economicImpact: (j['economicImpact'] as num).toDouble(),
        estimatedIncome: (j['estimatedIncome'] as num).toDouble(),
        isIncomeConfirmed: j['isIncomeConfirmed'] as bool,
        activityByType: ActivityByType.fromJson(
            j['activityByType'] as Map<String, dynamic>),
        variationPercent: (j['variationPercent'] as num).toDouble(),
        activityState: _parseState(j['activityState'] as String),
        levelBreakdown: (j['levelBreakdown'] as List)
            .map((e) => LevelImpact.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static ActivityState _parseState(String s) {
    switch (s) {
      case 'ACTIVIDAD_INICIAL':
        return ActivityState.actividadInicial;
      case 'ACTIVIDAD_CONSTANTE':
        return ActivityState.actividadConstante;
      default:
        return ActivityState.sinActividad;
    }
  }
}

/// Actividad diaria para gráficos de impacto.
class DailyActivity {
  final DateTime date;
  final double impact;
  final double income;

  DailyActivity({required this.date, required this.impact, required this.income});

  factory DailyActivity.fromJson(Map<String, dynamic> j) => DailyActivity(
        date: DateTime.parse(j['date'] as String),
        impact: (j['impact'] as num).toDouble(),
        income: (j['income'] as num).toDouble(),
      );
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

  factory ActivityItem.fromJson(Map<String, dynamic> j) => ActivityItem(
        title: j['title'] as String,
        subtitle: j['subtitle'] as String,
        timestamp: DateTime.parse(j['timestamp'] as String),
        amount: j['amount'] != null ? (j['amount'] as num).toDouble() : null,
      );
}
