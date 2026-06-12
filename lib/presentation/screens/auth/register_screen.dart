import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/bloc/value_cubit.dart';
import '../../../core/theme/design_system.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/quest_background.dart';
import '../../widgets/quest_button.dart';
import '../dashboard/dashboard_screen.dart';

class UsernameCheckState {
  final bool isChecking;
  final bool? isUnique;
  final String? errorMessage;

  const UsernameCheckState({
    required this.isChecking,
    required this.isUnique,
    this.errorMessage,
  });
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueCubit<bool> _obscurePasswordCubit = ValueCubit<bool>(true);
  final ValueCubit<bool> _obscureConfirmPasswordCubit = ValueCubit<bool>(true);
  
  // Single cubit for username checking state
  final ValueCubit<UsernameCheckState> _usernameCubit = ValueCubit<UsernameCheckState>(
    const UsernameCheckState(isChecking: false, isUnique: null, errorMessage: null),
  );
  
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  void _onUsernameChanged() {
    final text = _usernameController.text.trim();
    if (text.isEmpty || text.length < 3 || text.length > 30) {
      _usernameCubit.update(const UsernameCheckState(isChecking: false, isUnique: null, errorMessage: null));
      return;
    }

    // Debounce the check request by 500ms
    _debounceTimer?.cancel();
    _usernameCubit.update(const UsernameCheckState(isChecking: true, isUnique: null, errorMessage: null));

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final authRepo = GetIt.instance<AuthRepository>();
        final isUnique = await authRepo.checkUsernameUnique(text);
        if (mounted) {
          _usernameCubit.update(UsernameCheckState(isChecking: false, isUnique: isUnique, errorMessage: null));
        }
      } catch (e) {
        if (mounted) {
          String errMsg = e.toString();
          if (errMsg.contains('unavailable') || errMsg.contains('network') || errMsg.contains('TimeoutException')) {
            errMsg = 'Network error. Check internet connection.';
          } else if (errMsg.contains('permission-denied')) {
            errMsg = 'Permission denied by database rules.';
          } else {
            errMsg = errMsg.replaceAll(RegExp(r'\[.*\]'), '').trim();
          }
          _usernameCubit.update(UsernameCheckState(isChecking: false, isUnique: null, errorMessage: errMsg));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthBlocStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Registration failed'),
                backgroundColor: RunQuestDesignSystem.enemyCrimson,
              ),
            );
          } else if (state.status == AuthBlocStatus.authenticated && state.user != null) {
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
                      Text(
                        'CREATE PROFILE',
                        style: RunQuestDesignSystem.headingStyle(
                          isDark: isDark,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: RunQuestDesignSystem.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join the quest to capture your city',
                        style: RunQuestDesignSystem.bodyStyle(isDark: isDark),
                      ),
                      const SizedBox(height: 36),

                      // Glassmorphism registration card
                      GlassCard(
                        borderRadius: 24,
                        borderOpacity: 0.08,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Username Field
                            BlocBuilder<ValueCubit<UsernameCheckState>, UsernameCheckState>(
                              bloc: _usernameCubit,
                              builder: (context, usernameState) {
                                return TextFormField(
                                  controller: _usernameController,
                                  style: RunQuestDesignSystem.bodyStyle(isDark: isDark, color: isDark ? Colors.white : Colors.black),
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: const Icon(Icons.person_outline),
                                    suffixIcon: _buildUsernameSuffix(),
                                    helperText: usernameState.errorMessage == null ? 'Between 3 and 30 characters' : null,
                                    errorText: usernameState.errorMessage,
                                    helperStyle: RunQuestDesignSystem.bodyStyle(isDark: isDark, fontSize: 11),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Username is required';
                                    }
                                    if (value.trim().length < 3) {
                                      return 'Username must be at least 3 characters';
                                    }
                                    if (usernameState.isUnique == false) {
                                      return 'This username is already taken';
                                    }
                                    if (usernameState.errorMessage != null) {
                                      return usernameState.errorMessage;
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 16),

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

                            // Password Field
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
                            const SizedBox(height: 16),

                            // Confirm Password Field
                            BlocProvider<ValueCubit<bool>>.value(
                              value: _obscureConfirmPasswordCubit,
                              child: BlocBuilder<ValueCubit<bool>, bool>(
                                builder: (context, obscureConfirmPassword) {
                                  return TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: obscureConfirmPassword,
                                    style: RunQuestDesignSystem.bodyStyle(isDark: isDark, color: isDark ? Colors.white : Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        ),
                                        onPressed: () {
                                          _obscureConfirmPasswordCubit.update(!obscureConfirmPassword);
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Submit Button (wrapped in both builders to check checking and loading states)
                            MultiBlocProvider(
                              providers: [
                                BlocProvider<ValueCubit<UsernameCheckState>>.value(value: _usernameCubit),
                              ],
                              child: BlocBuilder<ValueCubit<UsernameCheckState>, UsernameCheckState>(
                                builder: (context, usernameState) {
                                  return BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      final isLoading = state.status == AuthBlocStatus.loading;
                                      final isCheckingUsername = usernameState.isChecking;
                                      return QuestButton(
                                        label: 'CREATE ACCOUNT',
                                        isLoading: isLoading,
                                        onPressed: isCheckingUsername ? null : _submitForm,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign In Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: RunQuestDesignSystem.bodyStyle(isDark: isDark),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Sign In',
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

  Widget? _buildUsernameSuffix() {
    return BlocBuilder<ValueCubit<UsernameCheckState>, UsernameCheckState>(
      bloc: _usernameCubit,
      builder: (context, state) {
        if (state.isChecking) {
          return const Padding(
            padding: EdgeInsets.all(14.0),
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (state.isUnique == true) {
          return const Icon(Icons.check_circle_outline, color: RunQuestDesignSystem.secondaryCyan);
        }
        if (state.isUnique == false) {
          return const Icon(Icons.error_outline, color: RunQuestDesignSystem.enemyCrimson);
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _usernameCubit.state.isUnique != false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              username: _usernameController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePasswordCubit.close();
    _obscureConfirmPasswordCubit.close();
    _usernameCubit.close();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
