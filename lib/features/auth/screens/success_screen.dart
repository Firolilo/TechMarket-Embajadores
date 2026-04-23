import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// PANTALLA 6 – Registro Completado.
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.check_rounded, size: 52, color: AppColors.textOnPrimary),
              ),
              const SizedBox(height: 32),
              Text('Tu cuenta de embajador ha sido creada con éxito.', style: AppTextStyles.heading3, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text('Desde tu panel podrás ver el impacto de tus recomendaciones y tus ingresos en tiempo real.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 48),
              SizedBox(width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/dashboard'),
                  child: const Text('Ir a mi backoffice'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
