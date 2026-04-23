import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../providers/auth_provider.dart';

/// PANTALLA 2 – Identificación de Invitación.
/// Visible SOLO si no hay ref_id (registro orgánico).
class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});
  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final _codeCtrl = TextEditingController();
  String? _inviterName;
  bool _codeVerified = false;

  @override
  void dispose() { _codeCtrl.dispose(); super.dispose(); }

  Future<void> _verifyCode() async {
    if (_codeCtrl.text.trim().isEmpty) return;
    final auth = context.read<AuthProvider>();
    final valid = await auth.verifyInvitationCode(_codeCtrl.text.trim());
    setState(() {
      _codeVerified = valid;
      _inviterName = auth.inviterName;
    });
  }

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
              Text('¿Alguien te recomendó la plataforma?', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              Text('Si alguien te recomendó, puedes ingresar su código para que reciba el reconocimiento correspondiente.', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 32),

              TextFormField(
                controller: _codeCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: AppDecorations.inputDecoration(
                  label: 'Código de invitación (opcional)',
                  hint: 'Ej: TM-12345',
                  prefixIcon: Icons.card_giftcard_outlined,
                ),
                onChanged: (_) {
                  if (_codeVerified) setState(() { _codeVerified = false; _inviterName = null; });
                },
              ),
              const SizedBox(height: 12),

              if (_codeCtrl.text.isNotEmpty && !_codeVerified)
                SizedBox(
                  width: double.infinity, height: 44,
                  child: OutlinedButton(
                    onPressed: auth.isLoading ? null : _verifyCode,
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
                    child: auth.isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                        : const Text('Verificar código'),
                  ),
                ),

              if (_codeVerified && _inviterName != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppDecorations.statCard(glowColor: AppColors.success),
                  child: Row(children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Invitador verificado', style: AppTextStyles.labelMedium.copyWith(color: AppColors.success)),
                      Text(_inviterName!, style: AppTextStyles.bodyMedium),
                    ])),
                  ]),
                ),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/register/participation'),
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
