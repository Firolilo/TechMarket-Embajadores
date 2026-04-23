import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// PANTALLA 5 – Datos de Pago (opcional).
class PaymentSetupScreen extends StatefulWidget {
  const PaymentSetupScreen({super.key});
  @override
  State<PaymentSetupScreen> createState() => _PaymentSetupScreenState();
}

class _PaymentSetupScreenState extends State<PaymentSetupScreen> {
  int _selectedMethod = -1; // 0=transferencia, 1=billetera, 2=otro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 32),
              Text('Método de pago', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text('Los pagos se realizan semanalmente. Puedes modificar estos datos en cualquier momento.', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 24),
              _MethodCard(icon: Icons.account_balance, label: 'Transferencia bancaria', selected: _selectedMethod == 0, onTap: () => setState(() => _selectedMethod = 0)),
              const SizedBox(height: 10),
              _MethodCard(icon: Icons.account_balance_wallet, label: 'Billetera digital', selected: _selectedMethod == 1, onTap: () => setState(() => _selectedMethod = 1)),
              const SizedBox(height: 10),
              _MethodCard(icon: Icons.more_horiz, label: 'Otro método', selected: _selectedMethod == 2, onTap: () => setState(() => _selectedMethod = 2)),
              const Spacer(),
              SizedBox(width: double.infinity, height: 52,
                child: ElevatedButton(onPressed: () => context.go('/register/success'), child: const Text('Guardar y continuar'))),
              const SizedBox(height: 8),
              Center(child: TextButton(
                onPressed: () => context.go('/register/success'),
                child: Text('Configurar más tarde', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              )),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MethodCard({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Row(children: [
          Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 28),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: AppTextStyles.labelLarge.copyWith(color: selected ? AppColors.primary : AppColors.textPrimary))),
          if (selected) const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
        ]),
      ),
    );
  }
}
