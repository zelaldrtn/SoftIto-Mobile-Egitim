import 'package:flutter/material.dart';

class AppColors {
  // Editorial Finance Core: Orman Yeşili & Tonları
  static const Color forestDeep = Color(0xFF133E2B);
  static const Color forestPrimary = Color(0xFF1E5638);
  static const Color forestMedium = Color(0xFF2D734C);
  static const Color forestLight = Color(0xFF4E9B71);
  static const Color forestMint = Color(0xFF8FD5A6);
  static const Color forestSoftBg = Color(0xFFEAF5EE);

  // Sıcak Krem & Kırık Beyaz (Dreamy Base)
  static const Color creamBg = Color(0xFFFAF7F2);
  static const Color creamCard = Color(0xFFFFFFFF);
  static const Color creamCardAlt = Color(0xFFF4EFE6);
  static const Color warmBorder = Color(0xFFE7DEC8);

  // Dreamy Money Dokunuşları: Lila & Pastel Sarı
  static const Color dreamyLilac = Color(0xFF9D84B7);
  static const Color dreamyLilacLight = Color(0xFFEAE2F8);
  static const Color dreamyYellow = Color(0xFFF7D965);
  static const Color dreamyYellowLight = Color(0xFFFFF7D6);
  static const Color dreamyCoral = Color(0xFFE26D5C);
  static const Color dreamyCoralLight = Color(0xFFFFECE9);

  // Koyu Tema Renkleri
  static const Color darkBg = Color(0xFF0F1A15);
  static const Color darkCard = Color(0xFF192922);
  static const Color darkCardAlt = Color(0xFF22382E);
  static const Color darkBorder = Color(0xFF2E483C);
  static const Color darkTextPrimary = Color(0xFFF7F4EE);
  static const Color darkTextSecondary = Color(0xFFA5BDB0);

  // Açık Tema Metin Renkleri
  static const Color textPrimary = Color(0xFF182820);
  static const Color textSecondary = Color(0xFF5A6F64);
  static const Color textMuted = Color(0xFF8FA397);
}

class AppTheme {
  // Açık Tema (Dreamy Money & Editorial Light)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.creamBg,
      primaryColor: AppColors.forestPrimary,
      colorScheme: ColorScheme.light(
        primary: AppColors.forestPrimary,
        onPrimary: Colors.white,
        secondary: AppColors.dreamyLilac,
        onSecondary: Colors.white,
        tertiary: AppColors.dreamyYellow,
        surface: AppColors.creamCard,
        onSurface: AppColors.textPrimary,
        error: AppColors.dreamyCoral,
        surfaceContainerHighest: AppColors.creamCardAlt,
      ),
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.forestPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.creamCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.warmBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.forestPrimary,
          side: const BorderSide(color: AppColors.forestMedium, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.warmBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.warmBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.forestPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.dreamyCoral),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.creamCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.textMuted,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.warmBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // Koyu Tema (Editorial Dark)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.forestMint,
      colorScheme: ColorScheme.dark(
        primary: AppColors.forestMint,
        onPrimary: AppColors.darkBg,
        secondary: AppColors.dreamyLilacLight,
        onSecondary: AppColors.darkBg,
        tertiary: AppColors.dreamyYellow,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.dreamyCoral,
        surfaceContainerHighest: AppColors.darkCardAlt,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.forestMint),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestMint,
          foregroundColor: AppColors.darkBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.forestMint,
          side: const BorderSide(color: AppColors.forestLight, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCardAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.forestMint, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.dreamyCoral),
        ),
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.darkTextSecondary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
