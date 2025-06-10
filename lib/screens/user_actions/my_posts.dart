import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/user_actions/post_books.dart';
import 'package:flutter/material.dart';
import '../../utils/fontsize/app_theme/theme.dart';
class MyPosts extends StatelessWidget {
  const MyPosts({super.key});
//final _index= StateProvider.autoDispose<int>((ref)=>0);
  @override
  Widget build(BuildContext context) {
    print("MyPosts rebuild");
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
           surfaceTintColor: Colors.transparent,
           leading: buildCustomBackButton(context),
            title: CustomText(text: "My Posts",isBold: true,fontSize: 20,),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.6
            ),
                itemBuilder: (context,index){
              return const GridItem();
                }

            ),
          ),
    ));
  }
}

class GridItem extends StatelessWidget {
  const GridItem({super.key});
  @override
  Widget build(BuildContext context) {
      return Container(
        //height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
        decoration: BoxDecoration(
         // color: AppThemeClass.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppThemeClass.primary,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(

              child: Image.asset(
                width: double.infinity,
                "assets/images/uniform.png",
                fit: BoxFit.cover,
                //width: double.infinity,
              ),
            ),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [
             CustomText(text: "I want to exchange books", isGoogleFont: true,isBold: true,fontSize: 13,maxLines: 2,),
             Flexible(
               child: CustomText(
                 text: "I have some 10 class books which I want to exchange. Is anyone here?",
                 fontSize: 10,
                 maxLines: 2,
                 isGoogleFont: true,
               ),
             ),
             OutlinedButton(
               style: OutlinedButton.styleFrom(
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(8),
                 ),
                 backgroundColor: AppThemeClass.primary,
                 side: BorderSide(width: 1, color: AppThemeClass.primary),
               ),
               onPressed: () {
                 Navigator.push(context,MaterialPageRoute(builder: (builder)=> PostBooks(isEdit: true,)));
               },
               child: CustomText(
                 text: "Edit",
                 isBold: true,
                 color: AppThemeClass.whiteText,
               ),
             ),
           ],
         )
          ],
        ),
      );
    }
}
