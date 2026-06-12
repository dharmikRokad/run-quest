import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/design_system.dart';

void main() {
  runApp(const RunQuestApp());
}

class RunQuestApp extends StatelessWidget {
  const RunQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run Quest',
      theme: RunQuestTheme.lightTheme,
      darkTheme: RunQuestTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to premium dark mode
      home: const DesignSystemShowcase(),
    );
  }
}

class DesignSystemShowcase extends StatelessWidget {
  const DesignSystemShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('RUN QUEST DESIGN SYSTEM')),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? RunQuestDesignSystem.darkBackgroundGradient : null,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Text(
                'Typography',
                style: RunQuestDesignSystem.headingStyle(
                  isDark: isDark,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Display Heading (Outfit)',
                style: RunQuestDesignSystem.headingStyle(
                  isDark: isDark,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Body Text (Inter) - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Activity logs and leaderboard stats will use this style.',
                style: RunQuestDesignSystem.bodyStyle(
                  isDark: isDark,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Colors & Gradients
              Text(
                'Theme Gradients',
                style: RunQuestDesignSystem.headingStyle(
                  isDark: isDark,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildGradientCard(
                      context,
                      'Electric Orange',
                      RunQuestDesignSystem.primaryGradient,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGradientCard(
                      context,
                      'Quest Cyan',
                      RunQuestDesignSystem.territoryGradient,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGradientCard(
                      context,
                      'Rage Crimson',
                      RunQuestDesignSystem.enemyGradient,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Premium Glassmorphism Card
              Text(
                'Glassmorphic Cards',
                style: RunQuestDesignSystem.headingStyle(
                  isDark: isDark,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: RunQuestQuestStyle.glassCard(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: RunQuestDesignSystem.primaryOrange
                                .withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_run,
                            color: RunQuestDesignSystem.primaryOrange,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Territory Acquired!',
                              style: RunQuestDesignSystem.headingStyle(
                                isDark: isDark,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Zone 8a28308280bffff',
                              style: RunQuestDesignSystem.bodyStyle(
                                isDark: isDark,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You took over this zone from user "Runner_X". Earned +45 m².',
                      style: RunQuestDesignSystem.bodyStyle(
                        isDark: isDark,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Interactive Elements
              Text(
                'Action Buttons',
                style: RunQuestDesignSystem.headingStyle(
                  isDark: isDark,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('START RUN'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: RunQuestDesignSystem.primaryOrange,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'PAUSE',
                        style: RunQuestDesignSystem.headingStyle(
                          isDark: isDark,
                          fontSize: 16,
                          color: RunQuestDesignSystem.primaryOrange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientCard(
    BuildContext context,
    String title,
    Gradient gradient,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: RunQuestDesignSystem.neonShadow(gradient.colors.first),
      ),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: RunQuestDesignSystem.headingStyle(
          isDark: isDark,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Utility extension for premium layout decorations
class RunQuestQuestStyle {
  static BoxDecoration glassCard(
    BuildContext context, {
    double borderRadius = 16.0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RunQuestDesignSystem.glassDecoration(
      isDark: isDark,
      borderRadius: borderRadius,
      borderOpacity: 0.08,
    );
  }
}
