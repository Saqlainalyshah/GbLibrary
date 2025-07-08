
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
     cursorErrorColor: AppThemeClass.primary,
      textCapitalization: TextCapitalization.sentences,

      style: GoogleFonts.poppins(
        letterSpacing: -0.2
       // color: color,
        //fontSize: ResponsiveText.getSize(context, fontSize),
        //fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),// maxLines:maxLines,
      validator: validator, // Pass the function as an argument
    //  cursorColor: AppThemeClass.primary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        counterText: counterText,
        filled: true,
        prefixIcon: leadingIcon == null
            ? null
            : Icon(leadingIcon, color: AppThemeClass.primary, size: 25.0),
        suffixIcon: trailingIcon != null
            ? IconButton(
          onPressed: () {
            if (trailingFn != null) {
              trailingFn!(); // Invoke the function when the trailing icon is tapped
            }
          },
          icon: Icon(trailingIcon, color: AppThemeClass.primary, size: 25.0),
        ) : null,
        hintText: hintText,
        hintStyle:GoogleFonts.poppins(color:isDark?Colors.white70: AppThemeClass.darkText,fontSize: 13),
      ),
    );
  }
}
