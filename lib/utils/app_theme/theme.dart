
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
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
          side: BorderSide(
            color: colorScheme.primary
          )
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
        hintStyle: GoogleFonts.robotoSerif(
          color: colorScheme.onSurface,
          //fontSize: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      /* inputDecorationTheme: InputDecorationTheme(

        filled: true, // Enables the fill
        fillColor: colorScheme.surface, // Customize this as needed
        focusColor: colorScheme.primary, // Optional: color when focused
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(8), // Optional: rounded corners
        ),
      ),*/
     /* textTheme: TextTheme(
        displayLarge: GoogleFonts.robotoSerif(
          fontSize: ResponsiveBox.getSize(context, size),
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        titleLarge: GoogleFonts.robotoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
        bodyLarge: GoogleFonts.robotoSerif(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        bodyMedium: GoogleFonts.robotoSerif(
          fontSize: 14,
          color: colorScheme.onSurface,
        ),
        labelSmall: GoogleFonts.robotoSerif(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.secondary,
        ),
      ),*/

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary, // Set button background color
        foregroundColor: colorScheme.onPrimary, // Set text/icon color
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface, // Adapts to light/dark mode
        modalBackgroundColor: colorScheme.surface, // Ensures consistency
      ),
      colorScheme: colorScheme,
      dividerColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      /*popupMenuTheme: PopupMenuThemeData(
        color: colorScheme == lightColorScheme ?Colors.white:Colors.black38,
       // shadowColor: colorScheme == lightColorScheme ?Colors.black:Colors.white,
        //surfaceTintColor: colorScheme.surface
      ),*/
     /* dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(
          color: colorScheme.onSurface
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surface
        )
      ),*/

      dividerTheme: DividerThemeData(
        color: colorScheme.primary
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface, // Text color adapts to theme
          padding: EdgeInsets.zero, // Removes default padding
          visualDensity: VisualDensity.compact, // Reduces space
        ),
      ),


    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xff00a67e),
    onPrimary:Color(0xffd9f1eb),
    secondary: Color(0xff004036),
    onSecondary: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
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
    /* background: Color(0xFF241E30),
    onBackground: Colors.white, */// Adjusted color for better contrast
    surface:Colors.black,// Color(0xFF1F1929),
    onSurface: Colors.white,
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
