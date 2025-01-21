import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class APlusTheme {
  APlusTheme._();

  // Brand Colors
  static const Color primaryColor = Color(0xFFFF3B30); // Apple Red
  static const Color secondaryColor = Color(0xFFFF6B6B); // Light Red
  static const Color tertiaryColor = Color(0xFFFFE4E4); // Soft Red Background

  // System Colors
  static const Color systemBackground = Color(0xFFFFFFFF); // iOS Background
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
  static const Color borderLightGrey = Color(0xFFE1E1E1);
  // Accent Colors for UI Elements
  static const Color accentRed = Color(0xFFD63031); // Darker Red for Emphasis
  static const Color lightRed =
      Color(0xFFFFEBEB); // Very Light Red for Backgrounds
  static const Color darkRed =
      Color(0xFFC72C41); // Deep Red for Special Elements

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
      dialogBackgroundColor: systemBackground,
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: secondarySystemBackground,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: labelPrimary,
        onError: Colors.white,
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
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          minimumSize: const Size(44, 44),
          shadowColor: Colors.transparent,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          minimumSize: const Size(44, 44),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: secondarySystemBackground,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
          side: const BorderSide(
            color: tertiarySystemBackground,
            width: 1,
          ),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondarySystemBackground,
        selectedItemColor: primaryColor,
        unselectedItemColor: labelSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Input Decoration Theme
      // Input Decoration Theme 부분만 수정된 코드입니다
      inputDecorationTheme: InputDecorationTheme(
        // 배경색 제거 (밑줄 스타일을 위해)
        filled: false,

        // 기본 밑줄 스타일
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: tertiarySystemBackground,
            width: 1.0,
          ),
        ),

        // 비활성화된 상태의 밑줄
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: tertiarySystemBackground,
            width: 1.0,
          ),
        ),

        // 포커스 상태의 밑줄
        // focusedBorder: const UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: primaryColor,
        //     width: 2.0,
        //   ),
        // ),

        // 에러 상태의 밑줄
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: errorColor,
            width: 1.0,
          ),
        ),

        // 에러 상태에서 포커스된 밑줄
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: errorColor,
            width: 2.0,
          ),
        ),

        // 텍스트필드 내부 여백
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingS,
          vertical: spacingM,
        ),

        // 힌트 텍스트 스타일
        hintStyle: const TextStyle(
          color: labelTertiary,
          fontSize: 17,
          letterSpacing: -0.4,
        ),

        // 레이블 스타일
        labelStyle: const TextStyle(
          color: labelSecondary,
          fontSize: 15,
          letterSpacing: -0.4,
        ),

        // 에러 메시지 스타일
        errorStyle: const TextStyle(
          color: errorColor,
          fontSize: 13,
          letterSpacing: -0.4,
          height: 1.4,
        ),

        // 접두사/접미사 아이콘 스타일
        prefixIconColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return primaryColor;
          }
          return labelTertiary;
        }),
        suffixIconColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return primaryColor;
          }
          return labelTertiary;
        }),

        // 밑줄과 텍스트 사이 간격
        isDense: true,

        // 플로팅 레이블 애니메이션 설정
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return const TextStyle(
              color: primaryColor,
              fontSize: 13,
              letterSpacing: -0.4,
              fontWeight: FontWeight.w500,
            );
          }
          return const TextStyle(
            color: labelSecondary,
            fontSize: 13,
            letterSpacing: -0.4,
          );
        }),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: tertiarySystemBackground,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

TextTheme getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

final CustomTextTheme = const TextTheme(
  headlineLarge: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: APlusTheme.labelPrimary,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: APlusTheme.labelPrimary,
  ),
  titleLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: APlusTheme.labelPrimary,
  ),
  titleMedium: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: APlusTheme.labelPrimary,
  ),
  bodyLarge: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: APlusTheme.labelPrimary,
  ),
  bodyMedium: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: APlusTheme.labelSecondary,
  ),
);
