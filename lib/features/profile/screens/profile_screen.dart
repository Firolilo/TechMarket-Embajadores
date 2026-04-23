import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../auth/models/ambassador_user.dart';
import '../../auth/providers/auth_provider.dart';

/// PANTALLA 13 – Perfil y Configuración.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
          const SizedBox(height: 16),
          Text('Perfil y configuración', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text('Gestiona tu información y preferencias', style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),

          // Avatar + info
          Center(child: Column(children: [
            Container(width: 80, height: 80,
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16)]),
              child: Center(child: Text(user.name.split(' ').map((n) => n[0]).take(2).join(),
                style: AppTextStyles.heading3.copyWith(color: AppColors.textOnPrimary)))),
            const SizedBox(height: 12),
            Text(user.name, style: AppTextStyles.heading4),
            Text(user.email, style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Text('Cuenta verificada ✓', style: AppTextStyles.caption.copyWith(color: AppColors.success))),
          ])),
          const SizedBox(height: 24),

          // Datos personales
          _Section(title: 'Información personal', children: [
            _InfoRow(label: 'Teléfono', value: user.phone),
            _InfoRow(label: 'Documento', value: '${user.documentType ?? ''} ${user.documentNumber ?? 'No configurado'}'),
            _InfoRow(label: 'Ciudad', value: '${user.city}, ${user.country}'),
          ]),

          // Método de pago
          _Section(title: 'Método de pago', children: [
            if (user.paymentMethod != null) ...[
              _InfoRow(label: 'Método', value: user.paymentMethod!.type.displayName),
              _InfoRow(label: 'Estado', value: 'Configurado ✓'),
            ] else
              _InfoRow(label: 'Estado', value: 'No configurado'),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {},
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
              child: const Text('Editar método de pago'))),
          ]),

          // Notificaciones
          _Section(title: 'Notificaciones', children: [
            _ToggleRow(label: 'Resúmenes semanales', value: true),
            _ToggleRow(label: 'Alertas de pago', value: true),
            _ToggleRow(label: 'Oportunidades (IA)', value: false),
            _ToggleRow(label: 'Comunicaciones del programa', value: true),
          ]),

          // Seguridad
          _Section(title: 'Seguridad', children: [
            _ActionRow(icon: Icons.lock_outline, label: 'Cambiar contraseña', onTap: () {}),
            _ActionRow(icon: Icons.devices, label: 'Cerrar sesiones activas', onTap: () {}),
          ]),

          // Más opciones (drawer items)
          _Section(title: 'Más opciones', children: [
            _ActionRow(icon: Icons.school_outlined, label: 'Educación y buenas prácticas', onTap: () => context.go('/education')),
            _ActionRow(icon: Icons.help_outline, label: 'Centro de ayuda', onTap: () => context.go('/help')),
            _ActionRow(icon: Icons.gavel_outlined, label: 'Avisos legales', onTap: () => context.go('/legal')),
            _ActionRow(icon: Icons.history, label: 'Historial y reportes', onTap: () => context.go('/history')),
          ]),

          const SizedBox(height: 16),
          _ActionRow(icon: Icons.logout_rounded, label: 'Cerrar sesión', color: AppColors.error, onTap: () {
            auth.logout();
            context.go('/login');
          }),
          const SizedBox(height: 32),
        ])),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTextStyles.heading4),
      const SizedBox(height: 10),
      Container(padding: const EdgeInsets.all(14), decoration: AppDecorations.cardFlat(),
        child: Column(children: children)),
      const SizedBox(height: 20),
    ]);
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Text(label, style: AppTextStyles.bodySmall),
        const Spacer(),
        Text(value, style: AppTextStyles.labelSmall),
      ]));
  }
}

class _ToggleRow extends StatefulWidget {
  final String label;
  final bool value;
  const _ToggleRow({required this.label, required this.value});
  @override
  State<_ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<_ToggleRow> {
  late bool _val;
  @override
  void initState() { super.initState(); _val = widget.value; }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(widget.label, style: AppTextStyles.bodySmall)),
        Switch(value: _val, onChanged: (v) => setState(() => _val = v),
          activeTrackColor: AppColors.primary),
      ]));
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon; final String label; final Color? color; final VoidCallback onTap;
  const _ActionRow({required this.icon, required this.label, this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return InkWell(onTap: onTap,
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(icon, color: c, size: 20), const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: c))),
          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
        ])));
  }
}
