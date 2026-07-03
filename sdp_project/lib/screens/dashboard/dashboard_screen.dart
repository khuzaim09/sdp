import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/language_toggle.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../automation/social_automation_screen.dart';
import '../planner/marketing_planner_screen.dart';
import '../builder/website_builder_screen.dart';
import '../analytics/analytics_screen.dart';
import '../chat/chat_history_screen.dart';
import '../settings/settings_screen.dart';
import '../subscription/subscription_screen.dart';
import 'home_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),               // 0
    const ChatScreen(),            // 1
    const SocialAutomationScreen(), // 2
    const MarketingPlannerScreen(), // 3
    const WebsiteBuilderScreen(),  // 4
    const AnalyticsScreen(),       // 5
    const ChatHistoryScreen(),     // 6
    const SubscriptionScreen(),    // 7
    const ProfileScreen(),         // 8
    const SettingsScreen(),        // 9
  ];

  String _getTitle(int index, String Function(String) tr) {
    switch (index) {
      case 0: return tr('dashboard');
      case 1: return tr('ai_assistant');
      case 2: return tr('social_automation');
      case 3: return tr('marketing_planner');
      case 4: return tr('website_builder');
      case 5: return tr('analytics');
      case 6: return tr('chat_history');
      case 7: return tr('subscription_plans') ?? 'Subscription';
      case 8: return tr('settings');
      case 9: return tr('settings');
      default: return 'Brandora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Directionality(
          textDirection: langProvider.textDirection,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                _getTitle(_currentIndex, tr),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                const LanguageToggle(),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
              ],
            ),
            drawer: MainDrawer(
              currentIndex: _currentIndex,
              onTabSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            // We keep a bottom nav for the most frequent tasks
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        icon: Icons.dashboard_outlined,
                        activeIcon: Icons.dashboard,
                        label: tr('dashboard'),
                        index: 0,
                      ),
                      _buildNavItem(
                        icon: Icons.smart_toy_outlined,
                        activeIcon: Icons.smart_toy,
                        label: tr('ai_assistant'),
                        index: 1,
                      ),
                      _buildNavItem(
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: tr('settings'),
                        index: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isActive ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : Theme.of(context).iconTheme.color?.withOpacity(0.5),
              size: 20,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
