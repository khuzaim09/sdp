import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/language_toggle.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                tr('settings'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
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
              
              // Notifications
              ListTile(
                title: const Text('Notifications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
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
}
