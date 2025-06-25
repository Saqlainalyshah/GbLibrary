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

  static customAlertDialog(BuildContext context, String title,String message, String primaryButton,String secondaryButton, Function primary,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: AppThemeClass.whiteText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 10,
          // content: Text("Please wait verification is in process"),
          content:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            //  spacing: 10,
            children: [
              CustomText(text: title,fontSize: 14,color: AppThemeClass.primary,isBold: true,),
              CustomText(text: message,maxLines: 1,),
              Row(
                spacing: 25,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomText(text: "Cancel",isBold: true,fontSize: 15,color: AppThemeClass.primary,),
                      )),
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

          /*Column(
            mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.start,
           // spacing: 20,
            children: [


            ],
          ),*/
        );
      },
    );
  }

}