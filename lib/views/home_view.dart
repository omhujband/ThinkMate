import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/feature_card.dart';
import '../widgets/stat_card.dart';
import 'quiz_view.dart';
import 'concept_simplifier_view.dart';
import 'language_practice_view.dart';
import 'progress_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              Color(0xFF0F1629),
              AppColors.primaryMid,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildHeader(context),
                      const SizedBox(height: 28),
                      _buildQuickStats(context),
                      const SizedBox(height: 28),
                      _buildPrivacyBanner(context),
                      const SizedBox(height: 28),
                      Text(
                        'Learning Tools',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildListDelegate([
                    FeatureCard(
                      title: 'Quiz',
                      subtitle: 'Adaptive AI Quizzes',
                      icon: Icons.quiz_rounded,
                      gradientColors: const [
                        AppColors.accentCyan,
                        Color(0xFF0EA5E9),
                      ],
                      onTap: () => _navigateTo(context, const QuizView()),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    FeatureCard(
                      title: 'Simplify',
                      subtitle: 'Concept Breakdown',
                      icon: Icons.lightbulb_rounded,
                      gradientColors: const [
                        AppColors.accentViolet,
                        Color(0xFF7C3AED),
                      ],
                      onTap: () =>
                          _navigateTo(context, const ConceptSimplifierView()),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                    FeatureCard(
                      title: 'Language',
                      subtitle: 'Conversation Practice',
                      icon: Icons.translate_rounded,
                      gradientColors: const [
                        AppColors.accentPink,
                        Color(0xFFDB2777),
                      ],
                      onTap: () =>
                          _navigateTo(context, const LanguagePracticeView()),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                    FeatureCard(
                      title: 'Progress',
                      subtitle: 'Your Learning Stats',
                      icon: Icons.insights_rounded,
                      gradientColors: const [
                        AppColors.accentGreen,
                        Color(0xFF059669),
                      ],
                      onTap: () =>
                          _navigateTo(context, const ProgressView()),
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
                  ]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildModelInfo(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentCyan, AppColors.accentViolet],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 32,
              ),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                  duration: 2000.ms,
                  color: Colors.white.withOpacity(0.3),
                ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ThinkMate',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          letterSpacing: -1,
                        ),
                  ),
                  Text(
                    'On-Device AI Learning Companion',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1);
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer<ProgressService>(
      builder: (context, progress, child) {
        return Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.local_fire_department_rounded,
                value: '${progress.currentStreak}',
                label: 'Day Streak',
                accentColor: AppColors.accentOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.check_circle_rounded,
                value: '${progress.totalQuizzes}',
                label: 'Quizzes',
                accentColor: AppColors.accentCyan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.trending_up_rounded,
                value: '${progress.accuracy.toStringAsFixed(0)}%',
                label: 'Accuracy',
                accentColor: AppColors.accentGreen,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
      },
    );
  }

  Widget _buildPrivacyBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceCard.withOpacity(0.8),
            AppColors.surfaceCard.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accentCyan.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_rounded,
            color: AppColors.accentCyan.withOpacity(0.8),
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy-First AI',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  'All AI runs on your device. No data leaves your phone.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 600.ms);
  }

  Widget _buildModelInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textMuted.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(context, icon: Icons.memory_rounded, title: 'LLM', value: 'Llama 3.2 1B'),
          const SizedBox(height: 12),
          _buildInfoRow(context, icon: Icons.hearing_rounded, title: 'STT', value: 'Whisper Tiny'),
          const SizedBox(height: 12),
          _buildInfoRow(context, icon: Icons.record_voice_over_rounded, title: 'TTS', value: 'Piper TTS'),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 600.ms);
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 20),
        const SizedBox(width: 12),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accentCyan)),
      ],
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
