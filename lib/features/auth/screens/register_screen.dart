import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

/// PANTALLA 1 – Registro Básico del Embajador.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes aceptar los términos y condiciones')));
      return;
    }

    final auth = context.read<AuthProvider>();
    await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;

    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error!)));
    } else {
      // Si no tiene ref_id, ir a P2 (identificación invitación)
      // Si tiene ref_id, saltar a P3 (tipo de participación)
      if (auth.refId == null) {
        context.go('/register/invitation');
      } else {
        context.go('/register/participation');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 32),
              // Logo
              Center(child: Container(
                width: 64, height: 64,
                decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.rocket_launch_rounded, size: 32, color: AppColors.textOnPrimary),
              )),
              const SizedBox(height: 20),
              Center(child: Text('Crear cuenta de embajador', style: AppTextStyles.heading3)),
              const SizedBox(height: 8),
              Center(child: Text('Ingresa tus datos para comenzar', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center)),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nameCtrl,
                    validator: (v) => Validators.required(v, 'El nombre'),
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: AppDecorations.inputDecoration(label: 'Nombre completo', hint: 'Tu nombre completo', prefixIcon: Icons.person_outline),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: AppDecorations.inputDecoration(label: 'Correo electrónico', hint: 'tu@email.com', prefixIcon: Icons.email_outlined),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: AppDecorations.inputDecoration(label: 'Teléfono', hint: '+591 7XXXXXXXX', prefixIcon: Icons.phone_outlined),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    validator: Validators.password,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: AppDecorations.inputDecoration(label: 'Contraseña', hint: 'Mínimo 8 caracteres', prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textTertiary), onPressed: () => setState(() => _obscure = !_obscure))),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscure,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                      if (v != _passCtrl.text) return 'Las contraseñas no coinciden';
                      return null;
                    },
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: AppDecorations.inputDecoration(label: 'Confirmar contraseña', hint: 'Repite tu contraseña', prefixIcon: Icons.lock_outline),
                  ),
                ]),
              ),
              const SizedBox(height: 20),

              // Términos
              Row(children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                  activeColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.textTertiary),
                ),
                Expanded(child: GestureDetector(
                  onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                  child: Text('Acepto los términos y condiciones', style: AppTextStyles.bodySmall),
                )),
              ]),
              const SizedBox(height: 24),

              // Botón
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _submit,
                  child: auth.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textOnPrimary))
                      : const Text('Crear cuenta de embajador'),
                ),
              ),
              const SizedBox(height: 16),

              // Ir a login
              Center(child: TextButton(
                onPressed: () => context.go('/login'),
                child: RichText(text: TextSpan(style: AppTextStyles.bodySmall, children: [
                  const TextSpan(text: '¿Ya tienes cuenta? '),
                  TextSpan(text: 'Inicia sesión', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                ])),
              )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
