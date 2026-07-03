import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo & Name
            Column(
              children: [
                Animate(
                  effects: [
                    ScaleEffect(duration: 800.ms, curve: Curves.easeOutBack),
                    FadeEffect(duration: 800.ms),
                  ],
                  child: Image.asset(
                    'assets/mainlogo.jpeg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // High-fidelity fallback logo using circles
                      return SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AppTheme.buildFallbackCircle(Colors.yellow[600]!, const Offset(-25, 0)),
                            AppTheme.buildFallbackCircle(AppTheme.primaryColor, const Offset(0, -25)),
                            AppTheme.buildFallbackCircle(AppTheme.secondaryColor, const Offset(25, 0)),
                            AppTheme.buildFallbackCircle(Colors.blue[400]!, const Offset(0, 25)),
                            AppTheme.buildFallbackCircle(Colors.orange[400]!, const Offset(0, 0), size: 30),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Animate(
              effects: [
                SlideEffect(begin: const Offset(0, 0.5), end: Offset.zero, duration: 600.ms, delay: 400.ms),
                FadeEffect(duration: 600.ms, delay: 400.ms),
              ],
              child: const Text(
                'AI Powered Digital Marketing',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Animate(
              effects: [
                FadeEffect(duration: 600.ms, delay: 800.ms),
              ],
              child: const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
