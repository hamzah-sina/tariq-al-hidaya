import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(AppColors.primaryLight),
        onPrimary: Colors.white,
        secondary: const Color(AppColors.gold),
        onSecondary: Colors.black,
        surface: const Color(AppColors.surface),
        onSurface: const Color(AppColors.textPrimary),
        background: const Color(AppColors.background),
        onBackground: const Color(AppColors.textPrimary),
        error: const Color(AppColors.danger),
      ),
      scaffoldBackgroundColor: const Color(AppColors.background),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(AppColors.background),
        foregroundColor: Color(AppColors.textPrimary),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(AppColors.surface),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(AppColors.primaryLight).withOpacity(0.1),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.primaryLight),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          
          fontSize: 57,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
        headlineLarge: TextStyle(
          
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
        headlineMedium: TextStyle(
          
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
        titleLarge: TextStyle(
          
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
        titleMedium: TextStyle(
          
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.textPrimary),
        ),
        bodyLarge: TextStyle(
          
          fontSize: 16,
          color: Color(AppColors.textPrimary),
        ),
        bodyMedium: TextStyle(
          
          fontSize: 14,
          color: Color(AppColors.textSecondary),
        ),
        labelLarge: TextStyle(
          
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(AppColors.surface),
        selectedItemColor: Color(AppColors.primaryLight),
        unselectedItemColor: Color(AppColors.textHint),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          
          fontSize: 11,
        ),
      ),
    );
  }
}
