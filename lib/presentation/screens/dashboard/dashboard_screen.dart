import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/quest_background.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Get the current user profile from the AuthBloc state
    final authState = context.read<AuthBloc>().state;
    if (authState.status != AuthBlocStatus.authenticated || authState.user == null) {
      return const Scaffold(
        body: Center(child: Text('Unauthenticated')),
      );
    }
    
    final profile = authState.user!;
    final userColor = Color(int.parse('FF${profile.colorHex}', radix: 16));

    return Scaffold(
      appBar: AppBar(
        title: const Text('RUN QUEST DASHBOARD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: QuestBackground(
        useSafeArea: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header card
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar / Color circle
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: userColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: userColor, width: 3),
                        boxShadow: RunQuestDesignSystem.neonShadow(userColor),
                      ),
                      child: Center(
                        child: Text(
                          profile.username.substring(0, min(profile.username.length, 2)).toUpperCase(),
                          style: RunQuestDesignSystem.headingStyle(
                            isDark: isDark,
                            fontSize: 28,
                            color: userColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.username,
                      style: RunQuestDesignSystem.headingStyle(
                        isDark: isDark,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: RunQuestDesignSystem.bodyStyle(
                        isDark: isDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Chip(
                      backgroundColor: RunQuestDesignSystem.secondaryCyan.withOpacity(0.2),
                      side: const BorderSide(color: RunQuestDesignSystem.secondaryCyan),
                      label: Text(
                        'EMAIL VERIFIED',
                        style: RunQuestDesignSystem.headingStyle(
                          isDark: isDark,
                          fontSize: 11,
                          color: RunQuestDesignSystem.secondaryCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Statistics Section
              Text(
                'Your Running Stats',
                style: RunQuestDesignSystem.headingStyle(
                  isDark: isDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Territory',
                      '${profile.totalAreaM2.toStringAsFixed(0)} m²',
                      Icons.map_outlined,
                      RunQuestDesignSystem.secondaryCyan,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Runs',
                      '${profile.totalRuns}',
                      Icons.directions_run_outlined,
                      RunQuestDesignSystem.primaryOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildStatCard(
                context,
                'Total Distance Covered',
                '${(profile.totalDistanceM / 1000.0).toStringAsFixed(2)} km',
                Icons.timeline_outlined,
                RunQuestDesignSystem.accentBlue,
                isFullWidth: true,
              ),
              const SizedBox(height: 32),

              // Info card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: RunQuestDesignSystem.primaryOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RunQuestDesignSystem.primaryOrange.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: RunQuestDesignSystem.primaryOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Phase 2 Firebase Authentication is complete and secure! Proceed to Phase 3 for real-time run tracking.',
                        style: RunQuestDesignSystem.bodyStyle(
                          isDark: isDark,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isFullWidth = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: GlassCard(
        borderRadius: 18,
        padding: const EdgeInsets.all(20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: RunQuestDesignSystem.bodyStyle(
                  isDark: isDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: RunQuestDesignSystem.headingStyle(
              isDark: isDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}

  int min(int a, int b) => a < b ? a : b;

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: RunQuestDesignSystem.glassDecoration(
                isDark: isDark,
                borderRadius: 24,
                borderOpacity: 0.12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: RunQuestDesignSystem.enemyCrimson.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      boxShadow: RunQuestDesignSystem.neonShadow(RunQuestDesignSystem.enemyCrimson),
                    ),
                    child: const Icon(
                      Icons.logout_outlined,
                      size: 40,
                      color: RunQuestDesignSystem.enemyCrimson,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'LOGOUT QUEST?',
                    style: RunQuestDesignSystem.headingStyle(
                      isDark: isDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: RunQuestDesignSystem.enemyCrimson,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Are you sure you want to end your current session? You will need to sign back in to access running and territory maps.',
                    textAlign: TextAlign.center,
                    style: RunQuestDesignSystem.bodyStyle(
                      isDark: isDark,
                      fontSize: 14,
                      color: isDark ? RunQuestDesignSystem.darkTextSecondary : RunQuestDesignSystem.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? RunQuestDesignSystem.darkBorder
                                  : RunQuestDesignSystem.lightBorder,
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: RunQuestDesignSystem.headingStyle(
                              isDark: isDark,
                              fontSize: 14,
                              color: isDark
                                  ? RunQuestDesignSystem.darkTextPrimary
                                  : RunQuestDesignSystem.lightTextPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shadowColor: RunQuestDesignSystem.enemyCrimson.withValues(alpha: 0.3),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: RunQuestDesignSystem.enemyGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Text(
                                'LOG OUT',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result == true && context.mounted) {
      context.read<AuthBloc>().add(AuthLogoutRequested());
    }
  }
}
