import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/value_cubit.dart';
import '../../../core/theme/design_system.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import 'login_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer? _timer;
  final ValueCubit<bool> _canResendCubit = ValueCubit<bool>(true);
  final ValueCubit<int> _countdownCubit = ValueCubit<int>(0);
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Check status periodically every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      context.read<AuthBloc>().add(AuthEmailVerificationCheckRequested());
    });
  }

  void _startCountdown() {
    _canResendCubit.update(false);
    _countdownCubit.update(60);
    
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = _countdownCubit.state;
      if (current <= 1) {
        _canResendCubit.update(true);
        _countdownTimer?.cancel();
      } else {
        _countdownCubit.update(current - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthBlocStatus.authenticated && state.user != null) {
            final user = state.user!;
            if (user.isEmailVerified) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Email verified! Welcome to Run Quest.'),
                  backgroundColor: RunQuestDesignSystem.secondaryCyan,
                ),
              );
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark ? RunQuestDesignSystem.darkBackgroundGradient : null,
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: RunQuestDesignSystem.secondaryCyan.withOpacity(0.15),
                        shape: BoxShape.circle,
                        boxShadow: RunQuestDesignSystem.neonShadow(RunQuestDesignSystem.secondaryCyan),
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 64,
                        color: RunQuestDesignSystem.secondaryCyan,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'VERIFY EMAIL',
                      style: RunQuestDesignSystem.headingStyle(
                        isDark: isDark,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A link has been sent to your inbox',
                      style: RunQuestDesignSystem.bodyStyle(isDark: isDark),
                    ),
                    const SizedBox(height: 36),

                    // Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: RunQuestDesignSystem.glassDecoration(
                        isDark: isDark,
                        borderRadius: 24,
                        borderOpacity: 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Please verify your email address to unlock running and territory maps.',
                            textAlign: TextAlign.center,
                            style: RunQuestDesignSystem.bodyStyle(
                              isDark: isDark,
                              fontSize: 15,
                              color: isDark ? Colors.white : Colors.black,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Check manually
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthEmailVerificationCheckRequested());
                            },
                            child: const Text('I HAVE VERIFIED'),
                          ),
                          const SizedBox(height: 16),

                          // Resend Option wrapped in builders to avoid setState
                          MultiBlocProvider(
                            providers: [
                              BlocProvider<ValueCubit<bool>>.value(value: _canResendCubit),
                              BlocProvider<ValueCubit<int>>.value(value: _countdownCubit),
                            ],
                            child: BlocBuilder<ValueCubit<bool>, bool>(
                              builder: (context, canResend) {
                                return BlocBuilder<ValueCubit<int>, int>(
                                  builder: (context, countdown) {
                                    return OutlinedButton(
                                      onPressed: canResend ? _resendEmail : null,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        side: BorderSide(
                                          color: canResend
                                              ? RunQuestDesignSystem.secondaryCyan
                                              : (isDark ? RunQuestDesignSystem.darkBorder : RunQuestDesignSystem.lightBorder),
                                        ),
                                      ),
                                      child: Text(
                                        canResend ? 'RESEND EMAIL' : 'RESEND IN ${countdown}S',
                                        style: RunQuestDesignSystem.headingStyle(
                                          isDark: isDark,
                                          fontSize: 14,
                                          color: canResend
                                              ? RunQuestDesignSystem.secondaryCyan
                                              : (isDark ? RunQuestDesignSystem.darkTextSecondary : RunQuestDesignSystem.lightTextSecondary),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Back to login (Logout)
                    TextButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        'Back to Sign In',
                        style: RunQuestDesignSystem.headingStyle(
                          isDark: isDark,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resendEmail() {
    context.read<AuthBloc>().add(AuthSendVerificationEmailRequested());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification link resent to your email.'),
        backgroundColor: RunQuestDesignSystem.primaryOrange,
      ),
    );
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    _canResendCubit.close();
    _countdownCubit.close();
    super.dispose();
  }
}
