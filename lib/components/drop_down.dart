import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_theme/theme.dart';


class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
     this.value,
    required this.list,
    required this.onChanged,
    this.isBorder=true,
    this.color= Colors.white,
    this.hintText,
    this.validator,
  });

  final String? value;
  final List<String> list;
  final ValueChanged<String?>? onChanged;
  final bool isBorder;
  final Color color;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(

      dropdownColor: AppThemeClass.whiteText,
      padding: EdgeInsets.zero,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down, color: AppThemeClass.primary),
      value: value,
      validator: validator,
      onChanged: onChanged,
      style: GoogleFonts.robotoSerif(
        // color: color,
        //fontSize: ResponsiveText.getSize(context, fontSize),
        //fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      items: list.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
             item,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        //contentPadding: EdgeInsets.all(0),

         contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
        hintStyle:GoogleFonts.robotoSerif(color: AppThemeClass.darkTextOptional,fontSize: 10),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppThemeClass.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppThemeClass.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder( // Add error border
          borderSide: BorderSide(color: AppThemeClass.primary, width: 1.0),
         // borderRadius: BorderRadius.circular(radius),
        ),
        focusedErrorBorder: OutlineInputBorder( // Add focused error border
          borderSide: BorderSide(color: AppThemeClass.primary, width: 1.0),
         // borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
