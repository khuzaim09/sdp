import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/social_post.dart';
import '../../providers/language_provider.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text(tr('social_manager')),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: AppTheme.primaryColor,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                tabs: const [
                  Tab(text: 'Instagram'),
                  Tab(text: 'Facebook'),
                  Tab(text: 'LinkedIn'),
                  Tab(text: 'TikTok'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildTabContent(context, tr, 'Instagram', Icons.camera_alt_outlined),
                _buildTabContent(context, tr, 'Facebook', Icons.facebook_outlined),
                _buildTabContent(context, tr, 'LinkedIn', Icons.work_outline),
                _buildTabContent(context, tr, 'TikTok', Icons.music_note_outlined),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ).animate().scale(duration: 400.ms, delay: 500.ms).fadeIn(),
          ),
        );
      },
    );
  }

  Widget _buildTabContent(BuildContext context, String Function(String) tr, String platform, IconData icon) {
    final List<SocialPost> posts = [
      SocialPost(
        id: '1',
        platform: platform,
        content: 'Start your morning right with our new signature roast! ☕✨ Come visit us today and get 10% off your first cup. #MorningBrew #CoffeeLovers #SeattleCoffee',
        imageUrl: 'https://placeholder.com/coffee',
        scheduledFor: DateTime.now().add(const Duration(days: 1, hours: 9)),
      ),
      SocialPost(
        id: '2',
        platform: platform,
        content: 'Did you know our beans are ethically sourced? We believe in fair trade and amazing taste. 🌱☕ #SustainableCoffee #FairTrade',
        imageUrl: 'https://placeholder.com/beans',
        scheduledFor: DateTime.now().add(const Duration(days: 2, hours: 14)),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: posts.asMap().entries.map((entry) {
        final index = entry.key;
        final post = entry.value;
        return _buildPostCard(
          context,
          tr,
          post: post,
          delay: (index + 1) * 100,
        );
      }).toList(),
    );
  }

  Widget _buildPostCard(BuildContext context, String Function(String) tr, {required SocialPost post, required int delay}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Brew Seattle', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${tr('scheduled_for')} ${post.scheduledFor.month}/${post.scheduledFor.day}', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)), onPressed: () {}),
              ],
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[800],
            child: const Center(child: Icon(Icons.image, size: 64, color: Colors.white54)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(post.content),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(tr('edit_ai_post')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(tr('post_now')),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ).animate().slideY(begin: 0.1, duration: 400.ms, delay: delay.ms).fadeIn(delay: delay.ms);
  }
}
