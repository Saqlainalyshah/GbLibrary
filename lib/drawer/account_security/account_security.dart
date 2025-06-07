import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';

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
            onTap: (){
              print("Account deleted");
            },
            title: CustomText(text: "Delete Account",isBold: true,fontSize: 16,),
            subtitle: CustomText(text: "Once you delete your account all your data will be deleted permanently"),
            trailing: Icon(Icons.delete,color: Colors.red,),
          ),
        ),
      ),
    );
  }
}
