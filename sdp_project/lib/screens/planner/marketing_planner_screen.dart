import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';

class MarketingPlannerScreen extends StatefulWidget {
  const MarketingPlannerScreen({super.key});

  @override
  State<MarketingPlannerScreen> createState() => _MarketingPlannerScreenState();
}

class _MarketingPlannerScreenState extends State<MarketingPlannerScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isGenerating = false;
  bool _planGenerated = false;

  // Mock tasks for the plan
  final List<Map<String, dynamic>> _tasks = [
    {'day': 1, 'task': 'Create Instagram Business Profile', 'done': true},
    {'day': 2, 'task': 'Research 20 Trending Hashtags', 'done': true},
    {'day': 3, 'task': 'Design 5 Product Showcase Posts', 'done': false},
    {'day': 4, 'task': 'Run First Meta Ad Campaign', 'done': false},
    {'day': 5, 'task': 'Connect with 10 Influencers', 'done': false},
    {'day': 6, 'task': 'Analyze Weekly Insights', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header with Progress
                _buildHeader(tr),

                if (!_planGenerated)
                  _buildGenerateEmptyState(tr)
                else
                  _buildPlanView(tr),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String Function(String) tr) {
    int completed = _tasks.where((t) => t['done']).length;
    double progress = completed / _tasks.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '30-Day Growth Plan',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'Day 3/30',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Progress: ${(progress * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              _buildStatCircle('$completed/${_tasks.length}', 'Tasks'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCircle(String value, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white38, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildGenerateEmptyState(String Function(String) tr) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(Icons.rocket_launch, size: 80, color: AppTheme.secondaryColor),
          const SizedBox(height: 24),
          const Text(
            'Ready to blast off?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Generate a personalized 30-day marketing plan tailored to your business goals.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: tr('generate_plan'),
            isLoading: _isGenerating,
            onPressed: () async {
              setState(() => _isGenerating = true);
              await Future.delayed(const Duration(seconds: 2));
              setState(() {
                _isGenerating = false;
                _planGenerated = true;
              });
            },
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildPlanView(String Function(String) tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calendar
        TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),
            formatButtonTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
            leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).iconTheme.color),
            rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
            todayDecoration: const BoxDecoration(color: AppTheme.secondaryColor, shape: BoxShape.circle),
            defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            weekendTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            outsideTextStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
        ).animate().fadeIn(),

        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            'Tasks For You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Tasks List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: task['done'] ? AppTheme.successColor.withOpacity(0.1) : AppTheme.secondaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'D${task['day']}',
                    style: TextStyle(
                      color: task['done'] ? AppTheme.successColor : AppTheme.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(
                  task['task'],
                  style: TextStyle(
                    decoration: task['done'] ? TextDecoration.lineThrough : null,
                    color: task['done'] ? Theme.of(context).textTheme.bodySmall?.color : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Checkbox(
                  value: task['done'],
                  onChanged: (val) {
                    setState(() {
                      task['done'] = val;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ).animate().slideX(begin: 0.1, delay: (index * 50).ms).fadeIn();
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
