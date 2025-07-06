import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/app_theme/theme.dart';

class TermsServices extends StatelessWidget {
  const TermsServices({super.key});

  @override
  Widget build(BuildContext context) {

    List<String> subTitle=[
      "Acceptance of Terms:",
      "Use of Services:",
      "User Content:",
      "Intellectual Property:",
      "Acceptance of Terms:",
      "Use of Services:",
      "User Content:",
      "Intellectual Property:"


    ];
    List<String> subTitle2=[
      "By accessing or using TrackFit, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, you may not use TrackFit.",
      "You may use TrackFit for your personal, non-commercial use only. You may not modify, reproduce, distribute, or resell TrackFit or any content within TrackFit without our written permission.",
      "You retain ownership of any content you upload, submit, or display on TrackFit. By posting content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, and distribute your content in any form.",
      "All content, features, and functionality within TrackFit are the exclusive property of TrackFit or its licensors and are protected by copyright, trademark, and other intellectual property laws.",
      "By accessing or using TrackFit, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, you may not use TrackFit.",
      "You may use TrackFit for your personal, non-commercial use only. You may not modify, reproduce, distribute, or resell TrackFit or any content within TrackFit without our written permission.",
      "You retain ownership of any content you upload, submit, or display on TrackFit. By posting content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, and distribute your content in any form.",
      "All content, features, and functionality within TrackFit are the exclusive property of TrackFit or its licensors and are protected by copyright, trademark, and other intellectual property laws.",

    ];
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          surfaceTintColor: AppThemeClass.whiteText,
          backgroundColor: AppThemeClass.whiteText,
          leading: buildCustomBackButton(context),
          title: CustomText(text: "Terms of Services",isBold: true,fontSize: 20,),
          centerTitle: true,
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
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: subTitle.length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context,index){
                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: "${index+1}. ${subTitle[index]}",isBold: true,fontSize: 17,),
                          CustomText(text: subTitle2[index])
                        ],
                      );

                    }, separatorBuilder: (BuildContext context, int index) {
                    return Padding(padding: EdgeInsets.all(10));
                  },),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
