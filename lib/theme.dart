import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class APlusTheme {
  APlusTheme._();

  // Brand Colors
  static const Color primaryColor = Color(0xFFFF3B30); // Apple Red
  static const Color secondaryColor = Color(0xFFFF6B6B); // Light Red
  static const Color tertiaryColor = Color(0xFFFF9B9B); // Softer Red

  // System Colors
  static const Color systemBackground = Color(0xFFF2F2F7); // iOS Background
  static const Color secondarySystemBackground =
      Color(0xFFFFFFFF); // iOS Secondary Background
  static const Color tertiarySystemBackground =
      Color(0xFFE5E5EA); // iOS Tertiary Background

  // Text Colors
  static const Color labelPrimary = Color(0xFF000000);
  static const Color labelSecondary = Color(0xFF3C3C43);
  static const Color labelTertiary = Color(0xFF3C3C4399);

  // Semantic Colors
  static const Color successColor = Color(0xFF34C759); // iOS Green
  static const Color warningColor = Color(0xFFFF9500); // iOS Orange
  static const Color errorColor = Color(0xFFFF3B30); // iOS Red
  static const Color infoColor = Color(0xFF007AFF); // iOS Blue

  // Blur Effects
  static const double regularBlur = 10.0;
  static const double thickBlur = 20.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // 테마 데이터
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: systemBackground,

        // Color Scheme
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: secondarySystemBackground,
          background: systemBackground,
          error: errorColor,
        ),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: labelPrimary,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: labelPrimary),
        ),

        // Text Theme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: labelPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: labelPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: labelPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: labelPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: labelPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: labelSecondary,
          ),
        ),

        // Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
                horizontal: spacingL, vertical: spacingM),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusM),
            ),
            minimumSize: const Size(44, 44),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
                horizontal: spacingL, vertical: spacingM),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusM),
            ),
            minimumSize: const Size(44, 44),
          ),
        )

        // Input Decoration Theme
        // inputDecorationTheme: InputDecorationTheme(
        //   filled: true,
        //   fillColor: tertiarySystemBackground,
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(radiusM),
        //     borderSide: BorderSide.none,
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(radiusM),
        //     borderSide: BorderSide.none,
        //   ),
        //   focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(radiusM),
        //     borderSide: const BorderSide(color: primaryColor, width: 2),
        //   ),
        //   errorBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(radiusM),
        //     borderSide: const BorderSide(color: errorColor),
        //   ),
        //   contentPadding: const EdgeInsets.symmetric(
        //     horizontal: spacingM,
        //     vertical: spacingM,
        //   ),
        // ),
        );
  }
}

TextTheme getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}
