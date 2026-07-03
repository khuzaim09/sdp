import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../dashboard/dashboard_screen.dart';

class MarketingGoalsScreen extends StatefulWidget {
  const MarketingGoalsScreen({super.key});

  @override
  State<MarketingGoalsScreen> createState() => _MarketingGoalsScreenState();
}

class _MarketingGoalsScreenState extends State<MarketingGoalsScreen> {
  final Set<String> _selectedGoals = {};

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        final List<String> goalKeys = [
          'increase_sales',
          'brand_awareness',
          'grow_social',
          'generate_leads',
          'improve_seo',
          'create_content',
        ];

        return Directionality(
          textDirection: langProvider.textDirection,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  langProvider.isUrdu ? Icons.arrow_forward : Icons.arrow_back,
                  color: AppTheme.textPrimaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(tr('step_2_of_2')),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('your_goals'),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().slideX(begin: -0.2, duration: 400.ms).fadeIn(),
                    const SizedBox(height: 8),
                    Text(
                      tr('goals_subtitle'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ).animate().slideX(begin: -0.2, duration: 400.ms, delay: 100.ms).fadeIn(),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: goalKeys.map((key) {
                          final isSelected = _selectedGoals.contains(key);
                          return ChoiceChip(
                            label: Text(tr(key)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedGoals.add(key);
                                } else {
                                  _selectedGoals.remove(key);
                                }
                              });
                            },
                            selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                            backgroundColor: AppTheme.surfaceColor,
                            labelStyle: TextStyle(
                              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                              ),
                            ),
                          ).animate().scale(delay: 200.ms);
                        }).toList(),
                      ),
                    ),
                    CustomButton(
                      text: tr('get_started'),
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          (route) => false,
                        );
                      },
                    ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 300.ms).fadeIn(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
