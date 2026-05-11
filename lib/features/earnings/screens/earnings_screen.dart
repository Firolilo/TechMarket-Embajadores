import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
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
  String _selectedPeriod = '4 Sem.';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<EarningsProvider>().loadEarnings());
  }

  // ── date range helpers ────────────────────────────────────────────────────

  DateTime get _now => DateTime.now();

  DateTime get _startDate {
    final now = _now;
    final today = DateTime(now.year, now.month, now.day);
    switch (_selectedPeriod) {
      case 'Mes':
        return DateTime(now.year, now.month, 1);
      case 'Trimestre':
        return DateTime(now.year, now.month - 2, 1);
      default: // '4 Sem.'
        return today.subtract(const Duration(days: 27));
    }
  }

  DateTime get _endDate {
    final now = _now;
    if (_selectedPeriod == 'Mes') {
      return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  // ── chart data ────────────────────────────────────────────────────────────

  List<MonthlyEarning> _buildChartData(List<ActivityEvent> events) {
    final now = _now;
    final today = DateTime(now.year, now.month, now.day);

    if (_selectedPeriod == 'Trimestre') {
      // 3 monthly bars: 3 months ago → current month
      return List.generate(3, (i) {
        final int offset = 2 - i;
        final int rawMonth = now.month - offset;
        final int year = now.year + (rawMonth <= 0 ? -1 : 0);
        final int month = rawMonth <= 0 ? rawMonth + 12 : rawMonth;
        final start = DateTime(year, month, 1);
        final end = DateTime(year, month + 1, 1)
            .subtract(const Duration(seconds: 1));
        final sum = events
            .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
            .fold<double>(0, (s, e) => s + e.incomeAssociated);
        const names = [
          'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
          'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
        ];
        return MonthlyEarning(month: names[month - 1], amount: sum);
      });
    }

    if (_selectedPeriod == 'Mes') {
      // 4 calendar-week bars of the current month: days 1-7, 8-14, 15-21, 22-end
      final lastDay = DateTime(now.year, now.month + 1, 1)
          .subtract(const Duration(days: 1))
          .day;
      return List.generate(4, (i) {
        final dayStart = 1 + i * 7;
        if (dayStart > lastDay) {
          return MonthlyEarning(month: 'S${i + 1}', amount: 0);
        }
        final dayEnd = (i == 3) ? lastDay : (dayStart + 6).clamp(1, lastDay);
        final weekStart = DateTime(now.year, now.month, dayStart);
        final weekEnd =
            DateTime(now.year, now.month, dayEnd, 23, 59, 59);
        final sum = events
            .where(
                (e) => !e.date.isBefore(weekStart) && !e.date.isAfter(weekEnd))
            .fold<double>(0, (s, e) => s + e.incomeAssociated);
        return MonthlyEarning(month: 'S${i + 1}', amount: sum);
      });
    }

    // '4 Sem.' → 4 rolling weekly bars ending today
    return List.generate(4, (i) {
      final daysBack = (3 - i) * 7;
      final weekEnd = today.subtract(Duration(days: daysBack));
      final weekStart = weekEnd.subtract(const Duration(days: 6));
      final end =
          DateTime(weekEnd.year, weekEnd.month, weekEnd.day, 23, 59, 59);
      final sum = events
          .where((e) => !e.date.isBefore(weekStart) && !e.date.isAfter(end))
          .fold<double>(0, (s, e) => s + e.incomeAssociated);
      return MonthlyEarning(month: 'S${i + 1}', amount: sum);
    });
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EarningsProvider>();

    final filteredEvents = prov.events
        .where((e) => !e.date.isBefore(_startDate) && !e.date.isAfter(_endDate))
        .toList();
    final filteredPayments = prov.payments
        .where((p) =>
            !p.requestedAt.isBefore(_startDate) &&
            !p.requestedAt.isAfter(_endDate))
        .toList();

    final periodIncome = filteredEvents.fold<double>(
        0, (sum, e) => sum + e.incomeAssociated);
    final periodPending = filteredPayments
        .where((p) => p.status != LiquidationStatus.paid)
        .fold<double>(0, (sum, p) => sum + p.amount);

    final l1Income = filteredEvents
        .where((e) => e.level == 1)
        .fold<double>(0, (s, e) => s + e.incomeAssociated);
    final l2Income = filteredEvents
        .where((e) => e.level == 2)
        .fold<double>(0, (s, e) => s + e.incomeAssociated);
    final l3Income = filteredEvents
        .where((e) => e.level == 3)
        .fold<double>(0, (s, e) => s + e.incomeAssociated);

    final periodLabel = switch (_selectedPeriod) {
      'Mes' => 'del mes',
      'Trimestre' => 'del trimestre',
      _ => 'de las últimas 4 sem.',
    };
    final periodMessage = switch (_selectedPeriod) {
      'Mes' => 'Vista mensual: acumulados del mes en curso.',
      'Trimestre' => 'Vista trimestral: ingresos de los últimos 3 meses.',
      _ => 'Vista de 4 semanas: ingresos de los últimos 28 días.',
    };

    final chartData = _buildChartData(prov.events);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: prov.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 16),

                    // Header + period chips
                    Row(children: [
                      Expanded(
                          child: Text('Ingresos y actividad',
                              style: AppTextStyles.heading2)),
                      ...['4 Sem.', 'Mes', 'Trimestre'].map((p) => Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPeriod = p),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _selectedPeriod == p
                                      ? AppColors.primary
                                          .withValues(alpha: 0.15)
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedPeriod == p
                                        ? AppColors.primary
                                            .withValues(alpha: 0.5)
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(p,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: _selectedPeriod == p
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    )),
                              ),
                            ),
                          )),
                    ]),
                    const SizedBox(height: 20),

                    // Resumen financiero
                    Row(children: [
                      Expanded(
                          child: _SummaryCard(
                              label: 'Ingresos $periodLabel',
                              value:
                                  'Bs ${periodIncome.toStringAsFixed(0)}',
                              badge: 'Estimado',
                              color: AppColors.primary)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _SummaryCard(
                              label: 'Impacto $periodLabel',
                              value:
                                  'Bs ${(periodIncome * 20).toStringAsFixed(0)}',
                              badge: 'Bs',
                              color: AppColors.info)),
                    ]),
                    const SizedBox(height: 10),
                    _SummaryCard(
                        label: 'Estado de liquidación',
                        value:
                            'Bs ${periodPending.toStringAsFixed(0)} pendiente',
                        badge: periodPending > 0 ? 'Pendiente' : 'Pagado',
                        color: periodPending > 0
                            ? AppColors.warning
                            : AppColors.success),
                    const SizedBox(height: 20),

                    // Gráfico dinámico
                    _PeriodChart(data: chartData, period: _selectedPeriod),
                    const SizedBox(height: 20),

                    // Desglose por nivel
                    Text('Desglose por nivel (período)',
                        style: AppTextStyles.heading4),
                    const SizedBox(height: 4),
                    Text('Cifras agregadas, sin mostrar personas.',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textTertiary)),
                    const SizedBox(height: 12),
                    if (l1Income > 0)
                      _LevelBreakdownRow(
                          level: 1,
                          impact: l1Income / 0.05,
                          percent: 5.0,
                          income: l1Income),
                    if (l2Income > 0)
                      _LevelBreakdownRow(
                          level: 2,
                          impact: l2Income / 0.03,
                          percent: 3.0,
                          income: l2Income),
                    if (l3Income > 0)
                      _LevelBreakdownRow(
                          level: 3,
                          impact: l3Income / 0.02,
                          percent: 2.0,
                          income: l3Income),
                    if (l1Income == 0 && l2Income == 0 && l3Income == 0)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: AppDecorations.cardFlat(),
                        child: Center(
                          child: Text(
                            'Sin movimientos en este período.',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textTertiary),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Actividad detallada
                    Text('Actividad detallada',
                        style: AppTextStyles.heading4),
                    const SizedBox(height: 12),
                    if (filteredEvents.isEmpty)
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: AppDecorations.cardFlat(),
                          child: Center(
                              child: Text(
                                  'Aún no se registran movimientos en este periodo.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textTertiary))))
                    else
                      ...filteredEvents.map((e) => _EventTile(event: e)),

                    // Pagos
                    const SizedBox(height: 20),
                    Text('Pagos', style: AppTextStyles.heading4),
                    const SizedBox(height: 12),
                    if (filteredPayments.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: AppDecorations.cardFlat(),
                        child: Center(
                          child: Text(
                            'No hay pagos registrados en este periodo.',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textTertiary),
                          ),
                        ),
                      )
                    else
                      ...filteredPayments
                          .map((p) => _PaymentTile(payment: p)),
                    const SizedBox(height: 20),

                    // Info contextual
                    Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          const Icon(Icons.info_outline,
                              color: AppColors.info, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(periodMessage,
                                  style: AppTextStyles.caption
                                      .copyWith(color: AppColors.info))),
                        ])),
                    const SizedBox(height: 16),

                    // Botones de acción
                    Row(children: [
                      Expanded(
                          child: OutlinedButton.icon(
                        onPressed: () => _downloadReportPdf(),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text('Descargar reporte'),
                        style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12)),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: OutlinedButton.icon(
                        onPressed: () => _showMockRules(),
                        icon: const Icon(Icons.rule_rounded, size: 18),
                        label: const Text('Ver reglas'),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12)),
                      )),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _downloadReportPdf() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Generando PDF...')));
    try {
      if (kIsWeb) throw UnsupportedError('Descarga no disponible en Web.');
      final pdf = pw.Document();
      pdf.addPage(pw.Page(
          build: (_) => pw.Center(
              child: pw.Text(
                  'Reporte de ingresos ($_selectedPeriod)'))));
      final bytes = await pdf.save();
      final dir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final file = File(
          '${dir.path}/reporte_${_selectedPeriod.toLowerCase()}_$ts.pdf');
      await file.writeAsBytes(bytes, flush: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('PDF: ${file.path}'),
          backgroundColor: AppColors.success));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error));
    }
  }

  void _showMockRules() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
          child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text('Reglas de cálculo', style: AppTextStyles.heading4),
            const SizedBox(height: 10),
            Text('• Nivel 1: 5% del impacto confirmado.',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            Text('• Nivel 2: 3% del impacto confirmado.',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            Text('• Nivel 3: 2% del impacto confirmado.',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            Text(
                '• Los estimados pasan a confirmados en el cierre semanal.',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 14),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Entendido'))),
          ]),
        ),
      ),
    );
  }
}

// ── widgets ──────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label, value, badge;
  final Color color;
  const _SummaryCard(
      {required this.label,
      required this.value,
      required this.badge,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.cardFlat(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(label, style: AppTextStyles.caption),
            const Spacer(),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(badge,
                    style: AppTextStyles.caption
                        .copyWith(color: color, fontSize: 10))),
          ]),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.heading4),
        ]));
  }
}

class _LevelBreakdownRow extends StatelessWidget {
  final int level;
  final double impact, percent, income;
  const _LevelBreakdownRow(
      {required this.level,
      required this.impact,
      required this.percent,
      required this.income});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: AppDecorations.cardFlat(),
        child: Row(children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7)),
              child: Center(
                  child: Text('N$level',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary, fontSize: 10)))),
          const SizedBox(width: 10),
          Expanded(
              child: Text('Bs ${impact.toStringAsFixed(0)}',
                  style: AppTextStyles.labelSmall)),
          Text('${percent.toStringAsFixed(0)}%',
              style: AppTextStyles.caption),
          const SizedBox(width: 12),
          Text('Bs ${income.toStringAsFixed(0)}',
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.success)),
        ]));
  }
}

class _PeriodChart extends StatelessWidget {
  final List<MonthlyEarning> data;
  final String period;
  const _PeriodChart({required this.data, required this.period});

  @override
  Widget build(BuildContext context) {
    final hasData = data.any((e) => e.amount > 0);
    final maxVal = hasData
        ? data.map((e) => e.amount).reduce((a, b) => a > b ? a : b) * 1.2
        : 10.0;

    final title = switch (period) {
      'Trimestre' => 'Ingresos por mes',
      'Mes' => 'Ingresos por semana (mes actual)',
      _ => 'Ingresos por semana (últimas 4 sem.)',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.heading4),
        const SizedBox(height: 4),
        if (!hasData)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text('Sin movimientos en este período.',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textTertiary)),
            ),
          )
        else ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxVal,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      BarTooltipItem(
                    'Bs ${rod.toY.toStringAsFixed(0)}',
                    AppTextStyles.caption.copyWith(color: Colors.white),
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (v, m) {
                    final i = v.toInt();
                    if (i < 0 || i >= data.length) return const SizedBox();
                    return Text(data[i].month,
                        style: AppTextStyles.caption);
                  },
                )),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((e) {
                final isEmpty = e.value.amount == 0;
                return BarChartGroupData(x: e.key, barRods: [
                  BarChartRodData(
                    toY: isEmpty ? 0.5 : e.value.amount,
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                    gradient: isEmpty
                        ? LinearGradient(colors: [
                            AppColors.textTertiary.withValues(alpha: 0.3),
                            AppColors.textTertiary.withValues(alpha: 0.1),
                          ])
                        : AppColors.primaryGradient,
                  ),
                ]);
              }).toList(),
            )),
          ),
        ],
      ]),
    );
  }
}

class _EventTile extends StatelessWidget {
  final ActivityEvent event;
  const _EventTile({required this.event});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7)),
              child: Center(
                  child: Text('N${event.level}',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary, fontSize: 10)))),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(event.description, style: AppTextStyles.labelSmall),
                Text(
                    '${event.type.displayName} · ${event.origin.displayName}',
                    style: AppTextStyles.caption),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('+Bs ${event.incomeAssociated.toStringAsFixed(1)}',
                style: AppTextStyles.labelSmall
                    .copyWith(color: AppColors.success)),
            Text(event.isConfirmed ? 'Confirmado' : 'Estimado',
                style: AppTextStyles.caption.copyWith(fontSize: 10)),
          ]),
        ]));
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentRecord payment;
  const _PaymentTile({required this.payment});
  Color get _color {
    switch (payment.status) {
      case LiquidationStatus.pending:
        return AppColors.warning;
      case LiquidationStatus.processing:
        return AppColors.info;
      case LiquidationStatus.paid:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 0.5)),
        child: Row(children: [
          Icon(Icons.account_balance_wallet_rounded, color: _color, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Bs ${payment.amount.toStringAsFixed(2)}',
                    style: AppTextStyles.labelLarge),
                Text(payment.method, style: AppTextStyles.caption),
              ])),
          StatChip(label: payment.status.displayName, color: _color),
        ]));
  }
}
