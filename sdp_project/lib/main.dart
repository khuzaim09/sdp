import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'screens/auth/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const AIDigitalMarketingApp(),
    ),
  );
}

class AIDigitalMarketingApp extends StatelessWidget {
  const AIDigitalMarketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, langProvider, child) {
        return MaterialApp(
          title: 'AI Digital Marketing',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            return Directionality(
              textDirection: langProvider.textDirection,
              child: child!,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
