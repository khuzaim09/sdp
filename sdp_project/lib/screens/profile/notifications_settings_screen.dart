import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _aiSuggestions = true;
  bool _marketingUpdates = false;
  bool _securityAlerts = true;
  bool _tips = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppTheme.softGradient(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification Center',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ).animate().fadeIn().slideX(begin: -0.2),
                const SizedBox(height: 8),
                const Text(
                  'Stay updated with your AI marketing progress.',
                  style: TextStyle(color: AppTheme.textSecondaryColor),
                ).animate().fadeIn(delay: 100.ms),
                
                const SizedBox(height: 32),
                
                _buildSectionHeader('Channels'),
                _buildSettingsCard([
                  _buildToggleTile(
                    title: 'Push Notifications',
                    subtitle: 'Instant alerts on your device',
                    icon: Icons.notifications_active_outlined,
                    value: _pushNotifications,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(height: 1),
                  _buildToggleTile(
                    title: 'Email Reports',
                    subtitle: 'Weekly summaries & news',
                    icon: Icons.alternate_email_outlined,
                    value: _emailNotifications,
                    onChanged: (val) => setState(() => _emailNotifications = val),
                  ),
                ]).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                const SizedBox(height: 24),

                _buildSectionHeader('AI & Insights'),
                _buildSettingsCard([
                  _buildToggleTile(
                    title: 'AI Insights',
                    subtitle: 'Daily marketing tips & growth ideas',
                    icon: Icons.lightbulb_outline,
                    value: _aiSuggestions,
                    onChanged: (val) => setState(() => _aiSuggestions = val),
                  ),
                  const Divider(height: 1),
                  _buildToggleTile(
                    title: 'Strategy Tips',
                    subtitle: 'Niche-specific marketing strategies',
                    icon: Icons.auto_graph_outlined,
                    value: _tips,
                    onChanged: (val) => setState(() => _tips = val),
                  ),
                ]).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                const SizedBox(height: 24),

                _buildSectionHeader('Account & Security'),
                _buildSettingsCard([
                  _buildToggleTile(
                    title: 'Security Alerts',
                    subtitle: 'Logins and account changes',
                    icon: Icons.security_outlined,
                    value: _securityAlerts,
                    onChanged: (val) => setState(() => _securityAlerts = val),
                  ),
                  const Divider(height: 1),
                  _buildToggleTile(
                    title: 'Marketing Updates',
                    subtitle: 'New features and offers',
                    icon: Icons.campaign_outlined,
                    value: _marketingUpdates,
                    onChanged: (val) => setState(() => _marketingUpdates = val),
                  ),
                ]).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                
                const SizedBox(height: 40),
                
                Center(
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preferences reset to default')),
                      );
                    },
                    child: const Text('Reset to Default', style: TextStyle(color: AppTheme.errorColor)),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
        activeTrackColor: AppTheme.primaryColor.withOpacity(0.2),
      ),
    );
  }
}
