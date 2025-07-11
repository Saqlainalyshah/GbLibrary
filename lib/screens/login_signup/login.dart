import 'package:booksexchange/screens/user_actions/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/button.dart';
import '../../components/layout_components/alert_dialogue.dart';
import '../../components/text_widget.dart';
import '../../controller/authentication/auth_repository.dart';
import '../../utils/app_theme/theme.dart';
import '../../utils/fontsize/responsive_text.dart';

class Login extends ConsumerWidget {
  Login({super.key});
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();
  final TextEditingController phone=TextEditingController();
  final List<String> socialMediaNetworkImages=[
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdtpg4IsItbaNk0GxMyoz8f0fpVMIsFeNYCQ&s",
    "https://1000logos.net/wp-content/uploads/2017/02/Facebook-Logosu.png",
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("build");
    return  SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    //style: context.heading2,  // ✅ Ensures text inherits proper styling
                    children: [
                      TextSpan(
                          text: "Let's Educate ",
                          style:GoogleFonts.asapCondensed(
                            fontSize: 33,fontWeight: FontWeight.bold,
                            color:  Theme.of(context).colorScheme.onSurface
                          )
                      ),
                      TextSpan(
                          text: "Gilgit Baltistan",
                          style:GoogleFonts.asapCondensed(
                            fontSize: 33,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary,
                          )
                        // style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xff00a67e),fontFamily: GoogleFonts.roboto),
                      ),
                    ],
                  ),
                ),
              //  SizedBox(height: ResponsiveBox.getSize(context, 50),),
                  CustomText(text: "With",isBold: true,fontSize: 33,),*/
                RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    text: TextSpan(
                        style: TextStyle(
                            fontSize: ResponsiveBox.getSize(context, 50)
                        ),
                        children: [
                          TextSpan(
                              text: "Gilgit",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                          ),
                          TextSpan(text: "Swap",style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),

                          )
                        ]
                    )),
                /*SizedBox(height:10,),
                Text("Phone Number",style: GoogleFonts.robotoSerif(color: AppThemeClass.darkText),),
                Consumer(
                    builder:(context,ref,child){
                      final value= ref.watch(_checkLength);
                      return CustomTextField(controller: phone,textInputType: TextInputType.number,
                          maxLength: 11,counterText: '',
                          onChanged: (String value){
                            if(value.length==11){
                              ref.read(_checkLength.notifier).state=true;
                            }else{
                              ref.read(_checkLength.notifier).state=false;

                            }
                          },
                          hintText: "Mobile Number",isBorder: true,isPhone: true,trailingIcon:value?Icons.check_circle:null

                      );
                    }

                ),

                CustomButton( title: 'Continue', onPress: (){
                  // showCustomAlertDialog(context);
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>OTPScreen()));
                },),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    CustomText(text: "   or   "),
                    Expanded(child: Divider()),
                  ],
                ),*/
                SizedBox(height: MediaQuery.sizeOf(context).height*0.2,),
                ...List.generate(2, (index){
                  List<String> list=["Continue with Google","Continue with Facebook"];
                  return   Consumer(
                    builder:(context,ref,child){
                      print("rebuilds $index");
                      return CustomButton(
                       // color: AppThemeClass.primary,
                        isLoading: index==0?ref.watch(isLoading):ref.watch(isFacebookLogin),
                      onPress: ()async{
                        AuthRepository auth=AuthRepository();
                        if(index==0){
                          ref.watch(isLoading.notifier).state=true;
                         final result= await auth.signInWithGoogle();
                        if(context.mounted){
                          if(result==false){
                            if(context.mounted){
                              UiEventHandler.snackBarWidget(context, "Failed! Try again", );
                            }
                          }
                        }
                          ref.watch(isLoading.notifier).state=false;
                        }else{
                         AuthRepository auth=AuthRepository();
                         ref.watch(isFacebookLogin.notifier).state=true;
                         final res=await auth.signInWithFacebook();
                         if(context.mounted){
                           if(res==false){
                             if(context.mounted){
                               UiEventHandler.snackBarWidget(context, "Failed! Try again", );
                             }
                           }

                         }
                         ref.watch(isFacebookLogin.notifier).state=false;
                        }
                      },
                        isBorder: true,
                       // color: AppThemeClass.whiteText,
                        widget: Row(
                          spacing: 60,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon( index==0?Icons.login_outlined:Icons.facebook_outlined,size: 30,color: Colors.white,),
                            ),

                           /* Container(
                              margin: EdgeInsets.all(10),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(socialMediaNetworkImages[index],),)
                              ),
                            ),*/
                            CustomText(text: list[index],isBold: true,color: AppThemeClass.whiteText,fontSize: 18,)
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
