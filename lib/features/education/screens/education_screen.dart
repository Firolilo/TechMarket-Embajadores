import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../data/mock/mock_data.dart';
import '../../support/models/support_models.dart';

/// PANTALLA 11 – Educación y Buenas Prácticas.
class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final content = MockData.educationContent;
    final categories = content.map((c) => c.category).toSet().toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
          const SizedBox(height: 16),
          Text('Educación y buenas prácticas', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text('Guías oficiales para operar correctamente', style: AppTextStyles.bodySmall),
          const SizedBox(height: 8),
          Text('Este contenido es informativo y no garantiza ingresos.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 24),

          // Categorías
          Wrap(spacing: 8, runSpacing: 8, children: categories.map((cat) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
            child: Text(cat, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
          )).toList()),
          const SizedBox(height: 20),

          // Lista de contenidos
          ...content.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
            decoration: AppDecorations.cardFlat(),
            child: Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(_typeIcon(item.type), color: AppColors.primary, size: 20)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, style: AppTextStyles.labelMedium),
                const SizedBox(height: 2),
                Row(children: [
                  Text(_typeLabel(item.type), style: AppTextStyles.caption),
                  const SizedBox(width: 8),
                  Text(item.duration, style: AppTextStyles.caption),
                ]),
              ])),
              if (item.viewed)
                const Icon(Icons.check_circle, color: AppColors.success, size: 18)
              else
                const Icon(Icons.circle_outlined, color: AppColors.textTertiary, size: 18),
            ]),
          )),
          const SizedBox(height: 12),
          Text('Las buenas prácticas ayudan a mejorar el ecosistema.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 32),
        ])),
      ),
    );
  }

  IconData _typeIcon(ContentType type) {
    switch (type) {
      case ContentType.articulo: return Icons.article_outlined;
      case ContentType.video: return Icons.play_circle_outline;
      case ContentType.guia: return Icons.menu_book_outlined;
    }
  }

  String _typeLabel(ContentType type) {
    switch (type) {
      case ContentType.articulo: return 'Artículo';
      case ContentType.video: return 'Video';
      case ContentType.guia: return 'Guía';
    }
  }
}
