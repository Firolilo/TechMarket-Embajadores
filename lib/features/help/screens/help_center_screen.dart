import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../data/mock/mock_data.dart';

/// PANTALLA 14 – Centro de Ayuda / Soporte.
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});
  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final faqs = MockData.faqs;
    final filtered = _search.isEmpty ? faqs : faqs.where((f) =>
      f.question.toLowerCase().contains(_search.toLowerCase()) ||
      f.answer.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
          const SizedBox(height: 16),
          Text('Centro de ayuda', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text('Encuentra respuestas o contáctanos', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),

          // Buscador
          TextField(
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: AppDecorations.inputDecoration(
              label: 'Buscar', hint: 'Buscar por tema, pago, invitaciones...',
              prefixIcon: Icons.search),
            onChanged: (v) => setState(() => _search = v),
          ),
          const SizedBox(height: 24),

          // FAQs
          Text('Preguntas frecuentes', style: AppTextStyles.heading4),
          const SizedBox(height: 4),
          Text('La mayoría de dudas se resuelven revisando las FAQs.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 12),

          ...filtered.map((faq) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: AppDecorations.cardFlat(),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                title: Text(faq.question, style: AppTextStyles.labelMedium),
                iconColor: AppColors.primary,
                collapsedIconColor: AppColors.textTertiary,
                children: [
                  Text(faq.answer, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 6),
                  Align(alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                      child: Text(faq.category, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                    )),
                ],
              ),
            ),
          )),
          const SizedBox(height: 24),

          // Contactar soporte
          Text('¿Necesitas más ayuda?', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.support_agent, size: 20),
            label: const Text('Crear ticket de soporte'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14)),
          )),
          const SizedBox(height: 8),
          Text('Los tiempos de respuesta dependen del tipo de solicitud.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 32),
        ])),
      ),
    );
  }
}
