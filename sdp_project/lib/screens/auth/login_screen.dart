import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/language_toggle.dart';
import '../dashboard/dashboard_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;
        final isUrdu = langProvider.isUrdu;

        return Directionality(
          textDirection: langProvider.textDirection,
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Language Toggle at top
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const LanguageToggle(),
                          ],
                        ).animate().fadeIn(duration: 300.ms),

                        const SizedBox(height: 24),

                        // Logo
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/mainlogo.jpeg',
                              width: 90,
                              height: 90,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AppTheme.buildFallbackCircle(Colors.yellow[600]!, const Offset(-12, 0), size: 15),
                                    AppTheme.buildFallbackCircle(AppTheme.primaryColor, const Offset(0, -12), size: 15),
                                    AppTheme.buildFallbackCircle(AppTheme.secondaryColor, const Offset(12, 0), size: 15),
                                    AppTheme.buildFallbackCircle(Colors.blue[400]!, const Offset(0, 12), size: 15),
                                    AppTheme.buildFallbackCircle(Colors.orange[400]!, const Offset(0, 0), size: 18),
                                  ],
                                );
                              },
                            ),
                          ).animate().scale(duration: 500.ms).fadeIn(),
                        ),

                        const SizedBox(height: 32),

                        // Welcome Text
                        Center(
                          child: Text(
                            tr('welcome_back'),
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimaryColor,
                                ),
                          ),
                        ).animate().slideY(begin: -0.2, duration: 400.ms).fadeIn(),

                        const SizedBox(height: 8),

                        Center(
                          child: Text(
                            tr('sign_in_subtitle'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                          ),
                        ).animate().slideY(begin: -0.2, duration: 400.ms, delay: 100.ms).fadeIn(),

                        const SizedBox(height: 40),

                        // Email Field
                        CustomTextField(
                          controller: _usernameController,
                          hintText: tr('email_or_username'),
                          prefixIcon: Icons.person_outline,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 200.ms).fadeIn(),

                        const SizedBox(height: 16),

                        // Password Field
                        CustomTextField(
                          controller: _passwordController,
                          hintText: tr('password'),
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 300.ms).fadeIn(),

                        const SizedBox(height: 12),

                        // Forgot Password
                        Align(
                          alignment: isUrdu ? Alignment.centerLeft : Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                              );
                            },
                            child: Text(
                              tr('forgot_password'),
                              style: const TextStyle(
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 400.ms),

                        const SizedBox(height: 24),

                        // Sign In Button
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomButton(
                              text: tr('sign_in'),
                              isLoading: authProvider.isLoading,
                              icon: Icons.login,
                              onPressed: () async {
                                final email = _usernameController.text.trim();
                                final password = _passwordController.text.trim();

                                if (email.isEmpty || password.isEmpty) {
                                  _showError(tr('fill_all_fields'));
                                  return;
                                }

                                final success = await authProvider.login(email, password);
                                if (context.mounted) {
                                  if (success) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                    );
                                  } else {
                                    _showError(tr('invalid_credentials'));
                                  }
                                }
                              },
                            );
                          },
                        ).animate().scale(duration: 400.ms, delay: 500.ms).fadeIn(),

                        const SizedBox(height: 32),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                isUrdu ? 'یا' : 'OR',
                                style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ).animate().fadeIn(delay: 550.ms),

                        const SizedBox(height: 24),

                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr('no_account'),
                              style: const TextStyle(color: AppTheme.textSecondaryColor),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                                );
                              },
                              child: Text(
                                tr('sign_up'),
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 600.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
