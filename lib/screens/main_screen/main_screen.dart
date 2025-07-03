
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/ads/banner_ad.dart';
import 'package:booksexchange/screens/home/feed_portion.dart';
import 'package:booksexchange/screens/home/uniform_feed.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/providers/global_providers.dart';
import '../../drawer/drawer.dart';
import '../../utils/fontsize/app_theme/theme.dart';
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
    ref.read(getUserDocument);
  
    ref.read(myBooksPosts);
    ref.read(myClothesPosts);
    ref.read(uniformFeedProvider);
  }


  final List<Widget> screens=  [
     FeedPortion(),
    const UniformFeed(),
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
        backgroundColor: AppThemeClass.whiteText,
       // drawerScrimColor: AppThemeClass.primary,
        appBar: AppBar(
          surfaceTintColor: AppThemeClass.whiteText,
          iconTheme: IconThemeData(color: AppThemeClass.primary),
          backgroundColor: Colors.transparent,
         // automaticallyImplyLeading: false,
          centerTitle: true,
          title: CustomText(text: "Gilgit Swap"),

        ),
        drawer: const DrawerWidget(),
        body: Consumer(
          builder:(context,ref,child)=> IndexedStack(
            index: ref.watch(_bottomNavigationIndex),
            children: screens,
          ),
        ),
        /*floatingActionButton: FloatingActionButton(backgroundColor: AppThemeClass.whiteText,elevation:0,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),onPressed: (){},
        child: Icon(Icons.add_circle,color: AppThemeClass.primary,size: 60,),

        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar:  Container(
          padding: EdgeInsets.zero,
          //height: 100,
          decoration: BoxDecoration(
            color: AppThemeClass.whiteText, // Match your bottom bar background
            boxShadow: [
              BoxShadow(
                color: AppThemeClass.primary.withOpacity(0.5), // or any subtle shadow color
                blurRadius: 5,
                offset: const Offset(0, -1), // Shadow appears above the bar
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Row(
               spacing: 30,
               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Icon(Icons.home),
                     CustomText(text: 'Books'),
                   ],
                 ),
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Icon(Icons.card_giftcard),
                     CustomText(text: 'Clothes'),
                   ],
                 ),
               ],
             ),

              Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat),
                      CustomText(text: 'Chat'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person),
                      CustomText(text: 'profile'),
                    ],
                  )
                ],
              )
            ],
          ),
        ),*/
      /*  floatingActionButton: Container(
          height: 70,
          width: 70,
          child: Consumer(
            builder:(context,ref,child)=> FloatingActionButton(
              onPressed: () {
             ref.read(_bottomNavigationIndex.notifier).state=2;
                // Handle central button press
              },
              backgroundColor: AppThemeClass.primary ,
              elevation: 4,
              shape: CircleBorder(),
              child: Icon(Icons.add, size: 50),
            ),
          ),
        ),*/
       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: AppThemeClass.whiteText,
          color: AppThemeClass.whiteText,
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavItem(Icons.home, 'Books', 0),
                _buildNavItem(Icons.card_giftcard, 'Clothes', 1),
                _buildNavItem(Icons.add_circle, 'Posts', 2),
                //SizedBox(width: 10), // Space for the FAB
                _buildNavItem(Icons.message, 'Messages', 3),
                _buildNavItem(Icons.person_outline, 'Account', 4),
              ],
            ),
          ),
        ),

      ),
    );
  }
  Widget _buildNavItem(IconData? icon, String label, int index) {
   return Consumer(builder: (context,ref,child){
     print("Rebuilds");
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
           // mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Icon(icon, color: isSelected ? AppThemeClass.primary : AppThemeClass
                 .darkTextOptional,
               size: ResponsiveBox.getSize(context, 30),
             ),
             CustomText(text: label,
               color: isSelected ? AppThemeClass.primary : AppThemeClass
                   .darkTextOptional,
             ),
           ],
         ),
       );
     }
   });
  }
}


