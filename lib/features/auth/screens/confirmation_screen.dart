import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../providers/auth_provider.dart';

/// PANTALLA 4 – Confirmación de Atribución.
class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final hasInviter = auth.hasInviter;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 32),
              Text('Confirma tu registro', style: AppTextStyles.heading3),
              const SizedBox(height: 24),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: AppDecorations.card(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(hasInviter ? Icons.person_pin_rounded : Icons.business_rounded, color: AppColors.primary, size: 36),
                  const SizedBox(height: 12),
                  Text(hasInviter
                      ? 'Estás siendo registrado como embajador recomendado por:'
                      : 'Te estás registrando como embajador independiente dentro de la red de la empresa.',
                    style: AppTextStyles.bodyLarge),
                  if (hasInviter && auth.inviterName != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text(auth.inviterName!, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, color: AppColors.warning, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text('La atribución de recomendación no puede modificarse una vez completado el registro.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning))),
                ]),
              ),
              const Spacer(),
              SizedBox(width: double.infinity, height: 52,
                child: ElevatedButton(onPressed: () => context.go('/register/payment'), child: const Text('Confirmar y continuar'))),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ),
    );
  }
}
