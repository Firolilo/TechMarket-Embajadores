import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../data/mock/mock_data.dart';
import '../../support/models/support_models.dart';

/// PANTALLA 15 – Avisos Legales y Cambios del Programa.
class LegalNoticesScreen extends StatelessWidget {
  const LegalNoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = MockData.legalNotices;
    final pending = notices.where((n) => n.status == NoticeStatus.nuevo).toList();
    final accepted = notices.where((n) => n.status == NoticeStatus.aceptado).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
          const SizedBox(height: 16),
          Text('Avisos legales', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text('Comunicaciones oficiales y actualizaciones', style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),

          // Estado de cumplimiento
          Container(padding: const EdgeInsets.all(14), decoration: AppDecorations.cardFlat(),
            child: Row(children: [
              Icon(pending.isEmpty ? Icons.check_circle : Icons.warning_amber_rounded,
                color: pending.isEmpty ? AppColors.success : AppColors.warning, size: 22),
              const SizedBox(width: 12),
              Expanded(child: Text(
                pending.isEmpty ? 'Todos los avisos aceptados' : '${pending.length} aviso(s) pendiente(s) de aceptación',
                style: AppTextStyles.labelMedium.copyWith(
                  color: pending.isEmpty ? AppColors.success : AppColors.warning))),
            ])),
          const SizedBox(height: 20),

          // Avisos pendientes
          if (pending.isNotEmpty) ...[
            Text('Pendientes de aceptación', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            ...pending.map((n) => _NoticeCard(notice: n, isPending: true)),
            const SizedBox(height: 20),
          ],

          // Avisos aceptados
          if (accepted.isNotEmpty) ...[
            Text('Avisos aceptados', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            ...accepted.map((n) => _NoticeCard(notice: n, isPending: false)),
          ],

          const SizedBox(height: 12),
          Text('Debes aceptar los avisos pendientes para continuar operando.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 32),
        ])),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final LegalNotice notice;
  final bool isPending;
  const _NoticeCard({required this.notice, required this.isPending});

  Color get _typeColor {
    switch (notice.type) {
      case NoticeType.legal: return AppColors.info;
      case NoticeType.operativo: return AppColors.warning;
      case NoticeType.economico: return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
      decoration: isPending
          ? BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)))
          : AppDecorations.cardFlat(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(notice.title, style: AppTextStyles.labelMedium)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: _typeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
            child: Text(notice.type.name.substring(0, 1).toUpperCase() + notice.type.name.substring(1),
              style: AppTextStyles.caption.copyWith(color: _typeColor)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(notice.body, style: AppTextStyles.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Row(children: [
          Text('Vigencia: ${notice.effectiveDate.day}/${notice.effectiveDate.month}/${notice.effectiveDate.year}',
            style: AppTextStyles.caption),
          const Spacer(),
          Text('v${notice.version}', style: AppTextStyles.caption),
        ]),
        if (isPending && notice.requiresAcceptance) ...[
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {},
            child: const Text('Aceptar cambios'),
          )),
        ],
        if (!isPending && notice.acceptedAt != null)
          Padding(padding: const EdgeInsets.only(top: 6),
            child: Text('Aceptado: ${notice.acceptedAt!.day}/${notice.acceptedAt!.month}/${notice.acceptedAt!.year}',
              style: AppTextStyles.caption.copyWith(color: AppColors.success))),
      ]),
    );
  }
}
