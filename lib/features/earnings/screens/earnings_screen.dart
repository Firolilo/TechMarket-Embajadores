import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/earning.dart';
import '../providers/earnings_provider.dart';

/// PANTALLA 6 – Ingresos y Actividad.
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});
  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<EarningsProvider>().loadEarnings());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EarningsProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: prov.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
                  const SizedBox(height: 16),
                  Text('Ingresos y actividad', style: AppTextStyles.heading2),
                  const SizedBox(height: 20),

                  // Resumen financiero
                  Row(children: [
                    Expanded(child: _SummaryCard(label: 'Ingresos', value: 'Bs ${prov.totalIncome.toStringAsFixed(0)}', badge: 'Estimado', color: AppColors.primary)),
                    const SizedBox(width: 10),
                    Expanded(child: _SummaryCard(label: 'Pagado', value: 'Bs ${prov.totalPaid.toStringAsFixed(0)}', badge: 'Confirmado', color: AppColors.success)),
                  ]),
                  const SizedBox(height: 10),
                  _SummaryCard(label: 'Pendiente de liquidación', value: 'Bs ${prov.totalPending.toStringAsFixed(0)}', badge: 'Pendiente', color: AppColors.warning),
                  const SizedBox(height: 20),

                  // Gráfico mensual
                  if (prov.monthlyEarnings.isNotEmpty) _MonthlyChart(data: prov.monthlyEarnings),
                  const SizedBox(height: 20),

                  // Actividad detallada
                  Text('Actividad detallada', style: AppTextStyles.heading4),
                  const SizedBox(height: 12),
                  ...prov.events.map((e) => _EventTile(event: e)),

                  // Pagos
                  const SizedBox(height: 20),
                  Text('Pagos', style: AppTextStyles.heading4),
                  const SizedBox(height: 12),
                  ...prov.payments.map((p) => _PaymentTile(payment: p)),
                  const SizedBox(height: 24),
                ]),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value, badge;
  final Color color;
  const _SummaryCard({required this.label, required this.value, required this.badge, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(16), decoration: AppDecorations.cardFlat(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(label, style: AppTextStyles.caption),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
            child: Text(badge, style: AppTextStyles.caption.copyWith(color: color, fontSize: 10))),
        ]),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.heading4),
      ]));
  }
}

class _MonthlyChart extends StatelessWidget {
  final List<MonthlyEarning> data;
  const _MonthlyChart({required this.data});
  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return Container(padding: const EdgeInsets.all(20), decoration: AppDecorations.card(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Ingresos mensuales', style: AppTextStyles.heading4),
        const SizedBox(height: 16),
        SizedBox(height: 150, child: BarChart(BarChartData(
          alignment: BarChartAlignment.spaceAround, maxY: maxVal * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22,
              getTitlesWidget: (v, m) {
                final i = v.toInt();
                if (i < 0 || i >= data.length) return const SizedBox();
                return Text(data[i].month, style: AppTextStyles.caption);
              }))),
          gridData: const FlGridData(show: false), borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
            BarChartRodData(toY: e.value.amount, width: 20, borderRadius: BorderRadius.circular(6), gradient: AppColors.primaryGradient),
          ])).toList(),
        ))),
      ]));
  }
}

class _EventTile extends StatelessWidget {
  final ActivityEvent event;
  const _EventTile({required this.event});
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(7)),
          child: Center(child: Text('N${event.level}', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontSize: 10)))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(event.description, style: AppTextStyles.labelSmall),
          Text('${event.type.displayName} · ${event.origin.displayName}', style: AppTextStyles.caption),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('+Bs ${event.incomeAssociated.toStringAsFixed(1)}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success)),
          Text(event.isConfirmed ? 'Confirmado' : 'Estimado', style: AppTextStyles.caption.copyWith(fontSize: 10)),
        ]),
      ]));
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentRecord payment;
  const _PaymentTile({required this.payment});
  Color get _color {
    switch (payment.status) {
      case LiquidationStatus.pending: return AppColors.warning;
      case LiquidationStatus.processing: return AppColors.info;
      case LiquidationStatus.paid: return AppColors.success;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)),
      child: Row(children: [
        Icon(Icons.account_balance_wallet_rounded, color: _color, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bs ${payment.amount.toStringAsFixed(2)}', style: AppTextStyles.labelLarge),
          Text(payment.method, style: AppTextStyles.caption),
        ])),
        StatChip(label: payment.status.displayName, color: _color),
      ]));
  }
}
