import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometric = true;
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
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
                _buildSecurityStatusHeader(),
                const SizedBox(height: 32),
                
                _buildSectionHeader('Access Control'),
                _buildSettingsCard([
                  _buildSecurityOption(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Last updated 3 months ago',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildSecurityOption(
                    context,
                    icon: Icons.fingerprint,
                    title: 'Biometric Login',
                    subtitle: 'Use FaceID or Fingerprint',
                    trailing: Switch(
                      value: _biometric,
                      onChanged: (v) => setState(() => _biometric = v),
                      activeColor: AppTheme.primaryColor,
                    ),
                    onTap: () {},
                  ),
                ]).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                const SizedBox(height: 24),

                _buildSectionHeader('Verification'),
                _buildSettingsCard([
                  _buildSecurityOption(
                    context,
                    icon: Icons.verified_user_outlined,
                    title: 'Two-Factor Auth',
                    subtitle: 'Add extra layer of protection',
                    trailing: Switch(
                      value: _twoFactor,
                      onChanged: (v) => setState(() => _twoFactor = v),
                      activeColor: AppTheme.primaryColor,
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildSecurityOption(
                    context,
                    icon: Icons.devices_other,
                    title: 'Active Sessions',
                    subtitle: 'Manage your logged-in devices',
                    onTap: () {},
                  ),
                ]).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                const SizedBox(height: 48),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.errorColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor, size: 32),
                      const SizedBox(height: 12),
                      const Text(
                        'Danger Zone',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.errorColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Once you delete your account, there is no going back. Please be certain.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Delete Account',
                        isOutlined: true,
                        onPressed: () => _showDeleteConfirm(context),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Security Status',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  _twoFactor ? 'Protected: High' : 'Protected: Medium',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodySmall?.color,
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
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
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
      trailing: trailing ?? Icon(Icons.chevron_right, size: 20, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
      onTap: onTap,
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Account?'),
        content: const Text('This action is permanent and cannot be undone. All your data will be lost forever.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete', style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
