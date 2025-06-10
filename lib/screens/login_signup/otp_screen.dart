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
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios) ,style: IconButton.styleFrom(backgroundColor: AppThemeClass.secondary),),
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
                  showCustomAlertDialog(context);
                  Future.delayed(Duration(seconds: 2),(){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>MainScreen()));
                  });
                },),

              ],
            ),
          ),
        ));
  }
}

/// Alert dialogue to check verification process
void showCustomAlertDialog(BuildContext context) {
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
            CustomText(text: "Please wait! We're verifying your number",fontSize: 14,),
            CircularProgressIndicator(
              color: AppThemeClass.primary,
            ),

          ],
        ),
      );
    },
  );
}
