import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  print("all radio buttons were rebuild");
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(options.length, (index){
      return  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            activeColor: AppThemeClass.primary,
            value: options[index],
            groupValue: selectedOption,
            onChanged: (String? value) {
              onChanged(value!);
            },
          ),
          Text(options[index]), // Label next to radio button
        ],
      );
    }),
  );
}