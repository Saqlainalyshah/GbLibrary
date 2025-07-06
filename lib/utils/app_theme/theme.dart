
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
          backgroundColor: colorScheme.primary
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme == lightColorScheme ?Colors.white:Colors.black12,

      ),
      inputDecorationTheme: InputDecorationTheme(

        filled: true, // Enables the fill
        fillColor: colorScheme.surface, // Customize this as needed
        focusColor: colorScheme.primary, // Optional: color when focused
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8), // Optional: rounded corners
        ),
      ),
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
  ThemeNotifier() : super(ThemeMode.light); // Default to light mode.
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);
