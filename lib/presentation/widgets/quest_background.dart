import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';

class QuestBackground extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;

  const QuestBackground({
    super.key,
    required this.child,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark ? RunQuestDesignSystem.darkBackgroundGradient : null,
      ),
      child: child,
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}
