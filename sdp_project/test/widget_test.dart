// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aidigitalmarketing/main.dart';
import 'package:aidigitalmarketing/providers/theme_provider.dart';
import 'package:aidigitalmarketing/providers/auth_provider.dart';
import 'package:aidigitalmarketing/screens/auth/splash_screen.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame, wrapped in the necessary providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const AIDigitalMarketingApp(),
      ),
    );

    // Verify that the app starts with the SplashScreen.
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
