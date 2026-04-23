import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Contador animado que hace "count up" desde 0.
class AnimatedCounter extends StatefulWidget {
  final double value;
  final String? prefix;
  final String? suffix;
  final Duration duration;
  final TextStyle? style;
  final int decimals;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix,
    this.suffix,
    this.duration = const Duration(milliseconds: 1200),
    this.style,
    this.decimals = 0,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = _animation.value * widget.value;
        String text = widget.decimals > 0
            ? currentValue.toStringAsFixed(widget.decimals)
            : currentValue.toInt().toString();
        if (widget.prefix != null) text = '${widget.prefix}$text';
        if (widget.suffix != null) text = '$text${widget.suffix}';

        return Text(
          text,
          style: widget.style ?? AppTextStyles.statNumber,
        );
      },
    );
  }
}
