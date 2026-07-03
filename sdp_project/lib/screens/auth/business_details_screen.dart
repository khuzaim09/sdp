import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'marketing_goals_screen.dart';

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

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
              title: Text(tr('step_1_of_2')),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('about_business'),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().slideX(begin: -0.2, duration: 400.ms).fadeIn(),
                    const SizedBox(height: 8),
                    Text(
                      tr('business_subtitle'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ).animate().slideX(begin: -0.2, duration: 400.ms, delay: 100.ms).fadeIn(),
                    const SizedBox(height: 40),
                    CustomTextField(
                      hintText: tr('business_name'),
                      prefixIcon: Icons.business,
                    ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 200.ms).fadeIn(),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: tr('industry'),
                      prefixIcon: Icons.category_outlined,
                    ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 300.ms).fadeIn(),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: tr('target_audience'),
                      prefixIcon: Icons.people_outline,
                    ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 400.ms).fadeIn(),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: tr('next'),
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MarketingGoalsScreen()),
                        );
                      },
                    ).animate().scale(duration: 400.ms, delay: 500.ms).fadeIn(),
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
