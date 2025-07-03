import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leadingWidget;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final double? trailingIconSize;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final Color? titleColor;
  final String title;
  final Function onTap;

  const CustomListTile({
    this.leadingWidget,
    this.leadingIcon,
    this.leadingIconColor,
    this.trailingIconSize,
    this.trailingIcon,
    this.trailingIconColor,
    required this.title,
    this.titleColor,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:(){
        onTap();
      },
      dense: true,
      horizontalTitleGap: 10.0,
      minVerticalPadding: 8.0,
      leading: leadingIcon != null
          ? Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle
        ),
        child: Icon(
          leadingIcon,
          //size: leadingIconSize,
          color: leadingIconColor,
        ),
      )
          : leadingWidget,
      title: CustomText(text: 
        title,
      maxLines: 2,
        fontSize: 13,
      ),
      trailing: Icon(
        trailingIcon,
        size: trailingIconSize,
        color: trailingIconColor,
      ),
    );
  }
}
