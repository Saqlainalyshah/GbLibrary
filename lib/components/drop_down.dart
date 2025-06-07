import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';


class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.value,
    required this.list,
    required this.onChanged,
    this.isBorder=true,
    this.color= Colors.white,
  });

  final String value;
  final List<String> list;
  final ValueChanged<String?>? onChanged;
  final bool isBorder;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15,),
      decoration: BoxDecoration(
        border: isBorder?Border.all(color: Colors.grey.shade300):null, // Light grey border
        borderRadius: BorderRadius.circular(10), // Rounded corners
        color: color, // Ensures background consistency
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: AppThemeClass.whiteText,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54), // Dropdown arrow
          style: const TextStyle(fontSize: 16, color: Colors.black),
          onChanged: onChanged,
          items: list.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: CustomText(text: item, fontSize: 16,isBold: true,),
            );
          }).toList(),
        ),
      ),
    );
  }
}
