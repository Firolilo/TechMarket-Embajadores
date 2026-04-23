import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

// Usuario: admin  |  Contraseña: admin123
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  late AnimationController _anim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    await auth.login(_userCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Center(child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: FadeTransition(opacity: _fadeAnim, child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Logo
              Container(width: 72, height: 72,
                decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 8))]),
                child: const Icon(Icons.rocket_launch_rounded, size: 36, color: AppColors.textOnPrimary)),
              const SizedBox(height: 24),
              ShaderMask(
                shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                child: Text('TechMarket', style: AppTextStyles.heading1.copyWith(fontSize: 30, color: Colors.white))),
              Text('EMBAJADORES', style: AppTextStyles.overline.copyWith(fontSize: 12, letterSpacing: 5, color: AppColors.textSecondary)),
              const SizedBox(height: 36),

              Form(key: _formKey, child: Column(children: [
                TextFormField(
                  controller: _userCtrl,
                  validator: (v) => Validators.required(v, 'El usuario'),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: AppDecorations.inputDecoration(label: 'Usuario', hint: 'admin', prefixIcon: Icons.person_outline)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passCtrl, obscureText: _obscure,
                  validator: (v) => Validators.required(v, 'La contraseña'),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: AppDecorations.inputDecoration(label: 'Contraseña', hint: '••••••••', prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textTertiary),
                      onPressed: () => setState(() => _obscure = !_obscure)))),
              ])),
              const SizedBox(height: 28),

              SizedBox(width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _login,
                  child: auth.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textOnPrimary))
                      : const Text('Ingresar'))),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/register'),
                child: RichText(text: TextSpan(style: AppTextStyles.bodySmall, children: [
                  const TextSpan(text: '¿No tienes cuenta? '),
                  TextSpan(text: 'Regístrate', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                ]))),
            ])),
          )),
        ),
      ),
    );
  }
}
