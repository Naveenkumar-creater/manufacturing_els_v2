import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const defaultPadding = 16.0;

class ThemeClass {
  Color lightPrimaryColor = const Color(0xFF03A9F4);
  Color darkPrimaryColor = const Color(0xFF03A9F4);

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    textTheme: GoogleFonts.lexendTextTheme().apply(
      bodyColor: Colors.black,

    ),
    colorScheme: ColorScheme.light().copyWith(
      primary: ThemeClass().darkPrimaryColor,
    ),
 

  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    textTheme: GoogleFonts.lexendTextTheme().apply(
      bodyColor: Colors.white, // Change body text color to white
    ),
    colorScheme: ColorScheme.dark().copyWith(
      primary: ThemeClass().darkPrimaryColor,
    ),
  
  );
}
