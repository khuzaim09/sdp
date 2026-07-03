import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock chat history data
    final List<Map<String, dynamic>> _history = [
      {
        'title': 'Coffee Shop Ad Strategy',
        'date': '2 hours ago',
        'snippet': 'I recommend focusing on Instagram Reels...',
        'messages': 12,
      },
      {
        'title': 'SEO Keyword Research',
        'date': 'Yesterday',
        'snippet': 'Top keywords for your niche are...',
        'messages': 8,
      },
      {
        'title': 'Logo Design Feedback',
        'date': '2 days ago',
        'snippet': 'The minimalist approach works best...',
        'messages': 15,
      },
      {
        'title': 'Email Marketing Plan',
        'date': 'Last week',
        'snippet': 'Subject lines should be catchy...',
        'messages': 24,
      },
    ];

    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;
        return Scaffold(
          body: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final chat = _history[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryColor),
                  ),
                  title: Text(
                    chat['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        chat['snippet'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                          const SizedBox(width: 4),
                          Text(chat['date'], style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 11)),
                          const SizedBox(width: 16),
                          Icon(Icons.message_outlined, size: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                          const SizedBox(width: 4),
                          Text('${chat['messages']} messages', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                  onTap: () {
                    // TODO: Reopen this chat context
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reopening: ${chat['title']}')),
                    );
                  },
                ),
              ).animate().slideX(begin: 0.1, delay: (index * 100).ms).fadeIn();
            },
          ),
        );
      },
    );
  }
}
