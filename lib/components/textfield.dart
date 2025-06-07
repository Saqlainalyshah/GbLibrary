
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/fontsize/app_theme/theme.dart';

/// Text Field Widget
class CustomTextField extends StatelessWidget {
  // Constructor
  const CustomTextField({
    super.key,
    required this.controller,
    this.leadingIcon,
    this.trailingIcon,
    this.fillColor = const Color(0xFFFAFAFA),
    this.textInputType = TextInputType.text,
    this.secure = false,
    this.radius = 10,
    this.isPhone=false,
    this.hintText = " ",
    this.isBorder = false,
    this.onChanged,
    this.counterText,
    this.trailingFn,
    this.maxLength,
    //this.maxLines,
    this.validator, // Added validator function
  });

  final bool secure;
  final int? maxLength;
  final String? counterText;
  final bool isBorder;
  final bool isPhone;
  final String hintText;
  final double radius;
  final TextInputType textInputType;
  final Color fillColor;
  final TextEditingController controller;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final void Function(String)? onChanged;
  final Function? trailingFn;
  final String? Function(String?)? validator;
 // final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: textInputType,
      obscureText: secure,
      controller: controller,
      onChanged: onChanged,
     // maxLines:maxLines,
      validator: validator, // Pass the function as an argument
      cursorColor: AppThemeClass.primary,
      decoration: InputDecoration(
        counterText: counterText,
       // labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppThemeClass.primary,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedBorder: OutlineInputBorder(
        //  borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppThemeClass.primary,
                width: 2.0
          )
        ),
        filled: true,
        fillColor: fillColor,
        prefixIcon: leadingIcon == null
            ? null
            : Icon(leadingIcon, color: AppThemeClass.primary, size: 25.0),
        suffixIcon: trailingIcon != null
            ? GestureDetector(
          onTap: () {
            if (trailingFn != null) {
              trailingFn!(); // Invoke the function when the trailing icon is tapped
            }
          },
          child: Icon(trailingIcon, color: AppThemeClass.primary, size: 25.0),
        ) : null,
        hintText: hintText,
        hintStyle:GoogleFonts.robotoSerif(color: AppThemeClass.darkTextOptional,fontSize: 13),
      ),
    );
  }
}
