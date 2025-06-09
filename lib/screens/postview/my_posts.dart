import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/home/create_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          appBar: AppBar(
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
              childAspectRatio: 0.7
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
         // color: AppThemeClass.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppThemeClass.primary,
          ),
        ),
        child: Column(
         // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Image.asset(
                "assets/images/uniform.png",
                fit: BoxFit.contain,
                //width: double.infinity,
              ),
            ),
         Flexible(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               CustomText(text: "I want to exchange books", isBold: true),
               Flexible(
                 child: CustomText(
                   text: "I have some 10 class books which I want to exchange. Is anyone here?",
                   maxLines: 2,
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
                   Navigator.push(context,MaterialPageRoute(builder: (builder)=> CreatePost()));
                 },
                 child: CustomText(
                   text: "Edit",
                   isBold: true,
                   color: AppThemeClass.whiteText,
                 ),
               ),
             ],
           ),
         )
          ],
        ),
      );
    }
}
