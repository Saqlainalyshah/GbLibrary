import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import '../../utils/app_theme/theme.dart';
import '../text_widget.dart';




class UiEventHandler{
  static snackBarWidget(BuildContext context,String message, ){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating,margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          dismissDirection: DismissDirection.up,duration: Duration(seconds: 1),
          content: Text(message,style: TextStyle(color: AppThemeClass.whiteText,fontSize: ResponsiveText.getSize(context, 15)),),
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

          content:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isCircle?CrossAxisAlignment.center:CrossAxisAlignment.start,
            //  spacing: 10,
            spacing: 5,
            children: [
              CustomText(text: title,fontSize: 15,color: AppThemeClass.primary,),
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