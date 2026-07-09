import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/user_model.dart';
import '../../models/subscription_plan.dart';
import '../branding/branding_screen.dart';
import '../social/social_screen.dart';
import '../builder/website_builder_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final tr = langProvider.tr;
    final user = authProvider.currentUser;
    final userName = user?.name ?? 'User';

    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${tr('hello')}, $userName',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _buildPlanBadge(context, user),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildAvatar(context),
                  ],
                ).animate().slideY(begin: -0.2, duration: 400.ms).fadeIn(),
                const SizedBox(height: 32),
                _buildRemainingDaysCard(context, tr, user),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr('marketing_campaign_desc'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(tr('try_ai_wizard'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/mainlogo.jpeg',
                          width: 48,
                          height: 48,
                          errorBuilder: (_, __, ___) => const Icon(Icons.hub,
                              size: 40, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .scale(duration: 500.ms, delay: 100.ms)
                    .fadeIn(delay: 100.ms),
                const SizedBox(height: 32),
                Text(
                  tr('marketing_tools'),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildToolCard(
                      context,
                      title: tr('branding_tools'),
                      icon: Icons.palette_outlined,
                      colors: [
                        const Color(0xFF7C4DFF),
                        const Color(0xFFB388FF)
                      ],
                      delay: 300,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BrandingScreen())),
                    ),
                    _buildToolCard(
                      context,
                      title: tr('social_automation'),
                      icon: Icons.share_outlined,
                      colors: [
                        const Color(0xFF2196F3),
                        const Color(0xFF64B5F6)
                      ],
                      delay: 400,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SocialScreen())),
                    ),
                    _buildToolCard(
                      context,
                      title: tr('website_builder'),
                      icon: Icons.article_outlined,
                      colors: [
                        const Color(0xFF009688),
                        const Color(0xFF4DB6AC)
                      ],
                      delay: 500,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WebsiteBuilderScreen())),
                    ),
                    _buildToolCard(
                      context,
                      title: tr('analytics'),
                      icon: Icons.analytics_outlined,
                      colors: [
                        const Color(0xFFFF9800),
                        const Color(0xFFFFB74D)
                      ],
                      delay: 600,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanBadge(BuildContext context, UserModel? user) {
    final plan = SubscriptionPlan.allPlans.firstWhere(
      (p) => p.id == user?.planId,
      orElse: () => SubscriptionPlan.allPlans.first,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        plan.name.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildRemainingDaysCard(
      BuildContext context, String Function(String) tr, UserModel? user) {
    if (user == null) return const SizedBox.shrink();

    final plan = SubscriptionPlan.allPlans.firstWhere(
      (p) => p.id == user.planId,
      orElse: () => SubscriptionPlan.allPlans.first,
    );

    final createdAt = user.planCreatedAt ?? DateTime.now();
    final expiryDate = createdAt.add(Duration(days: plan.daysLimit));
    final remainingDays = expiryDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color:
                remainingDays < 3 ? AppTheme.errorColor : AppTheme.successColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('subscription_plans'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  remainingDays <= 0
                      ? 'Plan Expired'
                      : '$remainingDays ${tr('remaining_days')}',
                  style: TextStyle(
                    color: remainingDays < 3
                        ? AppTheme.errorColor
                        : Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (remainingDays < 5)
            TextButton(
              onPressed: () {},
              child: Text(tr('upgrade_plan')),
            ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> colors,
    required int delay,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors[0].withOpacity(0.15),
                    colors[1].withOpacity(0.08)
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors[0], size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    )
        .animate()
        .scale(duration: 400.ms, delay: delay.ms)
        .fadeIn(delay: delay.ms);
  }
}
