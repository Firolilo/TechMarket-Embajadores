import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Bottom navigation según spec: Inicio, Impacto, Oportunidades, Ingresos, Perfil.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Inicio'),
    _NavItem(icon: Icons.show_chart_outlined, activeIcon: Icons.show_chart_rounded, label: 'Impacto'),
    _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome_rounded, label: 'Oportunidades'),
    _NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded, label: 'Ingresos'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border, width: 0.5))),
      child: SafeArea(top: false,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == currentIndex;
              return Expanded(child: GestureDetector(
                onTap: () => onTap(i), behavior: HitTestBehavior.opaque,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 200),
                    width: active ? 44 : 32, height: active ? 30 : 26,
                    decoration: active ? BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)) : null,
                    child: Icon(active ? item.activeIcon : item.icon, color: active ? AppColors.primary : AppColors.textTertiary, size: active ? 20 : 18)),
                  const SizedBox(height: 3),
                  Text(item.label, style: AppTextStyles.caption.copyWith(fontSize: 10, color: active ? AppColors.primary : AppColors.textTertiary), maxLines: 1),
                ]),
              ));
            })))),
    );
  }
}

class _NavItem {
  final IconData icon, activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
