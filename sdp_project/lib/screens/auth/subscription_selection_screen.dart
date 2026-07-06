import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/subscription_plan.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../dashboard/dashboard_screen.dart';

class SubscriptionSelectionScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPassword;

  const SubscriptionSelectionScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
  });

  @override
  State<SubscriptionSelectionScreen> createState() => _SubscriptionSelectionScreenState();
}

class _SubscriptionSelectionScreenState extends State<SubscriptionSelectionScreen> {
  String? _selectedPlanId;

  IconData _getIconForPlan(String iconName) {
    switch (iconName) {
      case 'rocket':
        return Icons.rocket_launch;
      case 'flash':
        return Icons.flash_on;
      case 'business':
        return Icons.business_center;
      case 'crown':
        return Icons.workspace_premium;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = SubscriptionPlan.allPlans;

    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Directionality(
          textDirection: langProvider.textDirection,
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: AppTheme.softGradient(context),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  langProvider.isUrdu ? Icons.arrow_forward : Icons.arrow_back,
                                  color: AppTheme.textPrimaryColor,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tr('choose_plan'),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimaryColor,
                                ),
                          ).animate().slideY(begin: -0.2, duration: 400.ms).fadeIn(),
                          const SizedBox(height: 8),
                          Text(
                            tr('choose_plan_subtitle'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                          ).animate().fadeIn(delay: 100.ms),
                        ],
                      ),
                    ),

                    // Plan Cards
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: plans.asMap().entries.map((entry) {
                            final index = entry.key;
                            final plan = entry.value;
                            return _buildPlanCard(
                              context,
                              plan: plan,
                              delay: (index + 1) * 100,
                              tr: tr,
                              langProvider: langProvider,
                            );
                          }).toList(),
                          ),
                      ),
                    ),

                    // Get Started Button
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return CustomButton(
                            text: tr('get_started'),
                            icon: Icons.arrow_forward,
                            isLoading: authProvider.isLoading,
                            onPressed: () async {
                              if (_selectedPlanId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      tr('please_select_plan'),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: AppTheme.warningColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                                return;
                              }

                              if (_selectedPlanId != 'free_trial') {
                                final success = await authProvider.upgradeSubscription(_selectedPlanId!);
                                if (!success) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          tr(authProvider.errorMessage ?? 'something_went_wrong') ?? 'Failed to upgrade plan',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: AppTheme.errorColor,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    );
                                  }
                                  return;
                                }
                              }
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      tr('plan_selected') ?? 'Subscription plan selected!',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: AppTheme.successColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                  (route) => false,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 600.ms).fadeIn(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required SubscriptionPlan plan,
    required int delay,
    required String Function(String) tr,
    required LanguageProvider langProvider,
  }) {
    final isSelected = _selectedPlanId == plan.id;
    final isHighlighted = plan.isPopular || plan.isBestValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanId = plan.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isHighlighted
              ? const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isHighlighted ? null : AppTheme.surfaceColor,
          border: Border.all(
            color: isSelected
                ? (isHighlighted ? Colors.white : AppTheme.primaryColor)
                : (isHighlighted ? Colors.transparent : Colors.grey.shade200),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            if (isSelected || isHighlighted)
              BoxShadow(
                color: isHighlighted
                    ? AppTheme.primaryColor.withOpacity(0.3)
                    : AppTheme.primaryColor.withOpacity(0.15),
                blurRadius: isSelected ? 24 : 16,
                offset: const Offset(0, 8),
              ),
            if (!isHighlighted)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badges
            Row(
              children: [
                if (plan.isPopular)
                  _buildBadge(tr('most_popular'), isHighlighted),
                if (plan.isBestValue)
                  _buildBadge(tr('best_value'), isHighlighted),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isHighlighted ? Colors.white : AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: isHighlighted ? AppTheme.primaryColor : Colors.white,
                    ),
                  ),
              ],
            ),
            if (plan.isPopular || plan.isBestValue) const SizedBox(height: 12),

            // Plan icon and name row
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? Colors.white.withOpacity(0.2)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getIconForPlan(plan.iconName),
                    color: isHighlighted ? Colors.white : AppTheme.primaryColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(plan.nameKey),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isHighlighted ? Colors.white : AppTheme.textPrimaryColor,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tr(plan.durationKey),
                        style: TextStyle(
                          color: isHighlighted ? Colors.white70 : AppTheme.textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan.priceDisplay,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isHighlighted ? Colors.white : AppTheme.primaryColor,
                          ),
                    ),
                    if (plan.price > 0)
                      Text(
                        plan.durationKey == 'yearly'
                            ? '/yr'
                            : plan.durationKey == 'lifetime'
                                ? 'one-time'
                                : '/mo',
                        style: TextStyle(
                          color: isHighlighted ? Colors.white60 : AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              tr(plan.descriptionKey),
              style: TextStyle(
                color: isHighlighted ? Colors.white.withOpacity(0.85) : AppTheme.textSecondaryColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Features
            ...plan.features.take(4).map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: isHighlighted ? Colors.white : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            color: isHighlighted ? Colors.white.withOpacity(0.9) : AppTheme.textSecondaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            if (plan.features.length > 4)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${plan.features.length - 4} more features',
                  style: TextStyle(
                    color: isHighlighted ? Colors.white70 : AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ).animate().slideY(begin: 0.2, duration: 400.ms, delay: delay.ms).fadeIn(delay: delay.ms),
    );
  }

  Widget _buildBadge(String text, bool isHighlighted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHighlighted ? Colors.white : AppTheme.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
