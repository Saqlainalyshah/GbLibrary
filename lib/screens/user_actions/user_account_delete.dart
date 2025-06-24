import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/authentication/auth_repository.dart';

class AccountSecurity extends StatelessWidget {
  const AccountSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          surfaceTintColor: AppThemeClass.whiteText,
          backgroundColor: Colors.transparent,
          leading: buildCustomBackButton(context),
          title: CustomText(text: "Account",fontSize: 20,isBold: true,),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                    color: AppThemeClass.secondary
                )
            ),
            onTap: () {
               _showLogout(context);
            },
            title: CustomText(text: "Delete Account",isBold: true,fontSize: 16,),
            subtitle: CustomText(text: "Once you delete your account all your data will be deleted permanently"),
            trailing: Icon(Icons.delete,color: Colors.red,size: 30,),
          ),
        ),
      ),
    );
  }
}


/// Alert dialogue to user logout action
void _showLogout(BuildContext context) {
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
            CustomText(text: "Permanent Delete " ,fontSize: 20,isBold: true,),
            CustomText(text: "Are you sure you want to delete your account?" ,fontSize: 15,),
            Row(
              spacing: 25,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer(
                  builder:(context,ref,child)=>InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        UiEventHandler.customAlertDialog(context, "Deleting Account...", CircularProgressIndicator(color: AppThemeClass.primary,));
                        //final result=
                        AuthRepository auth=AuthRepository();
                        auth.deleteAccount().whenComplete((){
                         print("object");
                       });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomText(text: "Delete",isBold: true,fontSize: 15,color: AppThemeClass.primary,),
                      )),
                ),
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
