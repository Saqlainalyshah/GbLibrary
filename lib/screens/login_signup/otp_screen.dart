import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/button.dart';
import '../../components/text_widget.dart';
import '../../utils/app_theme/theme.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});
  final TextEditingController otp=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: buildCustomBackButton(context),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 50),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: "Verification",fontSize: 30,isBold: true,),
                CustomText(textAlign: TextAlign.center,text: "A 6 digit verification code has been sent on your number 0313******33",fontSize: 15),
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
                    hintText: "232322",
                    hintStyle:GoogleFonts.robotoSerif(fontSize: 13),
                  ),
                ),
                CustomButton( title: 'Verify Number', onPress: (){
                },),

              ],
            ),
          ),
        ));
  }
}


