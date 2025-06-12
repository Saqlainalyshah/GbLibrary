import 'package:flutter/material.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../text_widget.dart';




class UiEventHandler{
  static snackBarWidget(BuildContext context,String message, ){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating,margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          dismissDirection: DismissDirection.up,duration: Duration(seconds: 1),
          content: Text(message,style: TextStyle(color: AppThemeClass.whiteText),),
          backgroundColor:AppThemeClass.primary,

      ),
    );
  }

  static customAlertDialog(BuildContext context, String title,Widget widget,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: AppThemeClass.whiteText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 10,
          // content: Text("Please wait verification is in process"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              CustomText(text: title,fontSize: 14,),
              widget,
            ],
          ),
        );
      },
    );
  }

}