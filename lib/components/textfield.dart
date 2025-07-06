
import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme/theme.dart';

/// Text Field Widget
class CustomTextField extends StatelessWidget {
  // Constructor
  const CustomTextField({
    super.key,
    required this.controller,
    this.leadingIcon,
    this.trailingIcon,
    //this.fillColor = const Color(0xFFFAFAFA),
    this.fillColor =  Colors.white,
    this.textInputType = TextInputType.text,
    this.secure = false,
    this.radius = 5,
    this.isPhone=false,
    this.isRead=false,
    this.hintText = " ",
    this.isBorder = false,
    this.focusNode,
    this.onChanged,
    this.counterText,
    this.trailingFn,
    this.maxLength,
    this.maxLines,
    this.validator, // Added validator function
    this.onTapOutside,
  });

  final bool secure;
  final int? maxLength;
  final String? counterText;
  final bool isRead;
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
  final int? maxLines;
  final FocusNode? focusNode;
  final void Function(PointerDownEvent)? onTapOutside;



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      maxLength: maxLength,
      keyboardType: textInputType,
      obscureText: secure,
      controller: controller,
      readOnly: isRead,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: 1,
     // focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,

      style: GoogleFonts.robotoSerif(
        letterSpacing: -0.4
       // color: color,
        //fontSize: ResponsiveText.getSize(context, fontSize),
        //fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),// maxLines:maxLines,
      validator: validator, // Pass the function as an argument
    //  cursorColor: AppThemeClass.primary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
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
        errorBorder: OutlineInputBorder( // Add error border
          borderSide: BorderSide(color: AppThemeClass.primary, width: 1.0),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedErrorBorder: OutlineInputBorder( // Add focused error border
          borderSide: BorderSide(color: AppThemeClass.primary, width: 1.0),
          borderRadius: BorderRadius.circular(radius),
        ),

        filled: true,
       // fillColor: isDark?AppThemeClass.darkText:fillColor,
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
        hintStyle:GoogleFonts.robotoSerif(color:isDark?Colors.white70: AppThemeClass.darkText,fontSize: 13),
      ),
    );
  }
}
