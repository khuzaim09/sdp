import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/language_provider.dart';

class BrandingScreen extends StatelessWidget {
  const BrandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;
        return Scaffold(
          appBar: AppBar(
            title: Text(tr('branding_tools')),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('ai_brand_generator'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ).animate().slideX(begin: -0.2, duration: 400.ms).fadeIn(),
                const SizedBox(height: 8),
                Text(
                  tr('brand_gen_subtitle'),
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 16),
                ).animate().slideX(begin: -0.2, duration: 400.ms, delay: 100.ms).fadeIn(),
                const SizedBox(height: 24),
                CustomTextField(
                  hintText: tr('industry'),
                  prefixIcon: Icons.store_outlined,
                ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 200.ms).fadeIn(),
                const SizedBox(height: 16),
                CustomButton(
                  text: tr('generate_brand_id'),
                  onPressed: () {},
                ).animate().scale(duration: 400.ms, delay: 300.ms).fadeIn(),
                const SizedBox(height: 40),
                Text(
                  tr('generated_logos'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildLogoCard(context, icon: Icons.coffee, title: 'Brew Seattle', delay: 500),
                      _buildLogoCard(context, icon: Icons.local_cafe, title: 'Seattle Sip', delay: 600),
                      _buildLogoCard(context, icon: Icons.emoji_food_beverage, title: 'Rain City Roasts', delay: 700),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  tr('color_palettes'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 16),
                _buildColorPaletteCard(context, colors: [Colors.brown, Colors.orange, Colors.amber, Colors.grey], delay: 900),
                const SizedBox(height: 16),
                _buildColorPaletteCard(context, colors: [Colors.blueGrey, Colors.teal, Colors.cyan, Colors.lightBlueAccent], delay: 1000),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoCard(BuildContext context, {required IconData icon, required String title, required int delay}) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppTheme.primaryColor),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().scale(duration: 400.ms, delay: delay.ms).fadeIn(delay: delay.ms);
  }

  Widget _buildColorPaletteCard(BuildContext context, {required List<Color> colors, required int delay}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: colors.map((color) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor, width: 2),
          ),
        )).toList(),
      ),
    ).animate().slideY(begin: 0.2, duration: 400.ms, delay: delay.ms).fadeIn(delay: delay.ms);
  }
}
