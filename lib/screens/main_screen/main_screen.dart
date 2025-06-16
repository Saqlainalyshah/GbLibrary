import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:booksexchange/screens/home/feed_portion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../drawer/drawer.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../chat/chat.dart';
import '../user_actions/post_books.dart';
import '../user_actions/post_uniform_clothes.dart';

class MainScreen extends ConsumerWidget {
   MainScreen({super.key,});

  // final UserProfile userProfile;
  final _bottomNavigationIndex=StateProvider.autoDispose<int>((ref)=>0);

  final List<Widget> screens=[
    FeedPortion(),
    PostItem(),
    ChatScreen(),

  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: CustomText(text: "GBLibrary",isBold: true,fontSize: 20,),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.sort,size: 30,))
          ],
        ),
        drawer: DrawerWidget(),
        body: screens[ref.watch(_bottomNavigationIndex)],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppThemeClass.primary,
            unselectedItemColor: AppThemeClass.darkTextOptional,
            unselectedIconTheme: IconThemeData(color: AppThemeClass.darkTextOptional),
            elevation: 0.0,
            currentIndex: ref.watch(_bottomNavigationIndex),
            selectedIconTheme: const IconThemeData(size: 30),
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(letterSpacing: 0,fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(letterSpacing: 0,),
            onTap: (index) {
              ref.read(_bottomNavigationIndex.notifier).state = index;
            },
            items:  const [
              BottomNavigationBarItem(
                label: "Feed",
                icon: Icon(Icons.feed),
              ),
              BottomNavigationBarItem(
                label: "Post Item",
                icon: Icon(Icons.add_circle), // Updated icon for clarity
              ),
              BottomNavigationBarItem(
                label: "Chat",
                icon: Icon(Icons.chat), // Updated icon for clarity
              ),
             /* BottomNavigationBarItem(
                label: "Account",
                icon: Icon(Icons.perm_identity),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}


class PostItem extends StatelessWidget {
  const PostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            ...List.generate(2, (index){
            final List<String> l=["Books","Uniform & Clothes "];
            final List<String> list=["Exchange or Donate your books. There are a lot of educators looking for books exchanges and books donation","Give your clothes to needy students. You can share schools uniforms"];
            return ListTile(
              //splashColor: AppThemeClass.primary,
              focusColor: AppThemeClass.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                      color: AppThemeClass.secondary
                  )
              ),
              onTap: (){
                if(index==0){
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>PostBooks(isEdit: false,)));
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>UniformClothes()));
                }
              },
              title: Row(
                children: [
                  Flexible(flex:1,child: Image.asset(index==1?"assets/images/uniform.png":"assets/splash/splash.png",fit: BoxFit.cover,)),
                  Flexible(flex:3,child: ListTile(
                  //  isThreeLine: true,
                    title: CustomText(text: l[index],isBold: true,fontSize: 16,),
                    subtitle: CustomText(text: list[index],maxLines: 3,),
                  )),
                  Icon(Icons.navigate_next),
                ],
              ),
            );
          }),
          ],

        ),
      ),
    );
  }
}
