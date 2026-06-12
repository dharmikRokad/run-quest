import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double borderOpacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.borderOpacity = 0.1,
    this.padding = const EdgeInsets.all(24.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding,
      decoration: RunQuestDesignSystem.glassDecoration(
        isDark: isDark,
        borderRadius: borderRadius,
        borderOpacity: borderOpacity,
      ),
      child: child,
    );
  }
}
