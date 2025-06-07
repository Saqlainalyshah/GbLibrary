import 'package:booksexchange/components/button.dart';
import 'package:flutter/material.dart';

import '../components/text_widget.dart';
import '../utils/fontsize/app_theme/theme.dart';

/// Alert dialogue to check verification process
void showLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        backgroundColor: AppThemeClass.whiteText,
        surfaceTintColor: AppThemeClass.whiteText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 10,
        // content: Text("Please wait verification is in process"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            CustomText(text: "Logout" ,fontSize: 20,isBold: true,),
            CustomText(text: "Are you sure you want to logout?" ,fontSize: 15,),
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
                     child: CustomText(text: "Logout",isBold: true,fontSize: 15,color: AppThemeClass.primary,),
                   )),
               InkWell(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                     child: CustomText(text: "Cancel",isBold: true,fontSize: 15,color: AppThemeClass.primary,),
                   )),
             ],
           )

          ],
        ),
      );
    },
  );
}