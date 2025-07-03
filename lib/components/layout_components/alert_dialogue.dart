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

  static customAlertDialog(BuildContext context, String title,String message, String primaryButton,String secondaryButton, Function primary,bool isCircle) {
    showDialog(
      barrierDismissible:false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: AppThemeClass.whiteText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 10,

          // content: Text("Please wait verification is in process"),
          content:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isCircle?CrossAxisAlignment.center:CrossAxisAlignment.start,
            //  spacing: 10,
            children: [
              CustomText(text: title,fontSize: 14,color: AppThemeClass.primary,isBold: true,),
             isCircle? CircularProgressIndicator(color: AppThemeClass.primary,):message.length>1? CustomText(text: message,maxLines: 1,):SizedBox.shrink(),
             if(!isCircle) Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                     // backgroundColor:  AppThemeClass.primary ,
                      side: BorderSide(width: 1, color: AppThemeClass.primary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: CustomText(
                        text: secondaryButton,
                        color: AppThemeClass.primary
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:  AppThemeClass.primary ,
                      side: BorderSide(width: 1, color: AppThemeClass.primary),
                    ),
                    onPressed: () {
                      primary();
                    },
                    child: CustomText(
                        text: primaryButton,
                        color: AppThemeClass.whiteText
                    ),
                  ),
                ],
              )

            ],
          ),

        );
      },
    );
  }

}