import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../auth/providers/auth_provider.dart';

/// PANTALLA 12 – Invitar / Recomendar.
class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
            const SizedBox(height: 16),
            Text('Invitar / Recomendar', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('Comparte tu enlace o código para registrar recomendaciones', style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),

            // Enlace personal
            Container(padding: const EdgeInsets.all(18), decoration: AppDecorations.statCard(glowColor: AppColors.primary),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Tu enlace personal', style: AppTextStyles.labelMedium),
                const SizedBox(height: 10),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.link, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(user.inviteUrl, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                  ])),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Enlace copiado!'))),
                  icon: const Icon(Icons.copy, size: 18), label: const Text('Copiar enlace'))),
                const SizedBox(height: 6),
                Text('Este enlace registra automáticamente tus recomendaciones.', style: AppTextStyles.caption),
              ])),
            const SizedBox(height: 16),

            // QR
            Container(padding: const EdgeInsets.all(18), decoration: AppDecorations.card(),
              child: Column(children: [
                Text('Código QR de invitación', style: AppTextStyles.labelMedium),
                const SizedBox(height: 16),
                Container(width: 160, height: 160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Icon(Icons.qr_code_2_rounded, size: 120, color: Colors.black87))),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Descargar'),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border))),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.share, size: 16), label: const Text('Compartir'),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary))),
                ]),
              ])),
            const SizedBox(height: 16),

            // Código de respaldo
            Container(padding: const EdgeInsets.all(16), decoration: AppDecorations.cardFlat(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Código de respaldo (manual)', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(user.ambassadorCode, style: AppTextStyles.heading3.copyWith(color: AppColors.primary, letterSpacing: 3)))),
                const SizedBox(height: 8),
                Text('Este código solo debe usarse si el registro no se hace desde tu enlace o QR.', style: AppTextStyles.caption),
              ])),
            const SizedBox(height: 16),

            // Atribución
            Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(Icons.info_outline, color: AppColors.info, size: 18), const SizedBox(width: 8),
                  Text('Sobre la atribución', style: AppTextStyles.labelSmall.copyWith(color: AppColors.info))]),
                const SizedBox(height: 6),
                Text('Las recomendaciones se atribuyen automáticamente cuando se usa tu enlace o QR. La atribución no puede modificarse luego del registro.', style: AppTextStyles.caption),
              ])),
            const SizedBox(height: 16),

            // Buenas prácticas
            Text('Buenas prácticas', style: AppTextStyles.heading4),
            const SizedBox(height: 8),
            _Practice(icon: Icons.check, text: 'Usar siempre el enlace o QR'),
            _Practice(icon: Icons.check, text: 'Evitar compartir solo el código manual'),
            _Practice(icon: Icons.check, text: 'Asegurarse que el registro se complete'),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}

class _Practice extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Practice({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Icon(icon, color: AppColors.success, size: 16), const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
      ]));
  }
}
