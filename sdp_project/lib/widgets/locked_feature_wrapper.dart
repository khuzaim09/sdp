import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../screens/auth/subscription_selection_screen.dart';
import '../screens/subscription/subscription_screen.dart';
import 'custom_button.dart';

class LockedFeatureWrapper extends StatelessWidget {
  final Widget child;
  final String featureName;

  const LockedFeatureWrapper({
    super.key,
    required this.child,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final hasAccess = authProvider.hasFeatureAccess(featureName);

    if (hasAccess) return child;

    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        final tr = langProvider.tr;
        return Stack(
          children: [
            // Blurred or Dimmed Background
            Opacity(
              opacity: 0.3,
              child: AbsorbPointer(child: child),
            ),
            
            // Lock Overlay
            Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_outline, color: AppTheme.primaryColor, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr('upgrade_plan'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The "$featureName" feature is not available in your current plan.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondaryColor),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: tr('get_started'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
