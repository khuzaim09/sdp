import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/language_toggle.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AuthProvider>(
      builder: (context, langProvider, authProvider, child) {
        final tr = langProvider.tr;
        final user = authProvider.currentUser;

        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                tr('settings'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              // Profile Section
              if (user != null) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20, color: AppTheme.primaryColor),
                                padding: const EdgeInsets.only(left: 8),
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  _showEditProfileDialog(context, user.name, authProvider);
                                },
                              ),
                            ],
                          ),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],

              if (user != null) ...[
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showEditProfileDialog(context, user.name, authProvider);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(),
              ],

              // Language Setting
              ListTile(
                title: Text(tr('language')),
                trailing: const LanguageToggle(),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              
              // Theme Setting
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return ListTile(
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (val) {
                        themeProvider.toggleTheme();
                      },
                    ),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
              const Divider(),
              

              
              // Privacy Policy
              ListTile(
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              
              // About
              ListTile(
                title: const Text('About Brandora'),
                trailing: const Icon(Icons.info_outline),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, String currentName, AuthProvider authProvider) {
    final nameController = TextEditingController(text: currentName);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty && newName != currentName) {
                  Navigator.pop(context);
                  final success = await authProvider.updateProfile(newName);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );
                  } else if (context.mounted && authProvider.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authProvider.errorMessage!)),
                    );
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
