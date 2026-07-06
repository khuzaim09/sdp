import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/language_toggle.dart';
import 'subscription_selection_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Validation error states
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Password strength
  double _passwordStrength = 0;
  String _passwordStrengthLabel = '';
  Color _passwordStrengthColor = Colors.grey;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String password) {
    double strength = 0;
    String label = '';
    Color color = Colors.grey;

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _passwordStrengthLabel = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    if (strength <= 0.25) {
      label = 'Weak';
      color = AppTheme.errorColor;
    } else if (strength <= 0.5) {
      label = 'Fair';
      color = AppTheme.warningColor;
    } else if (strength <= 0.75) {
      label = 'Good';
      color = Colors.lightGreen;
    } else {
      label = 'Strong';
      color = AppTheme.successColor;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthLabel = label;
      _passwordStrengthColor = color;
    });
  }

  bool _validateForm(String Function(String) tr) {
    bool isValid = true;
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Name validation
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = tr('name_required'));
      isValid = false;
    }

    // Email validation
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = tr('fill_all_fields'));
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => _emailError = tr('invalid_email'));
      isValid = false;
    } else {
      // Check duplicate email
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isEmailRegistered(email)) {
        setState(() => _emailError = tr('email_already_exists'));
        isValid = false;
      }
    }

    // Password validation
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _passwordError = tr('fill_all_fields'));
      isValid = false;
    } else if (password.length < 8) {
      setState(() => _passwordError = tr('password_too_short'));
      isValid = false;
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      setState(() => _passwordError = tr('password_needs_uppercase'));
      isValid = false;
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      setState(() => _passwordError = tr('password_needs_number'));
      isValid = false;
    }

    // Confirm password validation
    if (_confirmPasswordController.text != password) {
      setState(() => _confirmPasswordError = tr('passwords_dont_match'));
      isValid = false;
    }

    return isValid;
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
              decoration: BoxDecoration(
                gradient: AppTheme.softGradient(context),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top bar with back button and language toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                isUrdu ? Icons.arrow_forward : Icons.arrow_back,
                                color: AppTheme.textPrimaryColor,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const LanguageToggle(),
                          ],
                        ).animate().fadeIn(duration: 300.ms),

                        const SizedBox(height: 16),

                        // Header
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/mainlogo.jpeg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AppTheme.buildFallbackCircle(Colors.yellow[600]!, const Offset(-15, 0), size: 18),
                                      AppTheme.buildFallbackCircle(AppTheme.primaryColor, const Offset(0, -15), size: 18),
                                      AppTheme.buildFallbackCircle(AppTheme.secondaryColor, const Offset(15, 0), size: 18),
                                      AppTheme.buildFallbackCircle(Colors.blue[400]!, const Offset(0, 15), size: 18),
                                      AppTheme.buildFallbackCircle(Colors.orange[400]!, const Offset(0, 0), size: 22),
                                    ],
                                  ),
                                ),
                              ).animate().scale(duration: 500.ms).fadeIn(),
                              const SizedBox(height: 16),
                              Text(
                                tr('create_account'),
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                              ).animate().slideY(begin: -0.2, duration: 400.ms).fadeIn(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Center(
                          child: Text(
                            tr('signup_subtitle'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                          ),
                        ).animate().slideY(begin: -0.2, duration: 400.ms, delay: 100.ms).fadeIn(),

                        const SizedBox(height: 32),

                        // Full Name
                        CustomTextField(
                          controller: _nameController,
                          hintText: tr('full_name'),
                          prefixIcon: Icons.person_outline,
                          errorText: _nameError,
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 200.ms).fadeIn(),

                        const SizedBox(height: 16),

                        // Email Address
                        CustomTextField(
                          controller: _emailController,
                          hintText: tr('email_address'),
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          errorText: _emailError,
                          textDirection: TextDirection.ltr,
                        ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 300.ms).fadeIn(),

                        const SizedBox(height: 16),

                        // Password
                        CustomTextField(
                          controller: _passwordController,
                          hintText: tr('password'),
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          errorText: _passwordError,
                          onChanged: _updatePasswordStrength,
                        ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 400.ms).fadeIn(),

                        // Password Strength Indicator
                        if (_passwordStrength > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _passwordStrength,
                                    backgroundColor: Colors.grey[200],
                                    color: _passwordStrengthColor,
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _passwordStrengthLabel,
                                style: TextStyle(
                                  color: _passwordStrengthColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 200.ms),
                        ],

                        const SizedBox(height: 16),

                        // Confirm Password
                        CustomTextField(
                          controller: _confirmPasswordController,
                          hintText: tr('confirm_password'),
                          prefixIcon: Icons.lock_reset,
                          isPassword: true,
                          errorText: _confirmPasswordError,
                        ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 450.ms).fadeIn(),

                        const SizedBox(height: 32),

                        // Continue Button -> Hits API and goes to Dashboard
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomButton(
                              text: tr('continue_btn'),
                              icon: Icons.arrow_forward,
                              isLoading: authProvider.isLoading,
                              onPressed: () async {
                                if (_validateForm(tr)) {
                                  final success = await authProvider.register(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    planId: 'free_trial',
                                  );

                                  if (context.mounted) {
                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            tr('account_created') ?? 'Account Created!',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: AppTheme.successColor,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SubscriptionSelectionScreen(
                                            userName: _nameController.text.trim(),
                                            userEmail: _emailController.text.trim(),
                                            userPassword: _passwordController.text,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            tr(authProvider.errorMessage ?? 'fill_all_fields'),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: AppTheme.errorColor,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                            );
                          },
                        ).animate().scale(duration: 400.ms, delay: 500.ms).fadeIn(),

                        const SizedBox(height: 24),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr('already_have_account'),
                              style: const TextStyle(color: AppTheme.textSecondaryColor),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                tr('sign_in'),
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
}
