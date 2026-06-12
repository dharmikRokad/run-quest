import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_quest/domain/repositories/auth_repository.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/design_system.dart';
import 'firebase_options.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/screens/auth/onboarding_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Dependency Injection Service Locator
  await initDependencyInjection();
  
  runApp(const RunQuestApp());
}

class RunQuestApp extends StatelessWidget {
  const RunQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        authRepository: sl<AuthRepository>(),
      )..add(AuthCheckRequested()),
      child: MaterialApp(
        title: 'Run Quest',
        theme: RunQuestTheme.lightTheme,
        darkTheme: RunQuestTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to premium dark mode
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthBlocStatus.initial || state.status == AuthBlocStatus.loading) {
          // Premium Splash / Loading Screen
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: isDark ? RunQuestDesignSystem.darkBackgroundGradient : null,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: RunQuestDesignSystem.primaryOrange.withOpacity(0.15),
                        shape: BoxShape.circle,
                        boxShadow: RunQuestDesignSystem.neonShadow(RunQuestDesignSystem.primaryOrange),
                      ),
                      child: const Icon(
                        Icons.directions_run_outlined,
                        size: 80,
                        color: RunQuestDesignSystem.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'RUN QUEST',
                      style: RunQuestDesignSystem.headingStyle(
                        isDark: isDark,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: RunQuestDesignSystem.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(RunQuestDesignSystem.primaryOrange),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state.status == AuthBlocStatus.authenticated && state.user != null) {
          return const DashboardScreen();
        } else {
          // By default, show onboarding screen (which guides user to login)
          return const OnboardingScreen();
        }
      },
    );
  }
}
