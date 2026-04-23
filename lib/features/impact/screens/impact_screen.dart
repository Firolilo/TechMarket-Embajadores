import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../../dashboard/models/dashboard_stats.dart';

/// PANTALLA 7 – Mi Impacto (Análisis Personal).
class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<DashboardProvider>();
    final stats = dash.stats;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
            const SizedBox(height: 16),
            Text('Mi impacto', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('Análisis de tu desempeño personal', style: AppTextStyles.bodySmall),
            const SizedBox(height: 8),
            // Selector de periodo
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(children: ['Últimas 4 semanas', 'Mes', 'Trimestre'].map((p) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: p == 'Últimas 4 semanas' ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: p == 'Últimas 4 semanas' ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border)),
                  child: Text(p, style: AppTextStyles.caption.copyWith(
                    color: p == 'Últimas 4 semanas' ? AppColors.primary : AppColors.textSecondary)),
                ),
              )).toList())),
            const SizedBox(height: 24),

            // Evolución del impacto
            if (dash.weeklyActivity.isNotEmpty) _ImpactChart(data: dash.weeklyActivity),
            const SizedBox(height: 20),

            // Fuentes de impacto
            if (stats != null) ...[
              Text('Fuentes de impacto', style: AppTextStyles.heading4),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _SourceCard(icon: Icons.computer_rounded, label: 'Hardware', percent: _calcPercent(stats.activityByType.activeHardware, stats))),
                const SizedBox(width: 10),
                Expanded(child: _SourceCard(icon: Icons.code_rounded, label: 'Software', percent: _calcPercent(stats.activityByType.activeSoftware, stats))),
                const SizedBox(width: 10),
                Expanded(child: _SourceCard(icon: Icons.build_circle_outlined, label: 'Servicios', percent: _calcPercent(stats.activityByType.activeServices, stats))),
              ]),
              const SizedBox(height: 20),

              // Desglose por nivel
              Text('Desglose por nivel', style: AppTextStyles.heading4),
              const SizedBox(height: 12),
              ...stats.levelBreakdown.map((l) => Container(
                margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
                decoration: AppDecorations.cardFlat(),
                child: Row(children: [
                  Text('Nivel ${l.level}', style: AppTextStyles.labelMedium),
                  const Spacer(),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('Impacto: Bs ${l.economicImpact.toStringAsFixed(0)}', style: AppTextStyles.bodySmall),
                    Text('Ingreso: Bs ${l.incomeGenerated.toStringAsFixed(0)}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success)),
                  ]),
                ]),
              )),
              const SizedBox(height: 20),

              // Insight IA
              Container(padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.surface]),
                  borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary.withValues(alpha: 0.2))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18), const SizedBox(width: 8),
                    Text('Insights automáticos', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary))]),
                  const SizedBox(height: 10),
                  Text('• Tu impacto creció ${stats.variationPercent.toStringAsFixed(0)}% respecto al periodo anterior.', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Text('• La mayor parte de tu impacto proviene de hardware activo.', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Text('• Tu actividad es más alta los fines de semana.', style: AppTextStyles.bodySmall),
                ])),
            ],
            const SizedBox(height: 20),

            // Acciones sugeridas (Spec P7 – Bloque 6)
            Text('Acciones sugeridas', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => context.go('/opportunities'),
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Ver oportunidades'),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary), padding: const EdgeInsets.symmetric(vertical: 12)),
              )),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(
                onPressed: () => context.go('/missions'),
                icon: const Icon(Icons.flag_rounded, size: 16),
                label: const Text('Ver misiones'),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 12)),
              )),
            ]),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  double _calcPercent(int value, DashboardStats stats) {
    final total = stats.activityByType.activeHardware + stats.activityByType.activeSoftware + stats.activityByType.activeServices;
    if (total == 0) return 0;
    return value / total * 100;
  }
}

class _ImpactChart extends StatelessWidget {
  final List<DailyActivity> data;
  const _ImpactChart({required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(20), decoration: AppDecorations.card(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Evolución del impacto', style: AppTextStyles.heading4),
        const SizedBox(height: 16),
        SizedBox(height: 160, child: LineChart(LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1000,
            getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 0.5)),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22,
              getTitlesWidget: (v, m) {
                final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox();
                return Text(days[i], style: AppTextStyles.caption);
              }))),
          borderData: FlBorderData(show: false), minY: 0,
          lineBarsData: [
            LineChartBarData(spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.impact)).toList(),
              isCurved: true, color: AppColors.primary, barWidth: 3,
              belowBarData: BarAreaData(show: true, gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.primary.withValues(alpha: 0.0)]))),
          ],
        ))),
      ]));
  }
}

class _SourceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double percent;
  const _SourceCard({required this.icon, required this.label, required this.percent});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: AppDecorations.cardFlat(),
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 26),
        const SizedBox(height: 6),
        Text('${percent.toStringAsFixed(0)}%', style: AppTextStyles.heading4),
        Text(label, style: AppTextStyles.caption),
      ]));
  }
}
