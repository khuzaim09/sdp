import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/locked_feature_wrapper.dart';

class WebsiteBuilderScreen extends StatefulWidget {
  const WebsiteBuilderScreen({super.key});

  @override
  State<WebsiteBuilderScreen> createState() => _WebsiteBuilderScreenState();
}

class _WebsiteBuilderScreenState extends State<WebsiteBuilderScreen> {
  String _selectedBusinessType = '';
  bool _isGenerating = false;
  bool _websiteGenerated = false;

  // Generated content placeholders
  String _generatedName = '';
  String _generatedAbout = '';
  String _generatedTagline = '';
  List<String> _generatedProducts = [];

  final List<String> _businessTypes = [
    'Coffee Shop',
    'Tech Startup',
    'Fitness Studio',
    'Fashion Boutique',
    'Law Firm',
    'Restaurant',
  ];

  void _generateWebsite() async {
    if (_selectedBusinessType.isEmpty) return;

    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _websiteGenerated = true;
      _generatedName = 'The $_selectedBusinessType Hub';
      _generatedTagline = 'Quality services for a better tomorrow.';
      _generatedAbout = 'We are a dedicated team of professionals focused on providing the best $_selectedBusinessType experience in the city. Founded in 2024, we have served over 1000+ happy customers.';
      _generatedProducts = [
        'Signature $_selectedBusinessType Service',
        'Premium Package',
        'Expert Consultation',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Scaffold(
          body: LockedFeatureWrapper(
            featureName: 'Website Builder',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_websiteGenerated)
                    _buildSetupView(tr)
                  else
                    _buildPreviewView(tr),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSetupView(String Function(String) tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instant AI Website',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ).animate().fadeIn(),
        const SizedBox(height: 8),
        Text(
          'Select your business type and let AI build your professional website in seconds.',
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 32),
        const Text(
          'What is your business?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _businessTypes.map((type) {
            bool isSelected = _selectedBusinessType == type;
            return GestureDetector(
              onTap: () => setState(() => _selectedBusinessType = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isSelected ? AppTheme.primaryColor : Theme.of(context).dividerColor),
                  boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 10)] : [],
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 48),
        CustomButton(
          text: 'Generate Website',
          isLoading: _isGenerating,
          onPressed: _generateWebsite,
        ).animate().scale(delay: 300.ms),
      ],
    );
  }

  Widget _buildPreviewView(String Function(String) tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Website Preview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => setState(() => _websiteGenerated = false),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit Info'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Mock Browser View
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
          ),
          child: Column(
            children: [
              // Browser Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade100 : Colors.black12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.red, size: 10),
                    const SizedBox(width: 4),
                    const Icon(Icons.circle, color: Colors.orange, size: 10),
                    const SizedBox(width: 4),
                    const Icon(Icons.circle, color: Colors.green, size: 10),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'https://mybusiness.app/${_generatedName.toLowerCase().replaceAll(' ', '')}',
                          style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Website Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      _generatedName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _generatedTagline,
                      style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodySmall?.color, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 24),
                    _buildPreviewSection('About Us', _generatedAbout),
                    const SizedBox(height: 24),
                    const Text('Our Products', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._generatedProducts.map((p) => _buildProductItem(p)).toList(),
                  ],
                ),
              ),
            ],
          ),
        ).animate().scale(duration: 400.ms),
        
        const SizedBox(height: 32),
        
        CustomButton(
          text: tr('publish_website'),
          icon: Icons.rocket_launch,
          onPressed: () {
            _showPublishDialog();
          },
        ),
      ],
    );
  }

  Widget _buildPreviewSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProductItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppTheme.secondaryColor, size: 16),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showPublishDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final url = 'https://mybusiness.app/${_generatedName.toLowerCase().replaceAll(' ', '')}';
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Website Published! 🎊'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your AI-generated website is now live at:'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(12)),
                child: Text(url, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Copy Link')),
          ],
        );
      },
    );
  }
}
