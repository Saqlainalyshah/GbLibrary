import 'package:flutter/material.dart';
import '../../components/cards/post_card.dart';
import '../../utils/fontsize/app_theme/theme.dart';

class FeedPortion extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return CustomScrollView(
      // physics: BouncingScrollPhysics(),
      slivers: [
       /* SliverAppBar(
          expandedHeight: 100,
          toolbarHeight: MediaQuery.sizeOf(context).height*0.01,
          //stretch: true,
          pinned: true,
          backgroundColor: AppThemeClass.whiteText,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // CustomText(text: 'Exchange Books',fontSize: 20,isBold: true,color: AppThemeClass.darkText,),
                  CustomTextField(controller: searchController,isBorder: true,leadingIcon: Icons.search,hintText: 'Search',trailingIcon: Icons.clear,)
                ],
              ),
            ),
          ),
        ),*/

        SliverToBoxAdapter(
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: bookExchangeMessages.length,
            padding: EdgeInsets.all(5),
            itemBuilder: (context,index){
              print("index");
              return PostCard(title: '${index+1}th' , board: 'Kiu Board', time: ' 2 minutes ago', description: bookExchangeMessages[index], location: 'Jutial,Gilgit', type: "Exchange", imageUrl: 'Nope',);
            }, separatorBuilder: (BuildContext context, int index) {
            return Divider(color: AppThemeClass.primary,);
          },),
        ),
      ],
    );
  }
}
