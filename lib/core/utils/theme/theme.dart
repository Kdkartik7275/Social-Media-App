import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_x/core/utils/constants/colors.dart';

class TTheme {
  static ThemeData lightTheme = ThemeData(
    backgroundColor: TColors.lightBG,
    primaryColor: TColors.lightPrimary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: TColors.lightAccent,
    ),
    scaffoldBackgroundColor: TColors.lightBG,
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
      color: TColors.lightBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      backgroundColor: TColors.lightBG,
      iconTheme: const IconThemeData(color: Colors.black),
      toolbarTextStyle: GoogleFonts.nunito(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
      titleTextStyle: GoogleFonts.nunito(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: TColors.lightAccent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: TColors.darkAccent,
    ).copyWith(
      secondary: TColors.darkAccent,
      brightness: Brightness.dark,
    ),
    backgroundColor: TColors.darkBG,
    primaryColor: TColors.darkPrimary,
    scaffoldBackgroundColor: TColors.darkBG,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: TColors.darkAccent,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
      color: TColors.darkBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      backgroundColor: TColors.darkBG,
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarTextStyle: GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
      titleTextStyle: GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
