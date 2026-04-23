import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/dashboard_stats.dart';

/// PANTALLA 5 (Spec) – Dashboard / Resumen de Impacto.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<DashboardProvider>().loadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dash = context.watch<DashboardProvider>();
    final user = auth.user;
    final stats = dash.stats;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: dash.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => dash.loadDashboard(),
                  child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Hola, ${user?.name.split(' ').first ?? 'Embajador'}', style: AppTextStyles.heading2),
                        const SizedBox(height: 2),
                        Text('Periodo: Abril 2026', style: AppTextStyles.bodySmall),
                      ])),
                      Container(width: 44, height: 44,
                        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.person, color: AppColors.textOnPrimary, size: 22)),
                    ]),
                    const SizedBox(height: 24),

                    if (stats != null) ...[
                      // Impacto económico
                      Container(
                        width: double.infinity, padding: const EdgeInsets.all(22),
                        decoration: AppDecorations.statCard(glowColor: AppColors.primary),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Impacto económico generado', style: AppTextStyles.labelMedium),
                          const SizedBox(height: 8),
                          AnimatedCounter(value: stats.economicImpact, prefix: 'Bs ', decimals: 0,
                            style: AppTextStyles.heading1.copyWith(fontSize: 36)),
                          const SizedBox(height: 6),
                          Row(children: [
                            Icon(stats.variationPercent >= 0 ? Icons.trending_up : Icons.trending_down,
                              color: stats.variationPercent >= 0 ? AppColors.success : AppColors.error, size: 18),
                            const SizedBox(width: 4),
                            Text('${stats.variationPercent >= 0 ? '+' : ''}${stats.variationPercent.toStringAsFixed(1)}% vs mes anterior',
                              style: AppTextStyles.bodySmall.copyWith(color: stats.variationPercent >= 0 ? AppColors.success : AppColors.error)),
                          ]),
                        ]),
                      ),
                      const SizedBox(height: 14),

                      // Ingresos estimados
                      Container(
                        padding: const EdgeInsets.all(18), decoration: AppDecorations.card(),
                        child: Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Ingresos estimados', style: AppTextStyles.labelMedium),
                            const SizedBox(height: 6),
                            AnimatedCounter(value: stats.estimatedIncome, prefix: 'Bs ', decimals: 0, style: AppTextStyles.heading3),
                          ])),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: (stats.isIncomeConfirmed ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8)),
                            child: Text(stats.isIncomeConfirmed ? 'Confirmado' : 'Estimado',
                              style: AppTextStyles.labelSmall.copyWith(color: stats.isIncomeConfirmed ? AppColors.success : AppColors.warning)),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 14),

                      // Actividad por tipo — Hardware, Software, Servicios
                      Row(children: [
                        Expanded(child: _TypeCard(icon: Icons.computer_rounded, label: 'Hardware', value: stats.activityByType.activeHardware)),
                        const SizedBox(width: 10),
                        Expanded(child: _TypeCard(icon: Icons.code_rounded, label: 'Software', value: stats.activityByType.activeSoftware)),
                        const SizedBox(width: 10),
                        Expanded(child: _TypeCard(icon: Icons.build_circle_outlined, label: 'Servicios', value: stats.activityByType.activeServices)),
                      ]),
                      const SizedBox(height: 14),

                      // Estado de actividad
                      Container(
                        padding: const EdgeInsets.all(14), decoration: AppDecorations.cardFlat(),
                        child: Row(children: [
                          const Icon(Icons.show_chart_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Text('Estado: ', style: AppTextStyles.bodySmall),
                          Text(stats.activityState.displayName, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                        ]),
                      ),
                      const SizedBox(height: 20),

                      // Desglose por nivel
                      Text('Desglose por nivel', style: AppTextStyles.heading4),
                      const SizedBox(height: 4),
                      Text('Cifras agregadas por nivel de impacto', style: AppTextStyles.caption),
                      const SizedBox(height: 12),
                      ...stats.levelBreakdown.map((l) => _LevelRow(impact: l)),
                      const SizedBox(height: 20),

                      // Actividad reciente
                      Text('Actividad reciente', style: AppTextStyles.heading4),
                      const SizedBox(height: 12),
                      ...dash.activities.take(4).map((a) => _ActivityTile(activity: a)),
                    ],
                    const SizedBox(height: 24),
                  ]),
                ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  const _TypeCard({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16), decoration: AppDecorations.cardFlat(),
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 26),
        const SizedBox(height: 6),
        Text(value.toString(), style: AppTextStyles.heading4),
        Text(label, style: AppTextStyles.caption),
      ]),
    );
  }
}

class _LevelRow extends StatelessWidget {
  final LevelImpact impact;
  const _LevelRow({required this.impact});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: AppDecorations.cardFlat(),
      child: Row(children: [
        Container(width: 32, height: 32,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text('N${impact.level}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bs ${impact.economicImpact.toStringAsFixed(0)}', style: AppTextStyles.labelMedium),
          Text('Impacto generado', style: AppTextStyles.caption),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('Bs ${impact.incomeGenerated.toStringAsFixed(0)}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.success)),
          Text('${impact.percentageApplied.toStringAsFixed(0)}%', style: AppTextStyles.caption),
        ]),
      ]),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem activity;
  const _ActivityTile({required this.activity});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(activity.title, style: AppTextStyles.labelMedium),
          Text(activity.subtitle, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        if (activity.amount != null)
          Text('+Bs ${activity.amount!.toStringAsFixed(0)}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success)),
      ]),
    );
  }
}
