import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

/// Tarjeta con gradiente y efecto glow.
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? glowColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.glowColor,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = glowColor != null
        ? AppDecorations.statCard(
            glowColor: glowColor!,
            borderRadius: borderRadius,
          )
        : AppDecorations.card(
            gradient: gradient,
            borderRadius: borderRadius,
          );

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: decoration,
            child: child,
          ),
        ),
      ),
    );
  }
}
