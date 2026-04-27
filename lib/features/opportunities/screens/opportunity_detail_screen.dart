import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/opportunity.dart';
import '../providers/opportunity_provider.dart';

/// Pantalla de detalle de una oportunidad.
/// Se abre como modal/bottom sheet.
class OpportunityDetailScreen extends StatefulWidget {
  final String opportunityId;

  const OpportunityDetailScreen({
    super.key,
    required this.opportunityId,
  });

  @override
  State<OpportunityDetailScreen> createState() => _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends State<OpportunityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OpportunityProvider>();
    final opportunity = provider.getOpportunityById(widget.opportunityId);

    if (opportunity == null) {
      return const Scaffold(
        body: Center(child: Text('Oportunidad no encontrada')),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header con botón cerrar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Text(
                        opportunity.zone,
                        style: AppTextStyles.heading3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              // Contenido desplazable
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Tipo y potencial
                    Row(
                      children: [
                        Icon(
                          opportunity.type.icon,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opportunity.type.displayName,
                                style: AppTextStyles.labelLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                opportunity.status.displayName,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatChip(
                          label: opportunity.potential.displayName,
                          color: _getPotentialColor(opportunity.potential),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Descripción
                    Text(
                      'Descripción',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.card(),
                      child: Text(
                        opportunity.description,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Fuente de datos
                    Text(
                      'Fuente de información',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.card(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            opportunity.dataSource,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Información adicional (zona)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Zona geográfica',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            opportunity.zone,
                            style: AppTextStyles.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              // Botones de acción (fijos en bottom)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón: Seguir/En seguimiento
                      if (opportunity.status != OpportunityStatus.atendida)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: opportunity.status ==
                                      OpportunityStatus.enSeguimiento
                                  ? null
                                  : () async {
                                      await provider
                                          .markAsFollowing(opportunity.id);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'En seguimiento',
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: opportunity.status ==
                                          OpportunityStatus.enSeguimiento
                                      ? AppColors.textTertiary
                                      : AppColors.primary,
                                ),
                                disabledForegroundColor:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    color: opportunity.status ==
                                            OpportunityStatus.enSeguimiento
                                        ? AppColors.textTertiary
                                        : AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    opportunity.status ==
                                            OpportunityStatus.enSeguimiento
                                        ? 'En seguimiento'
                                        : 'Seguir',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: opportunity.status ==
                                              OpportunityStatus.enSeguimiento
                                          ? AppColors.textTertiary
                                          : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // Botón: Marcar como atendida
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: opportunity.status ==
                                    OpportunityStatus.atendida
                                ? null
                                : () async {
                                    await provider
                                        .markAsAttended(opportunity.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Marcada como atendida'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: AppColors.textTertiary
                                  .withValues(alpha: 0.3),
                            ),
                            child: Text(
                              opportunity.status == OpportunityStatus.atendida
                                  ? 'Ya está atendida'
                                  : 'Marcar como atendida',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Botón: Guardar/Quitar de guardadas
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () async {
                            await provider.toggleSaved(opportunity.id);
                            if (context.mounted) {
                              final isSaved = provider
                                      .getOpportunityById(opportunity.id)
                                      ?.isSaved ??
                                  false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isSaved
                                        ? 'Guardada en tus favoritos'
                                        : 'Removida de favoritos',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                opportunity.isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                opportunity.isSaved
                                    ? 'Guardada'
                                    : 'Guardar para después',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPotentialColor(OpportunityPotential potential) {
    switch (potential) {
      case OpportunityPotential.alto:
        return AppColors.success;
      case OpportunityPotential.medio:
        return AppColors.warning;
      case OpportunityPotential.bajo:
        return AppColors.textTertiary;
    }
  }
}
