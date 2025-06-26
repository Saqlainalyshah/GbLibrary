import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/screens/home/view_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/post_card.dart';
import '../../controller/providers/global_providers.dart';
import '../../utils/fontsize/app_theme/theme.dart';



class FeedPortion extends ConsumerWidget {
   const FeedPortion({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Feed Portion Screen Rebuilds");
    final streamBooksPostData=ref.watch(booksFeedProvider);
   return streamBooksPostData.when(
        data: (bookPosts){
          if(bookPosts.isNotEmpty){
            return CustomScrollView(
              // physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bookPosts.length,
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context,index){
                     // print("index");
                      final type=bookPosts[index].category;
                      return PostCard(
                        title: type=="Exchange"? "I want to ${bookPosts[index].category} ${bookPosts[index].grade} Books":'I am donating ${bookPosts[index].grade} Books',
                        category: bookPosts[index].category,
                        grade: bookPosts[index].grade,
                        board: bookPosts[index].board,
                        time: TimeFormater.timeAgo(bookPosts[index].createdAt.toString()),
                        description: bookPosts[index].description,
                        location: bookPosts[index].location,
                        type:bookPosts[index].type,
                        imageUrl: bookPosts[index].imageUrl,
                        function: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (builder) => ViewDetails(booksModel: bookPosts[index],)),
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
            return Center(
              child:CustomText(text: "No Data Found!",fontSize: 18,isBold: true,color: AppThemeClass.primary,),
            );
          }
        },
        error: (error,track)=>Center(
          child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.wifi_off,size: 50,color: AppThemeClass.primary,),
                CustomText(text: "Oops! Unknown error occurred!",fontSize: 18,isBold: true,color: AppThemeClass.primary,),
                CustomButton(width: 200,onPress: (){
                  ref.invalidate(booksFeedProvider);
                },title: "Refresh",),]

          ),
        ),
        loading: ()=>Center(
          child:  CustomText(text: "Loading....!",fontSize: 15,isBold: true,color: AppThemeClass.primary,),
        )
    );
  }
}
