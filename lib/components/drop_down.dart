import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.value,
    required this.list,
    required this.onChanged,
    this.isBorder=true,
    this.color= Colors.white,
    this.hintText,
  });

  final String value;
  final List<String> list;
  final ValueChanged<String?>? onChanged;
  final bool isBorder;
  final Color color;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down, color: AppThemeClass.primary),
      value: value,
      onChanged: onChanged,
      items: list.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: CustomText(
            text: item,
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        hintStyle: GoogleFonts.robotoSerif(
          color: AppThemeClass.darkTextOptional,
          fontSize: 13,
        ),
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
      ),
    );
  }
}
