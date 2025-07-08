import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


class AppThemeClass{
  static const Color primary=Color(0xff00a67e);
  static const Color primaryOptional=Color(0xff004036);
  static const Color secondary= Color(0xffd9f1eb);
  static const Color darkText= Colors.black;
  static const Color darkTextOptional=Colors.black54;
  static const Color whiteText= Colors.white;
  static const Color black=Color(0xFF1C1D1F);
}

class GlobalThemeData {
  static ThemeData lightThemeData = themeData(lightColorScheme);
  static ThemeData darkThemeData = themeData(darkColorScheme);

  static ThemeData themeData(ColorScheme colorScheme) {
    return ThemeData(

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surface, // Ensure it aligns with the theme
        contentTextStyle: TextStyle(
          color: colorScheme.onSecondary, // Use theme's contrast color
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
         // backgroundColor: colorScheme.surface
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
         // backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide.none,
            textStyle:  GoogleFonts.poppins(
          // fontSize: 12,
          letterSpacing: -0.2,
        ),
        )
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 5,
        shadowColor: colorScheme.primary,
        surfaceTintColor: colorScheme.surface,
        //barrierColor: Colors.blue,
        shape:RoundedRectangleBorder(

        )

      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          //fontSize: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide( color: colorScheme == lightColorScheme ?colorScheme.primary:colorScheme.secondary),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme == lightColorScheme ?colorScheme.primary:colorScheme.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme == lightColorScheme ?colorScheme.primary:colorScheme.secondary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme == lightColorScheme ?colorScheme.primary:colorScheme.secondary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: colorScheme.onSurface,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.secondary,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary, // Set button background color
        foregroundColor: colorScheme.onPrimary, // Set text/icon color
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,

      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface, // Adapts to light/dark mode
        modalBackgroundColor: colorScheme.surface, // Ensures consistency
      ),
      colorScheme: colorScheme,
      dividerColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,


      dividerTheme: DividerThemeData(
        color: colorScheme == lightColorScheme ?colorScheme.primary:colorScheme.secondary
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface, // Text color adapts to theme
          padding: EdgeInsets.zero, // Removes default padding
          visualDensity: VisualDensity.compact, // Reduces space
          textStyle:  GoogleFonts.poppins(
    // fontSize: 12,
    letterSpacing: -0.2,
        ),
        )
      ),


    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xff00a67e),
    onPrimary:Color(0xffd9f1eb),
    secondary: Color(0xff004036),
    onSecondary: Colors.black,
    surface: Colors.white,
    onSurface: Color(0XFF515357),
    primaryContainer:Color(0xff00a67e) ,
    error: Colors.redAccent,
    onError: Colors.red,
    brightness: Brightness.light,
    surfaceTint: Colors.white,


  );


  static  const ColorScheme darkColorScheme = ColorScheme(
      primary: Color(0xff00a67e),
      onPrimary:Color(0xffd9f1eb),
      secondary: Color(0xff004036),
    onSecondary: Colors.black54,
    surface:Color(0xFF1C1D1F),// Color(0xFF1F1929),
      onSurface: Color(0XFFC5C6C9),
    error: Colors.redAccent,
    primaryContainer:Color(0xffd9f1eb) ,
    onError: Colors.redAccent,
    brightness: Brightness.dark,
    surfaceTint: Colors.black
  );
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark); // Default to light mode.
  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);
