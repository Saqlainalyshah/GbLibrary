import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


///Button widget
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.isLoading = false,
    this.isBorder = false,
    this.title,
    this.isBold=true,
    this.widget,
    this.fontSize = 14.0,
    this.radius = 10.0,
    this.width = double.infinity,
    this.height = 60.0,
    this.loadingColor=AppThemeClass.whiteText,
    this.color = const Color(0xff00a67e),
    this.titleColor = Colors.white,
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
  final Color titleColor;
  final Color loadingColor;
  final double radius;
  final Color color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        onPress();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: color,
            border: isBorder?Border.all(
                color: AppThemeClass.primary
            ):null),
        child: Center(
            child: isLoading
                ? CircularProgressIndicator(
              color: loadingColor,
            )
                : title != null? CustomText(
              text: title.toString(),
              color: titleColor,
              fontSize: fontSize,
              isBold: isBold,
            ):widget),
      ),
    );
  }
}
