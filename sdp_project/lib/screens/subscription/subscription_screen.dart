import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/subscription_plan.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final currentPlanId = user?.planId;

    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Scaffold(
          body: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('subscription_plans') ?? 'Subscription Plans',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: 8),
                    Text(
                      'Upgrade your account to unlock premium features and grow your business faster.',
                      style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
                    ).animate().fadeIn(delay: 100.ms),
                  ],
                ),
              ),

              // Plans List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final isCurrentPlan = plan.id == currentPlanId;
                    return _buildPlanItem(
                      context,
                      plan: plan,
                      isCurrentPlan: isCurrentPlan,
                      delay: (index + 1) * 100,
                      tr: tr,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanItem(
    BuildContext context, {
    required SubscriptionPlan plan,
    required bool isCurrentPlan,
    required int delay,
    required String Function(String) tr,
  }) {
    final isSelected = _selectedPlanId == plan.id;
    final isHighlighted = plan.isPopular || plan.isBestValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrentPlan
              ? AppTheme.successColor
              : (isHighlighted ? AppTheme.primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.2)),
          width: isCurrentPlan ? 2 : 1,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIconForPlan(plan.iconName), color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      plan.duration,
                      style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'CURRENT',
                    style: TextStyle(color: AppTheme.successColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              else
                Text(
                  plan.priceDisplay,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            plan.description,
            style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: plan.features.take(3).map((f) => _buildFeatureTag(f)).toList(),
          ),
          if (!isCurrentPlan) ...[
            const SizedBox(height: 20),
            CustomButton(
              text: 'Upgrade Now',
              onPressed: () async {
                final success = await Provider.of<AuthProvider>(context, listen: false)
                    .upgradeSubscription(plan.id);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully upgraded to ${plan.name}!')),
                  );
                  Navigator.pop(context); // Go back after successful upgrade
                } else if (context.mounted) {
                  final error = Provider.of<AuthProvider>(context, listen: false).errorMessage;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error ?? 'Failed to upgrade plan.')),
                  );
                }
              },
              isOutlined: !isHighlighted,
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1);
  }

  Widget _buildFeatureTag(String feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 12, color: AppTheme.successColor),
          const SizedBox(width: 4),
          Text(feature, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondaryColor)),
        ],
      ),
    );
  }
}
