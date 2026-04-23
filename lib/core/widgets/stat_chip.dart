import 'package:flutter/material.dart';
import '../theme/app_decorations.dart';
import '../theme/app_text_styles.dart';

/// Chip de estado con color y estilo personalizado.
class StatChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: AppDecorations.badge(color: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
