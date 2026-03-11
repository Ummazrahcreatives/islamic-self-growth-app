import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette - calm, spiritual greens
  static const Color primaryGreen = Color(0xFF2D6A4F);
  static const Color lightGreen = Color(0xFF74C69D);
  static const Color softGreen = Color(0xFFD8F3DC);
  static const Color paleGreen = Color(0xFFEEF7F0);

  // Warm neutrals
  static const Color beige = Color(0xFFF5F0E8);
  static const Color warmWhite = Color(0xFFFAF8F5);
  static const Color sandstone = Color(0xFFE8DCC8);
  static const Color warmTaupe = Color(0xFFC4A882);

  // Accent
  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFF5E6C3);
  static const Color roseWarm = Color(0xFFE8C4B8);

  // Text
  static const Color textDark = Color(0xFF1B2E25);
  static const Color textMedium = Color(0xFF4A5E54);
  static const Color textLight = Color(0xFF8A9E94);

  // Semantic
  static const Color success = Color(0xFF52B788);
  static const Color warning = Color(0xFFE9A14F);
  static const Color error = Color(0xFFE07070);
  static const Color info = Color(0xFF7BA7BC);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.warmWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.light,
        background: AppColors.warmWhite,
        surface: AppColors.beige,
        primary: AppColors.primaryGreen,
        secondary: AppColors.lightGreen,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        headlineLarge: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          color: AppColors.textMedium,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          color: AppColors.textMedium,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.beige,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.sandstone, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.nunito(color: AppColors.textLight, fontSize: 14),
        labelStyle: GoogleFonts.nunito(color: AppColors.textMedium, fontSize: 14),
      ),
    );
  }
}

class AppConstants {
  static const String appName = 'Nūr — Islamic Growth';
  static const String appTagline = 'Grow with purpose. Rooted in faith.';

  // Salah names
  static const List<String> salahNames = [
    'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
  ];

  // Habit categories
  static const List<String> habitCategories = [
    'Spiritual', 'Physical', 'Mental', 'Emotional', 'Financial'
  ];

  // Default habits
  static const List<Map<String, dynamic>> defaultHabits = [
    {'name': 'Tahajjud Prayer', 'category': 'Spiritual', 'icon': '🌙'},
    {'name': 'Quran Reading', 'category': 'Spiritual', 'icon': '📖'},
    {'name': 'Morning Adhkar', 'category': 'Spiritual', 'icon': '☀️'},
    {'name': 'Evening Adhkar', 'category': 'Spiritual', 'icon': '🌅'},
    {'name': 'Exercise', 'category': 'Physical', 'icon': '💪'},
    {'name': 'Charity (Sadaqah)', 'category': 'Financial', 'icon': '🤲'},
    {'name': 'Gratitude Journal', 'category': 'Emotional', 'icon': '💛'},
    {'name': 'Learning/Reading', 'category': 'Mental', 'icon': '📚'},
  ];

  // Guided journal prompts
  static const List<String> journalPrompts = [
    'What am I grateful to Allah for today?',
    'How did I connect with Allah today?',
    'What challenge did I face, and how can I view it as a blessing?',
    'How did I embody one of Allah\'s 99 names today?',
    'What intention (niyyah) do I want to set for tomorrow?',
    'What did I learn today that improved me as a Muslim?',
    'How did I serve others or my community today?',
    'What dua do I want to make tonight?',
    'What am I asking Allah to help me with right now?',
    'How can I improve my relationship with the Quran this week?',
  ];

  // Islamic quotes
  static const List<Map<String, String>> islamicQuotes = [
    {
      'arabic': 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      'translation': 'Verily, with hardship comes ease.',
      'source': 'Quran 94:6',
    },
    {
      'arabic': 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
      'translation': 'Whoever fears Allah, He will make a way out for them.',
      'source': 'Quran 65:2',
    },
    {
      'arabic': 'فَاذْكُرُونِي أَذْكُرْكُمْ',
      'translation': 'Remember Me and I will remember you.',
      'source': 'Quran 2:152',
    },
    {
      'arabic': 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      'translation': 'Allah is sufficient for us and He is the best Trustee.',
      'source': 'Quran 3:173',
    },
  ];
}
