import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/cards/post_card.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/chat/chat.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';

class ViewDetails extends StatelessWidget {
   ViewDetails({super.key,required this.booksModel});
   final BooksModel booksModel;
  final List<String> subjects = [
    "English",
    "Urdu",
    "Science",
    "Computer Science",
    "Pak-Studies",
    "Biology",
    "Physics",
    "Maths",
    "Chemistry",
    "Other"
  ];
  @override
  Widget build(BuildContext context) {
    print("View Details Screen builds");
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: buildCustomBackButton(context)
          ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    height: MediaQuery.of(context).size.height*0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppThemeClass.primary, width: .5)
                    ),
                    child: Image.network(booksModel.imageUrl,fit: BoxFit.cover,),
                  ),
                  CustomText(text: "Description",isBold: true,),
                  buildIconTextRow(context, Icons.access_time, '2 days ago ',true),
                  CustomText(text: booksModel.description,fontSize: 14,),
                  CustomText(text: "Total Subjects",isBold: true,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:Border.all(
                            color: AppThemeClass.primary,
                            width: 1.0
                        )
                    ),
                    child: Wrap(
                      spacing: 5.0,
                      children: booksModel.subjects.map((buttonText) {
                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width:  1,
                                color: AppThemeClass.primary
                            ),
                          ),
                          onPressed: () {
                          },
                          child: CustomText(text:
                            buttonText,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  buildIconTextRow(context, Icons.house_outlined, booksModel.board,true),
                  buildIconTextRow(context, Icons.location_on, booksModel.location,true),
                ],
              ),
            )),
            Container(
              height: 80,
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 50,
                  children: [
                    Expanded(child: CustomButton(onPress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChatScreen()));
                    },widget: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Icon(Icons.chat,color: AppThemeClass.whiteText,size: 25,),CustomText(text: "Chat",color: AppThemeClass.whiteText,isBold: true,fontSize: 15,)],),)),
                    Expanded(child: CustomButton(onPress: (){},widget: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Icon(Icons.call,color: AppThemeClass.whiteText,size: 25,),CustomText(text: "Call",color: AppThemeClass.whiteText,isBold: true,fontSize: 15,)],),)),
                  ],),

            ),

          ],
        ),
      ),

    ));
  }
}
