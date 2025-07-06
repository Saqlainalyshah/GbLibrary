import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/screens/home/view_details.dart';
import 'package:booksexchange/screens/home/view_uniform.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/post_card.dart';
import '../../components/textfield.dart';
import '../../controller/ads/native_ad.dart';
import '../../controller/providers/global_providers.dart';
import '../../utils/app_theme/theme.dart';



class UniformFeed extends ConsumerWidget {
   UniformFeed({super.key,});
final TextEditingController controller =TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Feed Portion Screen Rebuilds");
    final streamUniformPostData=ref.watch(uniformFeedProvider);
    return streamUniformPostData.when(
        data: (uniformPosts){
          if(uniformPosts.isNotEmpty){
            return CustomScrollView(
              // physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  surfaceTintColor: AppThemeClass.whiteText,
                  backgroundColor: AppThemeClass.whiteText,
                  expandedHeight: 60,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    background:   Consumer(
                      builder: (context, ref, child) {
                        return CustomTextField(
                          controller: controller,
                          hintText: "Search by location",
                          leadingIcon: Icons.search,
                          trailingIcon: Icons.close,
                          onChanged: (String search) {
                            //ref.read(filterFeedProvider.notifier).filterByLocation(search);
                          },
                          trailingFn: () {
                           /* controller.clear();
                            ref.read(filterFeedProvider.notifier).resetFilters();*/
                          },
                        );
                      },
                    ),

                  ),
                ),
                SliverToBoxAdapter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: uniformPosts.length,
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context,index){
                      // print("index");
                      return PostCard(
                        title: uniformPosts[index].isSchoolUniform=='Yes'?"Donated School Uniform":"Donated Outfits",
                        category: '',
                        grade: '',
                        isClothes: true,
                        board: uniformPosts[index].size=='S'?'Small Size':uniformPosts[index].size=='M'?'Medium Size':uniformPosts[index].size=='L'?'Large Size':'Extra Large Size',
                        time: TimeFormater.timeAgo(uniformPosts[index].createdAt.toString()),
                        description: uniformPosts[index].description,
                        location: uniformPosts[index].location,
                        type:'',
                        imageUrl: uniformPosts[index].imageUrl,
                        function: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (builder) =>  SchoolUniformScreen(clothesModel: uniformPosts[index],)),
                          );
                        },
                      );
                    }, /*separatorBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Divider(color: AppThemeClass.primary,),
                        NativeAdWidget(height: ResponsiveBox.getSize(context, 150), container: SizedBox.shrink(),),
                        Divider(color: AppThemeClass.primary,),
                      ],
                    );
                  },*/
                  ),
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
                CustomText(text: "Oops! Unknown error occurred! $error",fontSize: 18,isBold: true,color: AppThemeClass.primary,),
                CustomButton(width: 200,onPress: (){
                  //ref.invalidate(booksFeedProvider);
                },title: "Refresh",),]

          ),
        ),
        loading: ()=>Center(
          child: CircularProgressIndicator(color: AppThemeClass.primary,)),

    );
  }
}
