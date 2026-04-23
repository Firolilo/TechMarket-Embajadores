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
  String _selectedPeriod = 'Semana';
  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<EarningsProvider>().loadEarnings());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EarningsProvider>();
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final weekStart = startOfToday.subtract(const Duration(days: 6));
    final monthStart = DateTime(now.year, now.month, 1);

    DateTime startDate;
    DateTime endDate;
    if (_selectedPeriod == 'Rango' && _customRange != null) {
      startDate = DateTime(_customRange!.start.year, _customRange!.start.month, _customRange!.start.day);
      endDate = DateTime(_customRange!.end.year, _customRange!.end.month, _customRange!.end.day, 23, 59, 59);
    } else if (_selectedPeriod == 'Mes') {
      startDate = monthStart;
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    } else {
      startDate = weekStart;
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    }

    final filteredEvents = prov.events
        .where((e) => !e.date.isBefore(startDate) && !e.date.isAfter(endDate))
        .toList();
    final filteredPayments = prov.payments
        .where((p) => !p.requestedAt.isBefore(startDate) && !p.requestedAt.isAfter(endDate))
        .toList();
    final periodIncome = filteredEvents.fold<double>(0, (sum, e) => sum + e.incomeAssociated);
    final periodPending = filteredPayments
        .where((p) => p.status != LiquidationStatus.paid)
        .fold<double>(0, (sum, p) => sum + p.amount);

    final periodLabel = _selectedPeriod == 'Mes'
        ? 'del mes'
        : _selectedPeriod == 'Rango'
            ? 'del rango'
            : 'de la semana';

    final periodMessage = _selectedPeriod == 'Mes'
        ? 'Vista mensual: se muestran acumulados del mes en curso.'
        : _selectedPeriod == 'Rango'
            ? 'Vista por rango: se muestran solo movimientos entre las fechas seleccionadas.'
            : 'Vista semanal: los ingresos estimados se confirman en el cierre semanal.';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: prov.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
                  const SizedBox(height: 16),
                  // Header con selector de periodo
                  Row(children: [
                    Expanded(child: Text('Ingresos y actividad', style: AppTextStyles.heading2)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                        value: _selectedPeriod, isDense: true,
                        dropdownColor: AppColors.surface,
                        style: AppTextStyles.labelSmall,
                        items: ['Semana', 'Mes', 'Rango'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                        onChanged: (v) => setState(() => _selectedPeriod = v!),
                      )),
                    ),
                  ]),
                  if (_selectedPeriod == 'Rango') ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(now.year + 1),
                          initialDateRange: _customRange ??
                              DateTimeRange(
                                start: startOfToday.subtract(const Duration(days: 6)),
                                end: startOfToday,
                              ),
                        );
                        if (picked != null) {
                          setState(() => _customRange = picked);
                        }
                      },
                      icon: const Icon(Icons.date_range_rounded, size: 18),
                      label: Text(
                        _customRange == null
                            ? 'Seleccionar rango de fechas'
                            : '${_fmtDate(_customRange!.start)} - ${_fmtDate(_customRange!.end)}',
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Resumen financiero (3 cards)
                  Row(children: [
                    Expanded(child: _SummaryCard(label: 'Ingresos $periodLabel', value: 'Bs ${periodIncome.toStringAsFixed(0)}', badge: 'Estimado', color: AppColors.primary)),
                    const SizedBox(width: 10),
                    Expanded(child: _SummaryCard(label: 'Impacto $periodLabel', value: 'Bs ${(periodIncome * 20).toStringAsFixed(0)}', badge: 'Bs', color: AppColors.info)),
                  ]),
                  const SizedBox(height: 10),
                  _SummaryCard(label: 'Estado de liquidación', value: 'Bs ${periodPending.toStringAsFixed(0)} pendiente', badge: periodPending > 0 ? 'Pendiente' : 'Pagado', color: periodPending > 0 ? AppColors.warning : AppColors.success),
                  const SizedBox(height: 20),

                  // Desglose por nivel (agregado)
                  Text('Desglose por nivel (agregado)', style: AppTextStyles.heading4),
                  const SizedBox(height: 4),
                  Text('No se muestran personas, solo cifras agregadas.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 12),
                  _LevelBreakdownRow(level: 1, impact: 18200, percent: 5.0, income: 910),
                  _LevelBreakdownRow(level: 2, impact: 12800, percent: 3.0, income: 384),
                  _LevelBreakdownRow(level: 3, impact: 7450, percent: 2.0, income: 149),
                  const SizedBox(height: 20),

                  // Gráfico mensual
                  if (_selectedPeriod != 'Semana' && prov.monthlyEarnings.isNotEmpty) _MonthlyChart(data: prov.monthlyEarnings),
                  const SizedBox(height: 20),

                  // Actividad detallada (eventos)
                  Text('Actividad detallada (eventos)', style: AppTextStyles.heading4),
                  const SizedBox(height: 12),
                  if (filteredEvents.isEmpty)
                    Container(padding: const EdgeInsets.all(20), decoration: AppDecorations.cardFlat(),
                      child: Center(child: Text('Aún no se registran movimientos en este periodo.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))))
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
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    )
                  else
                    ...filteredPayments.map((p) => _PaymentTile(payment: p)),
                  const SizedBox(height: 20),

                  // Mensajes contextuales
                  Container(padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      const Icon(Icons.info_outline, color: AppColors.info, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(periodMessage, style: AppTextStyles.caption.copyWith(color: AppColors.info))),
                    ])),
                  const SizedBox(height: 16),

                  // Botones: Descargar reporte / Ver reglas de cálculo
                  Row(children: [
                    Expanded(child: OutlinedButton.icon(
                      onPressed: () => _downloadReportPdf(),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Descargar reporte'),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary), padding: const EdgeInsets.symmetric(vertical: 12)),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: OutlinedButton.icon(
                      onPressed: () => _showMockRules(),
                      icon: const Icon(Icons.rule_rounded, size: 18),
                      label: const Text('Ver reglas'),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 12)),
                    )),
                  ]),
                  const SizedBox(height: 24),
                ]),
        ),
      ),
    );
  }

  String _fmtDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _downloadReportPdf() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando PDF...')),
    );

    try {
      if (kIsWeb) {
        throw UnsupportedError('La descarga local de archivos no está habilitada en Web.');
      }

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            // PDF mock mínimo (válido) para pruebas de descarga.
            return pw.Center(
              child: pw.Text('Reporte de ingresos ($_selectedPeriod)'),
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/reporte_ingresos_${_selectedPeriod.toLowerCase()}_$timestamp.pdf');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await file.writeAsBytes(bytes, flush: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF descargado: ${file.path}'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      debugPrint('Error al generar PDF: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo generar el PDF: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showMockRules() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reglas de cálculo (mock)', style: AppTextStyles.heading4),
                const SizedBox(height: 10),
                Text('• Nivel 1: 5% del impacto confirmado.', style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                Text('• Nivel 2: 3% del impacto confirmado.', style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                Text('• Nivel 3: 2% del impacto confirmado.', style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                Text('• Los estimados pasan a confirmados en el cierre semanal.', style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                Text('• Los pagos se liquidan según estado: pendiente, en proceso o pagado.', style: AppTextStyles.bodySmall),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Entendido'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

class _LevelBreakdownRow extends StatelessWidget {
  final int level;
  final double impact, percent, income;
  const _LevelBreakdownRow({required this.level, required this.impact, required this.percent, required this.income});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(12),
      decoration: AppDecorations.cardFlat(),
      child: Row(children: [
        Container(width: 28, height: 28,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(7)),
          child: Center(child: Text('N$level', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontSize: 10)))),
        const SizedBox(width: 10),
        Expanded(child: Text('Bs ${impact.toStringAsFixed(0)}', style: AppTextStyles.labelSmall)),
        Text('${percent.toStringAsFixed(0)}%', style: AppTextStyles.caption),
        const SizedBox(width: 12),
        Text('Bs ${income.toStringAsFixed(0)}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success)),
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
