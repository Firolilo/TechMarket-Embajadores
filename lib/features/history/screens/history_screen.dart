import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../data/mock/mock_data.dart';

/// PANTALLA 10 – Historial y Reportes.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final periods = MockData.historicalPeriods;

    double totalGenerated = 0;
    double totalPaid = 0;
    double totalPending = 0;
    for (final p in periods) {
      totalGenerated += p.ambassadorIncome;
      if (p.status.name == 'paid') {
        totalPaid += p.ambassadorIncome;
      } else {
        totalPending += p.ambassadorIncome;
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
          const SizedBox(height: 16),
          Text('Historial y reportes', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text('Auditoría personal de periodos y pagos', style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),

          // Resumen
          Row(children: [
            Expanded(child: _SummaryCard(label: 'Total generado', value: 'Bs ${totalGenerated.toStringAsFixed(0)}')),
            const SizedBox(width: 10),
            Expanded(child: _SummaryCard(label: 'Total pagado', value: 'Bs ${totalPaid.toStringAsFixed(0)}', color: AppColors.success)),
            const SizedBox(width: 10),
            Expanded(child: _SummaryCard(label: 'Pendiente', value: 'Bs ${totalPending.toStringAsFixed(0)}', color: AppColors.warning)),
          ]),
          const SizedBox(height: 24),

          // Periodos
          Text('Periodos', style: AppTextStyles.heading4),
          const SizedBox(height: 4),
          Text('Los reportes reflejan datos cerrados y auditados.', style: AppTextStyles.caption),
          const SizedBox(height: 12),
          ...periods.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: AppDecorations.cardFlat(),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.period, style: AppTextStyles.labelMedium),
                Text('Impacto: Bs ${p.economicImpact.toStringAsFixed(0)}', style: AppTextStyles.caption),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Bs ${p.ambassadorIncome.toStringAsFixed(0)}', style: AppTextStyles.labelMedium.copyWith(
                  color: p.status.name == 'paid' ? AppColors.success : AppColors.warning)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (p.status.name == 'paid' ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6)),
                  child: Text(p.status.name == 'paid' ? 'Pagado' : 'Pendiente',
                    style: AppTextStyles.caption.copyWith(color: p.status.name == 'paid' ? AppColors.success : AppColors.warning)),
                ),
              ]),
            ]),
          )),
          const SizedBox(height: 20),

          // Descargas
          Text('Descargar reportes', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: const Text('PDF mensual'),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
            )),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.table_chart_outlined, size: 18),
              label: const Text('Excel anual'),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
            )),
          ]),
          const SizedBox(height: 12),
          Text('Los periodos pagados no pueden modificarse.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 32),
        ])),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _SummaryCard({required this.label, required this.value, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10), decoration: AppDecorations.cardFlat(),
      child: Column(children: [
        Text(value, style: AppTextStyles.heading4.copyWith(color: color ?? AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
      ]));
  }
}
