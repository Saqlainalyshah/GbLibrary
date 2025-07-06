
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/ads/banner_ad.dart';
import 'package:booksexchange/screens/home/feed_portion.dart';
import 'package:booksexchange/screens/home/uniform_feed.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/firebase_crud_operations/fetch_data/fetch_books.dart';
import '../../controller/providers/global_providers.dart';
import '../../drawer/drawer.dart';
import '../../utils/app_theme/theme.dart';
import '../chat/chat.dart';
import '../home/post_item.dart';


final _bottomNavigationIndex=StateProvider.autoDispose<int>((ref)=>0);


class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends ConsumerState<MainScreen> {

  // final UserProfile userProfile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(myBooksPosts);
    ref.read(userProfileProvider.notifier).fetchUser(widget.id);
    ref.read(myClothesPosts);
    ref.read(uniformFeedProvider);
  }


  final List<Widget> screens=  [
     FeedPortion(),
    //BooksPage(),
    UniformFeed(),
    const PostItem(),
    const ChatScreen(),
    AccountSection()
     //InferencePage(),
  ];

  @override
  Widget build(BuildContext context) {
    print("Top screen");
    return SafeArea(
      top: false,
      child: Scaffold(
        //backgroundColor: Colors.black,
       // drawerScrimColor: AppThemeClass.primary,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppThemeClass.primary),
          backgroundColor: Colors.transparent,
         // automaticallyImplyLeading: false,
          //centerTitle: true,
          title: BannerAdWidget()
        ),
       // drawer: const DrawerWidget(),
        body: Consumer(
          builder:(context,ref,child)=> IndexedStack(
            index: ref.watch(_bottomNavigationIndex),
            children: screens,
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.zero,
          //height: 100,
          decoration: BoxDecoration(
           // color: AppThemeClass.whiteText, // Match your bottom bar background
            boxShadow: [
              BoxShadow(
                color: AppThemeClass.primary.withOpacity(0.5), // or any subtle shadow color
                blurRadius: 5,
                offset: const Offset(0, -1), // Shadow appears above the bar
              ),
            ],
          ),
          child: BottomAppBar(
           //padding: EdgeInsets.zero,
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
           // shadowColor: AppThemeClass.primary

            //elevation: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavItem(Icons.home, 'Books', 0),
                  _buildNavItem(Icons.card_giftcard, 'Clothes', 1),
                  _buildNavItem(Icons.add_circle, 'Posts', 2),
                  //SizedBox(width: 10), // Space for the FAB
                 Stack(
                   alignment: Alignment.topRight,
                   //fit: StackFit.loose,
                   children: [
                     _buildNavItem(Icons.message, 'Messages', 3),
                     Consumer(builder: (context,ref,child){
                      final messages= ref.watch(filterChatProvider.select((state)=>state.unreadMessageCount));
                      if(messages>0){
                        return Positioned(
                          bottom: ResponsiveBox.getSize(context, 25),
                          right: ResponsiveBox.getSize(context, 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red

                            ),
                            child: CustomText(text: messages.toString(),color: AppThemeClass.whiteText,),
                          ),
                        );
                      }else{
                        return SizedBox.shrink();
                      }
                     })
                   ],
                 ),
                  _buildNavItem(Icons.person_outline, 'Account', 4),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
  Widget _buildNavItem(IconData? icon, String label, int index) {
   return Consumer(builder: (context,ref,child){
     final isDark = Theme.of(context).brightness == Brightness.dark;

     print("Rebuilds $index");
     final isSelected = ref.watch(_bottomNavigationIndex) == index;
     if(index==2){
       return  GestureDetector(
         onTap: () =>ref
             .read(_bottomNavigationIndex.notifier)
             .state = index,
         child: Container(
           height: ResponsiveBox.getSize(context, 60),
           width:  ResponsiveBox.getSize(context, 60),

           decoration: BoxDecoration(
             shape: BoxShape.circle,
             color:  AppThemeClass.primary,
           ),
           child: Consumer(
               builder:(context,ref,child)=>Icon(Icons.add,size: ResponsiveBox.getSize(context, 50),color: AppThemeClass.whiteText,)
           ),
         ),
       );
     }else {
       print("Rebuilds");
       return GestureDetector(
         onTap: () =>
         ref
             .read(_bottomNavigationIndex.notifier)
             .state = index,
         child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Icon(icon, color: isSelected ? AppThemeClass.primary : isDark? AppThemeClass.whiteText:AppThemeClass
                 .darkTextOptional,
               size: ResponsiveBox.getSize(context, 30),
             ),
             CustomText(text: label,
               color: isSelected ? AppThemeClass.primary : isDark? AppThemeClass.whiteText:Colors.black54,
             ),
           ],
         ),
       );
     }
   });
  }
}


