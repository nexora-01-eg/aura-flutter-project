import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuraColors {
  static const black      = Color(0xFF000000);
  static const deep       = Color(0xFF0D0D0D);
  static const surface    = Color(0xFF111111);
  static const surface2   = Color(0xFF181818);
  static const surface3   = Color(0xFF1E1E1E);
  static const gold       = Color(0xFFE8BD70);
  static const gold2      = Color(0xFFEDD185);
  static const gold3      = Color(0xFFF5CB86);
  static const goldDim    = Color(0x26E8BD70);  // 15%
  static const goldGlow   = Color(0x14E8BD70);  // 8%
  static const border     = Color(0x1FE8BD70);  // 12%
  static const borderBright = Color(0x4DE8BD70); // 30%
  static const text       = Color(0xFFF0EDE8);
  static const textDim    = Color(0x80F0EDE8);  // 50%
  static const textMuted  = Color(0x40F0EDE8);  // 25%
  static const danger     = Color(0xFFC0513A);
  static const success    = Color(0xFF3A6C4A);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AuraColors.black,
    primaryColor: AuraColors.gold,
    colorScheme: const ColorScheme.dark(
      primary: AuraColors.gold,
      secondary: AuraColors.gold2,
      surface: AuraColors.surface,
      background: AuraColors.black,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AuraColors.text,
      displayColor: AuraColors.text,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AuraColors.deep,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AuraColors.deep,
      selectedItemColor: AuraColors.gold,
      unselectedItemColor: AuraColors.textMuted,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardTheme(
      color: AuraColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AuraColors.border, width: 0.5),
      ),
    ),
    useMaterial3: true,
  );
}

// Typography helpers
class AuraText {
  static TextStyle cinzel({
    double size = 16,
    FontWeight weight = FontWeight.w600,
    Color color = AuraColors.text,
    double letterSpacing = 1,
  }) {
    return TextStyle(
      fontFamily: 'Cinzel',
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle label({
    double size = 10,
    Color color = AuraColors.textMuted,
    double letterSpacing = 2.5,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle body({
    double size = 13,
    Color color = AuraColors.text,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}
