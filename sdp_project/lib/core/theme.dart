import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brandora Color Palette
  static const Color primaryColor = Color(0xFFE91E63); // Vibrant Pink
  static const Color secondaryColor = Color(0xFF9C27B0); // Deep Purple
  static const Color accentColor = Color(0xFF7C4DFF); // Electric Purple
  static const Color backgroundColor = Color(0xFFF8F9FA); // Off-white
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure White
  static const Color textPrimaryColor = Color(0xFF1E1E1E); // Almost Black
  static const Color textSecondaryColor = Color(0xFF757575); // Grey
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFF9800);

  // Gradient definitions
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient softGradient(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark 
        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
        : [const Color(0xFFFFFFFF), const Color(0xFFF8F0FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient cardGradient(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark
        ? [const Color(0xFF2A2A2A), const Color(0xFF1E1E1E)]
        : [const Color(0xFFE8EAF6), const Color(0xFFFCE4EC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: Colors.white,
        onSurface: textPrimaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: const TextStyle(color: textPrimaryColor),
        displayMedium: const TextStyle(color: textPrimaryColor),
        bodyLarge: const TextStyle(color: textPrimaryColor),
        bodyMedium: const TextStyle(color: textPrimaryColor),
        bodySmall: const TextStyle(color: textSecondaryColor),
      ),
      iconTheme: const IconThemeData(color: textPrimaryColor),
      dividerTheme: DividerThemeData(color: Colors.grey.withOpacity(0.1), thickness: 1),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryColor,
        iconTheme: IconThemeData(color: textPrimaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: primaryColor, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: textSecondaryColor),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Premium Navy Dark
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Color(0xFF1E293B), // Slate 800
        onSurface: Colors.white,
        background: Color(0xFF0F172A),
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      dividerTheme: DividerThemeData(color: Colors.white.withOpacity(0.1), thickness: 1),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white, // FORCED WHITE TEXT
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: primaryColor, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E293B),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static Widget buildFallbackCircle(Color color, Offset offset, {double size = 25}) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
