import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/button.dart';
import '../../components/text_widget.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../main_screen/main_screen.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});
  final TextEditingController otp=TextEditingController();
  final _checkLength=StateProvider.autoDispose<bool>((ref)=>false);

  @override
  Widget build(BuildContext context) {
    print("rebuilds");
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: buildCustomBackButton(context),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 50),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CustomText(text: "Verification",color: AppThemeClass.darkText,fontSize: 30,isBold: true,),
                CustomText(textAlign: TextAlign.center,text: "A 6 digit verification code has been sent on your number 0313******33",color: AppThemeClass.darkText,fontSize: 15),
                TextFormField(
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoSerif(fontSize: 20),
                  keyboardType: TextInputType.number,
                  controller: otp,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppThemeClass.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppThemeClass.primary,
                            width: 2.0
                        )
                    ),
                    filled: true,
                    fillColor: AppThemeClass.whiteText,
                    hintText: "232322",
                    hintStyle:GoogleFonts.robotoSerif(color: AppThemeClass.darkTextOptional,fontSize: 13),
                  ),
                ),
                CustomButton( title: 'Verify Number', onPress: (){
                 /* UiEventHandler.customAlertDialog(context, "Please wait! We're verifying your number", CircularProgressIndicator(color: AppThemeClass.primary,));
                  Future.delayed(Duration(seconds: 2),(){
                    Navigator.pop(context);
                   // Navigator.push(context, MaterialPageRoute(builder: (builder)=>MainScreen()));
                  });*/
                },),

              ],
            ),
          ),
        ));
  }
}


