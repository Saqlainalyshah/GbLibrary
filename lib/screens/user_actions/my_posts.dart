import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/providers/global_providers.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/user_actions/post_books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/fontsize/app_theme/theme.dart';
class MyPosts extends ConsumerStatefulWidget {
  const MyPosts({super.key});

  @override
  ConsumerState<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends ConsumerState<MyPosts> {
//final _index= StateProvider.autoDispose<int>((ref)=>0);

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(myBooksPosts);
  }
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
          body:   Consumer(builder: (context,ref,child){
            final myPosts=ref.watch(myBooksPosts);
          return  myPosts.when(data: (data){
            if(data.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.6
                    ),
                    itemBuilder: (context,index){
                      final post=data[index];
                      return  GridItem(booksModel: post,);
                    }

                ),
              );
            }else{
              return Center(child: CustomText(text: "No Posts",isGoogleFont: true,isBold: true,),);
            }
          },
              error: (error,track){
                return Center(child: CustomText(text: "Error: $error",isGoogleFont: true,isBold: true,),);
              },
              loading: ()=>Center(child: CircularProgressIndicator(color: AppThemeClass.primary,),)
          );
          }),
    ));
  }
}

class GridItem extends StatelessWidget {
  const GridItem({super.key,required this.booksModel});

  final BooksModel booksModel;
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
                booksModel.imageUrl,
                fit: BoxFit.cover,
                //width: double.infinity,
              ),
            ),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [
             CustomText(text: "I want to ${booksModel.category} books", isGoogleFont: true,isBold: true,fontSize: 13,maxLines: 2,),
             Flexible(
               child: CustomText(
                 text: booksModel.description,
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
                 Navigator.push(context,MaterialPageRoute(builder: (builder)=> PostBooks(isEdit: true,booksModel: booksModel,)));
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
