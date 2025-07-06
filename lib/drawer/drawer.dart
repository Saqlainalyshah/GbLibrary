import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/drawer/subscreens/privacy_policy.dart';
import 'package:booksexchange/drawer/subscreens/terms_services.dart';
import 'package:booksexchange/screens/user_actions/my_posts.dart';
import 'package:booksexchange/screens/user_actions/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/cards/listTile_card.dart';
import '../controller/authentication/auth_repository.dart';
import '../controller/providers/global_providers.dart';
import '../screens/user_actions/user_account_delete.dart';
import '../utils/app_theme/theme.dart';
import 'subscreens/faq.dart';
import '../components/listtile_component.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key,});
 // final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    print("Drawer Rebuilds");
    final screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: AppThemeClass.whiteText,
      child: Container(
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Content (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    // user info
                    Consumer(builder: (context, ref, child) {
                      final user = ref.watch(userProfileProvider);
                      if (user != null) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTileCard(
                            backgroundColor: AppThemeClass.primary,
                            title: user.name,
                            subTitle: 'Member Since ${TimeFormater.formatIsoDate(user.createdAt.toString())}',
                            imageUrl: user.profilePicUrl,
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                    Divider(color: AppThemeClass.primary),

                    // Profile and My Posts
                    Consumer(builder: (context, ref, child) {
                      List<String> list = ['Profile', 'My Posts'];
                      final user = ref.watch(userProfileProvider);
                      if (user != null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return CustomListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => index == 0 ? Profile() : MyPosts(),
                                  ),
                                );
                              },
                              leadingIconColor: index == 0 ? Colors.teal : Colors.redAccent,
                              title: list[index],
                              leadingIcon: index == 0 ? Icons.person_pin : Icons.post_add,
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),

                    // Other options
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
                        onTap: () async {
                          if (index == 0) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AccountSecurity()));
                          } else if (index == 1) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => FAQScreen()));
                          } else if (index == 2) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyPolicy()));
                          } else if (index == 3) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => TermsServices()));
                          } else if (index == 4) {
                            // Implement share logic
                          } else {
                            UiEventHandler.customAlertDialog(
                              context,
                              "Are you sure you want to logout?",
                              "",
                              "Logout",
                              "Cancel",
                                  () async {
                                Navigator.pop(context);
                                AuthRepository auth = AuthRepository();
                                await auth.signOut();
                              },
                              false,
                            );
                          }
                        },
                        leadingIconColor: [
                          Colors.green,
                          Colors.blueAccent,
                          Colors.pinkAccent,
                          Colors.deepPurple,
                          Colors.orange,
                          Colors.red
                        ][index],
                        title: list1[index],
                        leadingIcon: [
                          Icons.lock_clock,
                          Icons.question_answer_outlined,
                          Icons.privacy_tip,
                          Icons.help,
                          Icons.share,
                          Icons.logout
                        ][index],
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Sticky Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
             // color: AppThemeClass.primary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Made with ❤️ in Gilgit Baltistan",
                    color: AppThemeClass.darkText,
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    text: "© 2025 Gilgit Swap. All rights reserved.",
                    color: AppThemeClass.darkText,
                     // Optional: smaller font
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class AccountSection extends StatefulWidget {
  const AccountSection({super.key});

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top Content (scrollable)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user info
                Consumer(builder: (context, ref, child) {
                  final user = ref.watch(userProfileProvider);
                  if (user != null) {
                   return Column(
                     children: [
                    Padding(
                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTileCard(
                 // backgroundColor: AppThemeClass.primary,
                  title: user.name,
                  subTitle: 'Member Since ${TimeFormater.formatIsoDate(user.createdAt.toString())}',
                  imageUrl: user.profilePicUrl,
                  ),
                  ),
                       Divider(color: AppThemeClass.primary),
                     ...List.generate(2, (index){
                       List<String> list = ['Profile', 'My Posts'];
                       return CustomListTile(
                         onTap: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (builder) => index == 0 ? Profile() : MyPosts(),
                             ),
                           );
                         },
                         leadingIconColor: index == 0 ? Colors.teal : Colors.redAccent,
                         title: list[index],
                         leadingIcon: index == 0 ? Icons.person_pin : Icons.post_add,
                       );
                     }),
                     ],
                   );
                  } else {
                    return SizedBox.shrink();
                  }
                }),


                // Other options
                ...List.generate(6, (index) {
                  List<String> list1 = [
                    "Account & Security",
                    "FAQ",
                    "Privacy Policy",
                    "Terms of Services",
                    "Share",
                    "Logout",
                  ];
                  return Consumer(
                    builder:(context,ref,child) =>CustomListTile(
                      onTap: () async {
                        if (index == 0) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => AccountSecurity()));
                        } else if (index == 1) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => FAQScreen()));
                        } else if (index == 2) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyPolicy()));
                        } else if (index == 3) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TermsServices()));
                        } else if (index == 4) {
                          final themeNotifier = ref.read(themeNotifierProvider.notifier);
                          themeNotifier.toggleTheme();

                          // Implement share logic
                        } else {
                          UiEventHandler.customAlertDialog(
                            context,
                            "Are you sure you want to logout?",
                            "",
                            "Logout",
                            "Cancel",
                                () async {
                              Navigator.pop(context);
                              AuthRepository auth = AuthRepository();
                              await auth.signOut();
                            },
                            false,
                          );
                        }
                      },
                      leadingIconColor: [
                        Colors.green,
                        Colors.blueAccent,
                        Colors.pinkAccent,
                        Colors.deepPurple,
                        Colors.orange,
                        Colors.red
                      ][index],
                      title: list1[index],
                      leadingIcon: [
                        Icons.lock_clock,
                        Icons.question_answer_outlined,
                        Icons.privacy_tip,
                        Icons.help,
                        Icons.share,
                        Icons.logout
                      ][index],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Sticky Footer
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          // color: AppThemeClass.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: " Made with ❤️ in Gilgit Baltistan",
               // color: AppThemeClass.darkText,
                fontSize: 10,
              ),
              SizedBox(height: 8),
              CustomText(
                text: "© 2025 Gilgit Swap. All rights reserved.",
               // color: AppThemeClass.darkText,
                fontSize: 10,
                // Optional: smaller font
              ),
            ],
          ),
        ),
      ],
    );
  }
}
