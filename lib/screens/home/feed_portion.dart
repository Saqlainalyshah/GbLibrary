import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/firebase_crud_operations/user_profile_crud.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/home/view_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/post_card.dart';
import '../../utils/fontsize/app_theme/theme.dart';

final _booksFeedProvider = StreamProvider.autoDispose.family<
    QuerySnapshot<Map<String, dynamic>>, String>((ref, collectionName) {
  return FirebaseFirestore.instance.collection(collectionName).snapshots();
});

class FeedPortion extends ConsumerWidget {
   FeedPortion({super.key});
  final TextEditingController searchController=TextEditingController();

  final List<String> bookExchangeMessages = [
    "I'm looking to exchange my books and find someone interested in purchasing them. If you're near Gilgit and need study materials, feel free to message me. The books are in great condition, covering different subjects for various classes. Prices are negotiable, and I'm happy to discuss any trade options too. Let’s connect if you're interested!",
    "Looking to exchange my old textbooks. Anyone near Gilgit interested? DM me!Want to sell my used books. Prices negotiable. Message me if you're in the Gilgit area.",
    "Need someone to exchange books with! If you're near Gilgit, let's trade. DM me.",
    "Selling study guides and reference books. If interested, drop me a message. Near Gilgit.",
    "I have Class 10 books available for exchange. DM me if you need them! Located near Gilgit.",
    "Clearing out my bookshelf! Selling novels and academic books. DM me if you're around Gilgit.",
    "Looking for a book swap! If you're near Gilgit and have something to trade, let's connect.",
    "Selling my exam preparation books. In great condition. DM me if you're near Gilgit!",
    "Want to trade my old books for new ones. Anyone in Gilgit interested? DM me!"
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamBooksPostData=ref.watch(_booksFeedProvider('posts'));
   return streamBooksPostData.when(
        data: (posts){
          if(posts.docs.isNotEmpty){
            final data=posts.docs;

            List<BooksModel> list=data.map((document)=>BooksModel.fromJson(document.data())).toList();
            return CustomScrollView(
              // physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context,index){
                      print("index");
                      return PostCard(
                        category: list[index].category,
                        grade: list[index].grade,
                        board: list[index].board,
                        time: ' 2 minutes ago',
                        description: list[index].description,
                        location: list[index].location,
                        type:list[index].type,
                        imageUrl: list[index].imageUrl,
                        function: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (builder) => ViewDetails(booksModel: list[index],)),
                          );
                        },
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: AppThemeClass.primary,);
                  },),
                ),
              ],
            );
          }else{
            return SafeArea(
              top: false,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.wifi_off,size: 50,color: AppThemeClass.primary,),
                        CustomText(text: "Oops! Something went wrong!",fontSize: 18,isBold: true,color: AppThemeClass.primary,),
                        CustomButton(width: 200,onPress: (){
                          ref.invalidate(_booksFeedProvider);
                        },title: "Refresh",),

                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
        error: (error,track)=>SafeArea(
          top: false,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Icon(Icons.wifi_off,size: 50,color: AppThemeClass.primary,),
                CustomText(text: "Oops! Unknown error occurred!",fontSize: 18,isBold: true,color: AppThemeClass.primary,),
                CustomButton(width: 200,onPress: (){
                  ref.invalidate(_booksFeedProvider);
                },title: "Refresh",),]

              ),
              ),
            ),
          ),
        ),
        loading: ()=>SafeArea(
          top: false,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                 // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Loading....!",fontSize: 15,isBold: true,color: AppThemeClass.primary,),
                   CircularProgressIndicator(color: AppThemeClass.primary,),

                  ],
                ),
              ),
            ),
          ),
        )

    );
  }
}
