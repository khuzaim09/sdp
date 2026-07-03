import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SocialAutomationScreen extends StatefulWidget {
  const SocialAutomationScreen({super.key});

  @override
  State<SocialAutomationScreen> createState() => _SocialAutomationScreenState();
}

class _SocialAutomationScreenState extends State<SocialAutomationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _topicController = TextEditingController();
  bool _isGenerating = false;
  String _generatedCaption = '';
  String _generatedHashtags = '';
  
  // Mock data for scheduled posts
  final List<Map<String, dynamic>> _scheduledPosts = [
    {
      'platform': 'Instagram',
      'content': 'Coming soon: Our new summer collection! ☀️ #fashion #summer',
      'time': 'Tomorrow at 10:00 AM',
      'icon': FontAwesomeIcons.instagram,
    },
    {
      'platform': 'Facebook',
      'content': 'Check out our latest blog post on digital marketing trends.',
      'time': 'May 1, 2024 at 2:00 PM',
      'icon': FontAwesomeIcons.facebook,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  void _generateAIPost() async {
    if (_topicController.text.trim().isEmpty) return;
    
    setState(() {
      _isGenerating = true;
    });
    
    // Simulate AI delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isGenerating = false;
      _generatedCaption = "Transform your brand with Brandora! 🚀 Our AI tools help you stay ahead of the competition and reach your audience like never before. Start your journey today! #MarketingAI #BusinessGrowth";
      _generatedHashtags = "#DigitalMarketing #AI #Brandora #Innovation #SocialMediaStrategy #MarketingAutomation";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Scaffold(
          body: Column(
            children: [
              // Platform Tabs
              Container(
                color: Theme.of(context).cardColor,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.primaryColor,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                  tabs: const [
                    Tab(icon: Icon(FontAwesomeIcons.instagram, size: 20), text: 'Insta'),
                    Tab(icon: Icon(FontAwesomeIcons.facebook, size: 20), text: 'FB'),
                    Tab(icon: Icon(FontAwesomeIcons.linkedin, size: 20), text: 'In'),
                    Tab(icon: Icon(FontAwesomeIcons.tiktok, size: 20), text: 'TikTok'),
                  ],
                ),
              ),
              
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildModuleContent(tr, 'Instagram'),
                    _buildModuleContent(tr, 'Facebook'),
                    _buildModuleContent(tr, 'LinkedIn'),
                    _buildModuleContent(tr, 'TikTok'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModuleContent(String Function(String) tr, String platform) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Generator Section
          _buildSectionHeader(tr('post_generator'), Icons.auto_awesome),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _topicController,
            hintText: 'Enter business topic (e.g. Summer Coffee Deals)',
            prefixIcon: Icons.edit_note,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: tr('generate_plan').replaceAll('30-Day Plan', 'Post'), // Reusing keys or customizing
            isLoading: _isGenerating,
            onPressed: _generateAIPost,
          ),
          
          if (_generatedCaption.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildGeneratedResultCard(tr),
          ],
          
          const SizedBox(height: 32),
          
          // Hashtag Generator Section
          _buildSectionHeader(tr('hashtag_generator'), Icons.tag),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Generate Trending Hashtags', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildHashtagChip('#Marketing2024'),
                    _buildHashtagChip('#SocialGrowth'),
                    _buildHashtagChip('#AItools'),
                    _buildHashtagChip('#Success'),
                    _buildHashtagChip('#Branding'),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Refresh Trending',
                  isOutlined: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          
          // Scheduler Section
          _buildSectionHeader(tr('scheduler'), Icons.calendar_month),
          const SizedBox(height: 16),
          ..._scheduledPosts.map((post) => _buildScheduledPostItem(post)).toList(),
          
          const SizedBox(height: 32),
          
          // Ads Integration
          _buildSectionHeader('Ads Integration', Icons.ads_click),
          const SizedBox(height: 16),
          _buildAdsOptions(tr),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ],
    );
  }

  Widget _buildGeneratedResultCard(String Function(String) tr) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Caption:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          const SizedBox(height: 8),
          Text(_generatedCaption),
          const SizedBox(height: 16),
          const Text('Hashtags:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          const SizedBox(height: 8),
          Text(_generatedHashtags, style: const TextStyle(color: AppTheme.secondaryColor)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Schedule',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post Scheduled Successfully!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildScheduledPostItem(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(post['icon'], color: AppTheme.primaryColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['content'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(post['time'], style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildAdsOptions(String Function(String) tr) {
    return Column(
      children: [
        _buildAdOptionCard(
          'Run Ads Yourself',
          'We guide you through the process of setting up meta and google ads.',
          Icons.person_outline,
          () {},
        ),
        const SizedBox(height: 12),
        _buildAdOptionCard(
          'Connect with Agencies',
          'Professional marketing agencies to manage your large scale campaigns.',
          Icons.business_outlined,
          () {
            _showAgenciesList();
          },
        ),
      ],
    );
  }

  Widget _buildAdOptionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.secondaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  void _showAgenciesList() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top Marketing Agencies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildAgencyItem('Nexus Digital', '4.9 ⭐', 'Specialists in E-commerce'),
              _buildAgencyItem('BrandBoost AI', '4.8 ⭐', 'Focus on SaaS growth'),
              _buildAgencyItem('Social Spark', '4.7 ⭐', 'Viral content experts'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgencyItem(String name, String rating, String specialty) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(backgroundColor: AppTheme.secondaryColor, child: Icon(Icons.business, color: Colors.white)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$specialty • $rating'),
      trailing: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 36),
        ),
        child: const Text('Connect', style: TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildHashtagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      child: Text(
        tag,
        style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
