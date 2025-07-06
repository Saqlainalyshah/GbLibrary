import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/providers/global_providers.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/home/image_view.dart';
import 'package:booksexchange/screens/user_actions/post_books.dart';
import 'package:booksexchange/screens/user_actions/post_uniform_clothes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme/theme.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/providers/global_providers.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPosts extends ConsumerStatefulWidget {
  const MyPosts({super.key});

  @override
  ConsumerState<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends ConsumerState<MyPosts> {
  @override
  void initState() {
    super.initState();
    ref.read(myBooksPosts);
    // You can fetch clothes posts too if needed
     ref.read(myClothesPosts);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: buildCustomBackButton(context),
            title: const CustomText(
              text: "My Posts",
              isBold: true,
              fontSize: 20,
            ),
            bottom: const TabBar(
              labelColor: Colors.black,
              indicatorColor: AppThemeClass.primary,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: "Books"),
                Tab(text: "Clothes"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              /// Tab 1: Books
              Consumer(builder: (context, ref, _) {
                final myPosts = ref.watch(myBooksPosts);
                return myPosts.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(
                          child: CustomText(
                              text: "No Book Posts",
                              isGoogleFont: true,
                              isBold: true));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, index) {
                          final book = data[index];
                          return GridItem(title: 'I want to ${book.category} ${book.grade} Books',
                            description: book.description, imageUrl: book.imageUrl, function: (){
                              ref.read(bookSubjectsList.notifier).state= book.subjects;
                              ref.read(bookCategory.notifier).state= book.category;
                              ref.read(bookGrade.notifier).state= book.grade;
                              ref.read(bookBoard.notifier).state= book.board;
                              Navigator.push(context,MaterialPageRoute(builder: (builder)=> PostBooks(isEdit: true,booksModel:  book,)));
                            },);
                        },
                      ),
                    );
                  },
                  error: (error, _) => Center(
                      child: CustomText(
                          text: "Error: $error",
                          isGoogleFont: true,
                          isBold: true)),
                  loading: () => const Center(
                      child: CircularProgressIndicator(
                          color: AppThemeClass.primary)),
                );
              }),

              /// Tab 2: Clothes (Placeholder or another provider)
              Consumer(builder: (context, ref, _) {
                final myPosts = ref.watch(myClothesPosts);
                return myPosts.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(
                          child: CustomText(
                              text: "No Clothes Posts",
                              isGoogleFont: true,
                              isBold: true));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, index) {
                          final post = data[index];
                          bool isTrue=post.isSchoolUniform=='Yes';
                          return GridItem(  title: isTrue?'Donated School Uniform':'Donated Clothes', description: post.description,
                            imageUrl: post.imageUrl, function: (){
                              ref.read(uniformSize.notifier).state= post.size;
                              ref.read(isSchoolUniform.notifier).state=  post.isSchoolUniform;
                              Navigator.push(context,MaterialPageRoute(builder: (builder)=> UniformClothesScreen(isEdit: true,clothesModel:  post,)));
                            },);
                        },
                      ),
                    );
                  },
                  error: (error, _) => Center(
                      child: CustomText(
                          text: "Error: $error",
                          isGoogleFont: true,
                          isBold: true)),
                  loading: () => const Center(
                      child: CircularProgressIndicator(
                          color: AppThemeClass.primary)),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.function
  });
final String title;
final String description;
final String imageUrl;
final Function function;

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
              child:  GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>ImageView(url:  imageUrl)));
                },
                child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: imageUrl,width: double.infinity,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          //margin: const EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: AppThemeClass.primary
                          ),
                        ),
                      ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                ),
              ),
            ),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [
             CustomText(text: title, isGoogleFont: true,isBold: true,fontSize: 13,maxLines: 2,),
             Flexible(
               child: CustomText(
                 text: description,
                 fontSize: 10,
                 maxLines: 2,
                 isGoogleFont: true,
               ),
             ),
             Consumer(
               builder:(context,ref,child)=> OutlinedButton(
                 style: OutlinedButton.styleFrom(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8),
                   ),
                   backgroundColor: AppThemeClass.primary,
                   side: BorderSide(width: 1, color: AppThemeClass.primary),
                 ),
                 onPressed: () {
                function();
                 },
                 child: CustomText(
                   text: "Edit",
                   isBold: true,
                   color: AppThemeClass.whiteText,
                 ),
               ),
             ),
           ],
         )
          ],
        ),
      );
    }
}
