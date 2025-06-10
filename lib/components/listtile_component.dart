import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leadingWidget;
  final double leadingIconSize;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final double trailingIconSize;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  // final Color subTitleColor;
  final Color? titleColor;
  final String title;
  //final String? subtitle;
  final Function onTap;

  const CustomListTile({
    this.leadingWidget,
    this.leadingIconSize = 24.0,
    this.leadingIcon,
    this.leadingIconColor,
    this.trailingIconSize = 24.0,
    this.trailingIcon,
    this.trailingIconColor,
    required this.title,
    this.titleColor,
    required this.onTap,
    // this.subtitle,
    //this.subTitleColor = Colors.black,
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
          size: leadingIconSize,
          color: leadingIconColor,
        ),
      )
          : leadingWidget,
      title: CustomText(text:
        title,
            //color:  ?titleColor,
            //fontSize: 13,
            //fontWeight: FontWeight.w600

      ),
      trailing: Icon(
        trailingIcon,
        size: trailingIconSize,
        color: trailingIconColor,
      ),
    );
  }
}
