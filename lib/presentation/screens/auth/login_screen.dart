import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/value_cubit.dart';
import '../../../core/theme/design_system.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/quest_background.dart';
import '../../widgets/quest_button.dart';
import 'register_screen.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueCubit<bool> _obscurePasswordCubit = ValueCubit<bool>(true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthBlocStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication failed'),
                backgroundColor: RunQuestDesignSystem.enemyCrimson,
              ),
            );
          } else if (state.status == AuthBlocStatus.authenticated && state.user != null) {
            final user = state.user!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome, ${user.username}!'),
                backgroundColor: RunQuestDesignSystem.secondaryCyan,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          }
        },
        child: QuestBackground(
          useSafeArea: true,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      // Header Logo / Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: RunQuestDesignSystem.primaryOrange.withOpacity(0.15),
                          shape: BoxShape.circle,
                          boxShadow: RunQuestDesignSystem.neonShadow(RunQuestDesignSystem.primaryOrange),
                        ),
                        child: const Icon(
                          Icons.directions_run_outlined,
                          size: 64,
                          color: RunQuestDesignSystem.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'RUN QUEST',
                        style: RunQuestDesignSystem.headingStyle(
                          isDark: isDark,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: RunQuestDesignSystem.primaryOrange,
                        ),
                      ),
                      Text(
                        'Conquer your neighborhood',
                        style: RunQuestDesignSystem.bodyStyle(
                          isDark: isDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Glassmorphism Login Card
                      GlassCard(
                        borderRadius: 24,
                        borderOpacity: 0.08,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sign In',
                              style: RunQuestDesignSystem.headingStyle(
                                isDark: isDark,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: RunQuestDesignSystem.bodyStyle(isDark: isDark, color: isDark ? Colors.white : Colors.black),
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field (wrapped in BlocBuilder for obscurity status)
                            BlocProvider<ValueCubit<bool>>.value(
                              value: _obscurePasswordCubit,
                              child: BlocBuilder<ValueCubit<bool>, bool>(
                                builder: (context, obscurePassword) {
                                  return TextFormField(
                                    controller: _passwordController,
                                    obscureText: obscurePassword,
                                    style: RunQuestDesignSystem.bodyStyle(isDark: isDark, color: isDark ? Colors.white : Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(Icons.lock_outlined),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        ),
                                        onPressed: () {
                                          _obscurePasswordCubit.update(!obscurePassword);
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state.status == AuthBlocStatus.loading;
                                return QuestButton(
                                  label: 'SIGN IN',
                                  isLoading: isLoading,
                                  onPressed: _submitForm,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign Up Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: RunQuestDesignSystem.bodyStyle(isDark: isDark),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: RunQuestDesignSystem.headingStyle(
                                isDark: isDark,
                                fontSize: 14,
                                color: RunQuestDesignSystem.primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePasswordCubit.close();
    super.dispose();
  }
}
