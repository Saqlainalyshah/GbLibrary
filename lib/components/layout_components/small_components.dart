import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/fontsize/app_theme/theme.dart';

buildCustomBackButton(BuildContext context) {
  return IconButton(onPressed: () {
    Navigator.pop(context);
  }, icon: Icon(Icons.arrow_back_ios));
}

