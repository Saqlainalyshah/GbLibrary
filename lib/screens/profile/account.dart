import 'package:booksexchange/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import '../../components/text_widget.dart';
import '../../drawer/account_security/account_security.dart';
import '../../drawer/listtile_component.dart';
import '../../drawer/logout.dart';
import '../help_support/faq.dart';
import '../help_support/privacy_policy.dart';
import '../help_support/terms_services.dart';
import '../postview/my_posts.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Center(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.15,
                    width: MediaQuery.sizeOf(context).height * 0.2,
                    decoration: BoxDecoration(
                      //  color: Colors.blue,
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage("assets/splash/splash.png",),fit: BoxFit.cover)
                    ),
                  ),
                  CustomText(text:
                  "GBLibrary",
                    fontSize: 15,
                    isBold: true,
                    //color: Colors.black

                  )
                ],
              ),
            ),

            Divider(color: Theme.of(context).dividerColor),
            ...List.generate(8, (index) {
              List<String> list1 = [
                "Profile",
                "My Posts",
                "Account & Security",
                "FAQ",
                "Privacy Policy",
                "Terms of Services",
                "Share",
                "Logout",
              ];
              return CustomListTile(
                onTap: () {
                  //Navigator.pop(context);
                  if(index==0){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>Profile()));
                  }else if(index==1){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>MyPosts()));
                  }
                  else if(index==2){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>AccountSecurity()));
                  }

                  else if(index==3){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>FAQScreen()));
                  }else if(index==4){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>PrivacyPolicy()));
                  }
                  else if(index==5){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>TermsServices()));
                  }else if(index==7){
                    showLogout(context);
                  }
                },
                leadingIconColor: index == 0
                    ? Colors.teal
                    : index == 1
                    ? Colors.redAccent
                    : index == 2
                    ? Colors.green
                    : index == 3
                    ? Colors.blueAccent
                    : index == 4
                    ? Colors.pinkAccent
                    : index == 5
                    ? Colors.deepPurple
                    : index == 6
                    ? Colors.orange
                    : Colors.red,


                title: list1[index],
                leadingIcon:
                index == 0?Icons.person_pin:
                index == 1
                    ? Icons.post_add
                    : index == 2
                    ? Icons.lock_clock:
                index==3?
                Icons.question_answer_outlined:
                index==4?Icons.privacy_tip:
                index==5?Icons.help:
                index==6?Icons.share:
                Icons.logout
                ,
              );
            }),
          ],
        ),
      ),
    ));
  }
}
