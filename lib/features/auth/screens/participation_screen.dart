import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/ambassador_user.dart';
import '../providers/auth_provider.dart';

/// PANTALLA 3 – Tipo de Participación (radio cards).
class ParticipationScreen extends StatelessWidget {
  const ParticipationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 32),
              Text('¿En qué área te gustaría participar?', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text('Puedes cambiar estas preferencias más adelante.', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 32),

              _RadioCard(
                icon: Icons.computer_rounded, title: 'Hardware y equipos',
                subtitle: 'Recomienda laptops, monitores, periféricos y más',
                isSelected: auth.participationType == ParticipationType.restaurantes,
                onTap: () => auth.setParticipationType(ParticipationType.restaurantes),
              ),
              const SizedBox(height: 12),
              _RadioCard(
                icon: Icons.code_rounded, title: 'Software y licencias',
                subtitle: 'Recomienda software empresarial y suscripciones',
                isSelected: auth.participationType == ParticipationType.conductores,
                onTap: () => auth.setParticipationType(ParticipationType.conductores),
              ),
              const SizedBox(height: 12),
              _RadioCard(
                icon: Icons.apps_rounded, title: 'Todo el catálogo',
                subtitle: 'Hardware, software y servicios técnicos',
                isSelected: auth.participationType == ParticipationType.ambos,
                onTap: () => auth.setParticipationType(ParticipationType.ambos),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: auth.participationType != null ? () => context.go('/register/confirmation') : null,
                  child: const Text('Continuar'),
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ),
    );
  }
}

class _RadioCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  const _RadioCard({required this.icon, required this.title, required this.subtitle, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 32),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.labelLarge),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySmall),
          ])),
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.textTertiary, width: 2),
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
            child: isSelected ? const Icon(Icons.check, size: 14, color: AppColors.textOnPrimary) : null,
          ),
        ]),
      ),
    );
  }
}
