import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/language_provider.dart';
import '../../widgets/locked_feature_wrapper.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Scaffold(
          body: LockedFeatureWrapper(
            featureName: 'Full Analytics',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(context, tr),
                  const SizedBox(height: 32),
                  _buildGrowthChart(context, tr),
                  const SizedBox(height: 32),
                  _buildEngagementChart(context, tr),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(BuildContext context, String Function(String) tr) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard(context, tr('total_views'), '124.5K', '+12%', Icons.visibility_outlined, Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(context, tr('engagement_rate'), '4.8%', '+0.5%', Icons.favorite_outline, Colors.pink)),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatCard(context, tr('followers_growth'), '12,840', '+2.4K', Icons.person_add_outlined, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(change, style: const TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
        ],
      ),
    ).animate().scale(duration: 400.ms);
  }

  Widget _buildGrowthChart(BuildContext context, String Function(String) tr) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Followers Growth', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 3.5),
                      const FlSpot(3, 5),
                      const FlSpot(4, 4.5),
                      const FlSpot(5, 6),
                    ],
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryColor.withOpacity(0.2), AppTheme.primaryColor.withOpacity(0.0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildEngagementChart(BuildContext context, String Function(String) tr) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Engagement Rate by Platform', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: _getBottomTitles)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 5, Colors.pink),
                  _buildBarGroup(1, 8, Colors.blue),
                  _buildBarGroup(2, 6, Colors.indigo),
                  _buildBarGroup(3, 9, Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: AppTheme.textSecondaryColor, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0: text = 'Insta'; break;
      case 1: text = 'FB'; break;
      case 2: text = 'In'; break;
      case 3: text = 'TikTok'; break;
      default: text = ''; break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
  }
}
