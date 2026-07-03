import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
                  'How can we help?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ).animate().fadeIn().slideX(begin: -0.2),
                const SizedBox(height: 16),
                
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for articles, guides...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: AppTheme.textSecondaryColor),
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 32),
                
                _buildSectionHeader('Support Channels'),
                Row(
                  children: [
                    Expanded(
                      child: _buildSupportActionCard(
                        context,
                        icon: Icons.chat_bubble_outline,
                        title: 'Live Chat',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSupportActionCard(
                        context,
                        icon: Icons.email_outlined,
                        title: 'Email Us',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                const SizedBox(height: 32),
                
                _buildSectionHeader('Quick Help'),
                _buildSettingsCard(
                  context,
                  [
                    _buildSupportTile(
                      icon: Icons.help_outline,
                      title: 'FAQs',
                      subtitle: 'Quick answers to common questions',
                    ),
                    const Divider(height: 1),
                    _buildSupportTile(
                      icon: Icons.menu_book_outlined,
                      title: 'User Guide',
                      subtitle: 'Learn how to use Brandora AI',
                    ),
                    const Divider(height: 1),
                    _buildSupportTile(
                      icon: Icons.video_library_outlined,
                      title: 'Video Tutorials',
                      subtitle: 'Watch step-by-step guides',
                    ),
                  ],
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                const SizedBox(height: 32),
                
                _buildSectionHeader('Popular Topics'),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildTopicChip(context, 'Subscription Settings'),
                    _buildTopicChip(context, 'AI Website Setup'),
                    _buildTopicChip(context, 'Social Posting'),
                    _buildTopicChip(context, 'Billing Issues'),
                    _buildTopicChip(context, 'Data Privacy'),
                  ],
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 48),
                
                CustomButton(
                  text: 'Create Support Ticket',
                  icon: Icons.add_comment_outlined,
                  onPressed: () {},
                ).animate().scale(delay: 500.ms),
                
                const SizedBox(height: 32),
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

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSupportActionCard(BuildContext context, {required IconData icon, required String title, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSupportTile({required IconData icon, required String title, required String subtitle}) {
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
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.textSecondaryColor),
      onTap: () {},
    );
  }

  Widget _buildTopicChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppTheme.textPrimaryColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
