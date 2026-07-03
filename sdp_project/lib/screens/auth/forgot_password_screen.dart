import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Directionality(
          textDirection: langProvider.textDirection,
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: AppTheme.softGradient(context),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          langProvider.isUrdu ? Icons.arrow_forward : Icons.arrow_back,
                          color: AppTheme.textPrimaryColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 24),

                      // Lock Icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_reset,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ).animate().scale(duration: 500.ms).fadeIn(),

                      const SizedBox(height: 32),

                      Center(
                        child: Text(
                          tr('reset_password'),
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                        ),
                      ).animate().slideX(begin: -0.2, duration: 400.ms).fadeIn(),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          tr('reset_subtitle'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                        ),
                      ).animate().slideX(begin: -0.2, duration: 400.ms, delay: 100.ms).fadeIn(),

                      const SizedBox(height: 40),

                      CustomTextField(
                        hintText: tr('email_address'),
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                      ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 200.ms).fadeIn(),

                      const SizedBox(height: 32),

                      CustomButton(
                        text: tr('send_reset_link'),
                        icon: Icons.send,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                tr('reset_link_sent'),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: AppTheme.successColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ).animate().scale(duration: 400.ms, delay: 300.ms).fadeIn(),
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
}
