
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> l=[
      "Information Collection and Use:",
      "Data Sharing and Disclosure:",
      "Data Sharing and Disclosure:",
      "Information Collection and Use:",
      "Data Sharing and Disclosure:",
      "Data Sharing and Disclosure:",
      "Information Collection and Use:",
      "Data Sharing and Disclosure:",
      "Data Sharing and Disclosure:",
    ];
    List<String> subTitle=[
      "We collect personal information such as name, email address, age, gender, height, weight, and fitness data (e.g., step count, activity duration) to provide and improve our services.",
      "Your information is used to personalize your experience, track your fitness activity, provide insights and recommendations, and communicate with you about our services.",

    ];
    List<String> subTitle2=[
      "We do not sell, rent, or share your personal information with third parties for marketing purposes.",
      "We may share your information with service providers who assist us in providing our services, but they are contractually obligated to protect your information.",
      "We may also share aggregated or anonymized data for research or analytical purposes."

    ];
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          backgroundColor: AppThemeClass.whiteText,
          surfaceTintColor: AppThemeClass.whiteText,
          leading: buildCustomBackButton(context),
          title: CustomText(text: "Privacy Policy",isBold: true,fontSize: 20,),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomText(text: "Effective Date: December 19, 2024",isBold: true,fontSize: 17,),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: RawScrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  radius: Radius.circular(10),
                  trackRadius: Radius.circular(40),
                  thumbColor: AppThemeClass.whiteText,
                  trackColor: Colors.grey.shade300,
                  trackBorderColor: Colors.transparent,
                  thickness: 4.0,
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: l.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        List<String> lists=[];
                        if(index==0){
                          lists=subTitle;
                        }else{
                          lists=subTitle2;
                        }
                        List<List> subList=[subTitle,subTitle2,];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: "${index+1} . ${l[index]}",isBold: true,fontSize: 17,),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: lists.length,
                                itemBuilder: (context,subIndex){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(height: 3,width: 3,decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle),
                                          ),
                                        ),
                                        Expanded(child: CustomText(text: lists[subIndex]))
                                      ],
                                    ),
                                  );
                                })
                          ],
                        );

                      }),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
