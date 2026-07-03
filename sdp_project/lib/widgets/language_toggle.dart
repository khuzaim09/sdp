import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/language_strings.dart';
import '../core/theme.dart';
import '../providers/language_provider.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(
                context,
                label: 'EN',
                isSelected: !langProvider.isUrdu,
                onTap: () => langProvider.setLanguage(AppLanguage.english),
              ),
              _buildOption(
                context,
                label: 'اردو',
                isSelected: langProvider.isUrdu,
                onTap: () => langProvider.setLanguage(AppLanguage.urdu),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                )
              : null,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
