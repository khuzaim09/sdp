import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../screens/auth/login_screen.dart';

class MainDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const MainDrawer({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, LanguageProvider>(
      builder: (context, authProvider, langProvider, child) {
        final tr = langProvider.tr;
        final user = authProvider.currentUser;

        return Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // User Header
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                currentAccountPicture: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/mainlogo.jpeg',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.hub, color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
                accountName: Row(
                  children: [
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (user?.planId ?? 'free').toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                accountEmail: Text(
                  user?.email ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),

              // Navigation Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildNavItem(
                      context,
                      index: 0,
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard,
                      label: tr('dashboard'),
                    ),
                    _buildNavItem(
                      context,
                      index: 1,
                      icon: Icons.smart_toy_outlined,
                      activeIcon: Icons.smart_toy,
                      label: tr('ai_assistant'),
                    ),
                    _buildNavItem(
                      context,
                      index: 2,
                      icon: Icons.auto_awesome_outlined,
                      activeIcon: Icons.auto_awesome,
                      label: tr('social_automation'),
                    ),
                    _buildNavItem(
                      context,
                      index: 3,
                      icon: Icons.calendar_today_outlined,
                      activeIcon: Icons.calendar_today,
                      label: tr('marketing_planner'),
                    ),
                    _buildNavItem(
                      context,
                      index: 4,
                      icon: Icons.web_outlined,
                      activeIcon: Icons.web,
                      label: tr('website_builder'),
                    ),
                    _buildNavItem(
                      context,
                      index: 5,
                      icon: Icons.analytics_outlined,
                      activeIcon: Icons.analytics,
                      label: tr('analytics'),
                    ),
                    _buildNavItem(
                      context,
                      index: 6,
                      icon: Icons.history_outlined,
                      activeIcon: Icons.history,
                      label: tr('chat_history'),
                    ),
                    _buildNavItem(
                      context,
                      index: 7,
                      icon: Icons.subscriptions_outlined,
                      activeIcon: Icons.subscriptions,
                      label: tr('subscription_plans') ?? 'Subscription',
                    ),
                    _buildNavItem(
                      context,
                      index: 8,
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: tr('settings'),
                    ),
                    const Divider(),
                    _buildNavItem(
                      context,
                      index: 9,
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings,
                      label: tr('settings'),
                    ),
                  ],
                ),
              ),

              // Logout
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.errorColor),
                title: Text(
                  tr('log_out'),
                  style: const TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;
    return ListTile(
      leading: Icon(
        isActive ? activeIcon : icon,
        color: isActive ? AppTheme.primaryColor : Theme.of(context).iconTheme.color?.withOpacity(0.5),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? AppTheme.primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        onTabSelected(index);
        Navigator.pop(context);
      },
      selected: isActive,
      selectedTileColor: AppTheme.primaryColor.withOpacity(0.05),
    );
  }
}
