import 'package:flutter/material.dart';
import '../../utils/fontsize/app_theme/theme.dart';

buildCustomBackButton(BuildContext context) {
  return IconButton(onPressed: () {
    Navigator.pop(context);
  }, icon: Icon(Icons.arrow_back_ios));
}

Widget buildCustomRadioButtons({
  required List<String> options,
  required String selectedOption,
  required Function(String) onChanged,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes items evenly
    children: options.map((option) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(

            activeColor: AppThemeClass.primary,
            value: option,
            groupValue: selectedOption,
            onChanged: (String? value) {
              onChanged(value!);
            },
          ),
          Text(option), // Label next to radio button
        ],
      );
    }).toList(),
  );
}