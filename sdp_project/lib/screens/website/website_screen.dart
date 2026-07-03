import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../providers/language_provider.dart';

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  String? _selectedBusinessType;
  bool _isGenerating = false;
  bool _isPublished = false;
  String? _generatedUrl;

  final List<String> _businessTypes = [
    'Coffee Shop',
    'Tech Startup',
    'Digital Agency',
    'E-commerce Store',
    'Restaurant',
    'Portfolio'
  ];

  void _generateWebsite() async {
    if (_selectedBusinessType == null) return;

    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isGenerating = false;
      _generatedUrl = 'https://brandora.ai/sites/${_selectedBusinessType?.toLowerCase().replaceAll(' ', '-')}-123';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                      const SizedBox(height: 16),
                      Text(
                        tr('ai_website_generation'),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr('ai_generation_description'),
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 500.ms).fadeIn(),

                const SizedBox(height: 32),

                // Business Type Selection
                Text(
                  '1. Select Business Type',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _businessTypes.map((type) => ChoiceChip(
                    label: Text(type),
                    selected: _selectedBusinessType == type,
                    onSelected: (selected) {
                      setState(() {
                        _selectedBusinessType = selected ? type : null;
                        _generatedUrl = null;
                        _isPublished = false;
                      });
                    },
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: _selectedBusinessType == type ? Colors.white : AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )).toList(),
                ),

                const SizedBox(height: 32),

                // Action Button
                CustomButton(
                  text: tr('generate_with_ai'),
                  isLoading: _isGenerating,
                  onPressed: _selectedBusinessType != null ? _generateWebsite : () {},
                ),

                if (_generatedUrl != null) ...[
                  const SizedBox(height: 32),
                  Text(
                    '2. Website Preview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildPreviewSection(tr),
                  const SizedBox(height: 32),
                  
                  // Publish Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.successColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.public, color: AppTheme.successColor, size: 40),
                        const SizedBox(height: 16),
                        Text(
                          _isPublished ? 'Website is Live!' : 'Ready to Publish?',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        if (_isPublished) ...[
                          const SizedBox(height: 8),
                          Text(
                            _generatedUrl!,
                            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ],
                        const SizedBox(height: 24),
                        CustomButton(
                          text: _isPublished ? 'View Live Site' : tr('publish_website'),
                          onPressed: () {
                            setState(() => _isPublished = true);
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewSection(String Function(String) tr) {
    return Column(
      children: [
        _buildPreviewCard('Business Name', '${_selectedBusinessType} Pro', Icons.business),
        _buildPreviewCard('Homepage Title', 'Modern Solutions for Your ${_selectedBusinessType}', Icons.home),
        _buildPreviewCard('About Us', 'We are a dedicated team providing world-class services in the ${_selectedBusinessType} industry.', Icons.info_outline),
        _buildPreviewCard('Contact Info', 'contact@brandora.ai\n+1 234 567 890', Icons.contact_mail),
      ],
    );
  }

  Widget _buildPreviewCard(String label, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.secondaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit, size: 18)),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}
