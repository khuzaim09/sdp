import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: '+92 300 1234567');
    _locationController = TextEditingController(text: 'Lahore, Pakistan');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.person, size: 60, color: Colors.white),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                                    ],
                                  ),
                                  child: const Icon(Icons.edit, size: 20, color: AppTheme.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Change Profile Picture',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ).animate().scale(duration: 400.ms).fadeIn(),
                  ),

                  const SizedBox(height: 40),

                  // Fields Section
                  _buildSectionLabel('Personal Information'),
                  const SizedBox(height: 16),
                  
                  _buildFieldWrapper(
                    label: 'Full Name',
                    child: CustomTextField(
                      controller: _nameController,
                      hintText: 'Enter your name',
                      prefixIcon: Icons.person_outline,
                    ),
                  ).animate().slideX(begin: 0.1, delay: 100.ms).fadeIn(),

                  const SizedBox(height: 20),

                  _buildFieldWrapper(
                    label: 'Email Address',
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      readOnly: true,
                      enabled: false,
                    ),
                  ).animate().slideX(begin: 0.1, delay: 200.ms).fadeIn(),

                  const SizedBox(height: 20),

                  _buildFieldWrapper(
                    label: 'Phone Number',
                    child: CustomTextField(
                      controller: _phoneController,
                      hintText: 'Enter phone number',
                      prefixIcon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ).animate().slideX(begin: 0.1, delay: 300.ms).fadeIn(),

                  const SizedBox(height: 20),

                  _buildFieldWrapper(
                    label: 'Location',
                    child: CustomTextField(
                      controller: _locationController,
                      hintText: 'City, Country',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                  ).animate().slideX(begin: 0.1, delay: 400.ms).fadeIn(),

                  const SizedBox(height: 48),

                  // Action Button
                  CustomButton(
                    text: 'Save Changes',
                    icon: Icons.check_circle_outline,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Profile updated successfully!'),
                            backgroundColor: AppTheme.successColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ).animate().scale(delay: 500.ms),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFieldWrapper({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
