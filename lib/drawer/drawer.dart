import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/drawer/subscreens/privacy_policy.dart';
import 'package:booksexchange/drawer/subscreens/terms_services.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:booksexchange/screens/user_actions/my_posts.dart';
import 'package:booksexchange/screens/user_actions/profile.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/providers/global_providers.dart';
import '../screens/user_actions/user_account_delete.dart';
import '../screens/user_actions/user_logout.dart';
import 'subscreens/faq.dart';
import '../components/listtile_component.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key,});
 // final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    print("Drawer Rebuilds");
    return Drawer(
      backgroundColor: AppThemeClass.whiteText,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.15,
                    width: MediaQuery.sizeOf(context).height * 0.2,
                    decoration: BoxDecoration(
                      //  color: Colors.blue,
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/splash/splash.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  CustomText(
                    text: "GBLibrary",
                    fontSize: 15,
                    isBold: true,

                    //color: Colors.black
                  ),
                ],
              ),
            ),
            Divider(color: AppThemeClass.primary),
            Consumer(builder: (context,ref,child){
              List<String> list=['Profile','My Posts'];
              final user=ref.watch(userProfileProvider);
              if(user!=null){
                return ListView.builder(
                  shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context,index){
                  return CustomListTile(
                    onTap: () async{
                      //Navigator.pop(context);
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (builder) => Profile()),
                        );
                      } else  {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (builder) => MyPosts()),
                        );
                      }
                    },
                    leadingIconColor: index == 0
                        ? Colors.teal
                        : Colors.redAccent,
                    title: list[index],
                    leadingIcon: index == 0
                        ? Icons.person_pin
                        : Icons.post_add,
                  );
                });
              }else{
                return SizedBox.shrink();
              }
            }),
            ...List.generate(6, (index) {
              List<String> list1 = [
                "Account & Security",
                "FAQ",
                "Privacy Policy",
                "Terms of Services",
                "Share",
                "Logout",
              ];
              return CustomListTile(
                onTap: () async{
                  //Navigator.pop(context);
                  if  (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => AccountSecurity(),
                      ),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => FAQScreen()),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => PrivacyPolicy()),
                    );
                  } else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => TermsServices()),
                    );
                  }else if (index == 4) {
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => TermsServices()),
                    );*/
                  }
                  else {
                    showLogout(context);
                  }
                },
                leadingIconColor: index == 0
                    ? Colors.green
                    : index == 1
                    ? Colors.blueAccent
                    : index == 2
                    ? Colors.pinkAccent
                    : index == 3
                    ? Colors.deepPurple
                    : index == 4
                    ? Colors.orange
                    : Colors.red,

                title: list1[index],
                leadingIcon: index == 0
                    ? Icons.lock_clock
                    : index == 1
                    ? Icons.question_answer_outlined
                    : index == 2
                    ?Icons.privacy_tip
                    : index == 3
                    ?  Icons.help
                    : index == 4
                    ? Icons.share
                    : Icons.logout,
              );
            }),
          ],
        ),
      ),
    );
  }
}
