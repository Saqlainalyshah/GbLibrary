import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme/theme.dart';


///Button widget
class CustomButton extends StatelessWidget {

  const CustomButton({
    super.key,
    this.isLoading = false,
    this.isBorder = false,
    this.title,
    this.isBold=true,
    this.widget,
    this.fontSize = 15.0,
    this.radius = 10.0,
    this.width = double.infinity,
    this.height = 50.0,

    this.color=const Color(0xff00a67e),
    this.titleColor,
    required this.onPress,
  });
  final bool isLoading;
  final bool isBorder;
  final bool isBold;
  final String? title;
  final Widget? widget;
  final double fontSize;
  final double height;
  final double width;
  final Color? titleColor;

  final double radius;
  final Color? color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          maxWidth: 400
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: color,
            border: isBorder?Border.all(
                color: AppThemeClass.primary
            ):null),
        child: Center(
            child: isLoading
                ? CircularProgressIndicator(
              color: AppThemeClass.whiteText,
            )
                : title != null? Text(
               title.toString(),
              style: TextStyle(
              color:  AppThemeClass.whiteText,
              fontSize: fontSize,
              fontWeight: FontWeight.bold
             )
            ):widget),
      ),
    );
  }
}

