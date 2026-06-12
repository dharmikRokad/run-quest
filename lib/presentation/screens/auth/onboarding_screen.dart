import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/value_cubit.dart';
import '../../../core/theme/design_system.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/quest_background.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ValueCubit<int> _pageCubit = ValueCubit<int>(0);

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to Run Quest',
      description: 'Transform your daily runs into a competitive game of strategy, speed, and territory control.',
      icon: Icons.map_outlined,
      accentColor: RunQuestDesignSystem.secondaryCyan,
    ),
    OnboardingPageData(
      title: 'Claim Your Territory',
      description: 'As you run, the app tracks your route and claims H3 hexagonal zones (~66m wide) under your name in real time.',
      icon: Icons.grid_3x3_outlined,
      accentColor: RunQuestDesignSystem.primaryOrange,
    ),
    OnboardingPageData(
      title: 'Contested Takeovers',
      description: 'Run through territory owned by other players to initiate a Takeover! Build your empire and defend your borders.',
      icon: Icons.local_fire_department_outlined,
      accentColor: RunQuestDesignSystem.enemyCrimson,
    ),
    OnboardingPageData(
      title: 'Conquer the Leaderboard',
      description: 'Climb the ranks on the Global and Friends leaderboards in real time. Compare stats, earn badges, and win the season.',
      icon: Icons.emoji_events_outlined,
      accentColor: RunQuestDesignSystem.accentBlue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<ValueCubit<int>>.value(
      value: _pageCubit,
      child: Scaffold(
        body: QuestBackground(
          useSafeArea: true,
          child: Column(
            children: [
                // Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextButton(
                      onPressed: _navigateToLogin,
                      child: Text(
                        'Skip',
                        style: RunQuestDesignSystem.headingStyle(
                          isDark: isDark,
                          fontSize: 16,
                          color: isDark ? RunQuestDesignSystem.darkTextSecondary : RunQuestDesignSystem.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page Slider
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _pageCubit.update(index);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Glow Icon Container
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: page.accentColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                                boxShadow: RunQuestDesignSystem.neonShadow(page.accentColor),
                              ),
                              child: Icon(
                                page.icon,
                                size: 72,
                                color: page.accentColor,
                              ),
                            ),
                            const SizedBox(height: 48),
                            
                            // Glassmorphic Details Card
                            GlassCard(
                              borderOpacity: 0.1,
                              borderRadius: 24,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Text(
                                    page.title,
                                    textAlign: TextAlign.center,
                                    style: RunQuestDesignSystem.headingStyle(
                                      isDark: isDark,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    page.description,
                                    textAlign: TextAlign.center,
                                    style: RunQuestDesignSystem.bodyStyle(
                                      isDark: isDark,
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Control Panel
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BlocBuilder<ValueCubit<int>, int>(
                    builder: (context, currentPage) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Slide Indicators
                          Row(
                            children: List.generate(
                              _pages.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 8.0),
                                height: 8,
                                width: currentPage == index ? 24 : 8,
                                decoration: BoxDecoration(
                                  color: currentPage == index
                                      ? _pages[currentPage].accentColor
                                      : (isDark
                                          ? RunQuestDesignSystem.darkBorder
                                          : RunQuestDesignSystem.lightBorder),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          // Next/Get Started Button
                          GestureDetector(
                            onTap: () {
                              if (currentPage == _pages.length - 1) {
                                _navigateToLogin();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: currentPage == _pages.length - 1
                                    ? RunQuestDesignSystem.primaryGradient
                                    : null,
                                color: currentPage == _pages.length - 1
                                    ? null
                                    : _pages[currentPage].accentColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: currentPage == _pages.length - 1
                                    ? RunQuestDesignSystem.neonShadow(RunQuestDesignSystem.primaryOrange)
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                                    style: RunQuestDesignSystem.headingStyle(
                                      isDark: isDark,
                                      fontSize: 14,
                                      color: currentPage == _pages.length - 1
                                          ? Colors.white
                                          : _pages[currentPage].accentColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: currentPage == _pages.length - 1
                                        ? Colors.white
                                        : _pages[currentPage].accentColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageCubit.close();
    super.dispose();
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}
