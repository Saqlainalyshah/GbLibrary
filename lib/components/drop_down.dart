import 'package:flutter/material.dart';

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
      padding: EdgeInsets.zero,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down, color: AppThemeClass.primary),
      value: value,
      validator: validator,
      onChanged: onChanged,
      items: list.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
             item,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          //  style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: "Select an option", // You can also make this dynamic
      ),
    );
  }
}
