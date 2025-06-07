import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../drawer/drawer.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../chat/chat.dart';
import '../home/create_post.dart';

class MainScreen extends ConsumerWidget {
   MainScreen({super.key});
  final _bottomNavigationIndex=StateProvider.autoDispose<int>((ref)=>0);

  final List<Widget> screens=[
    Home(),
    ChatScreen(),
    CreatePost(),
    Center(child: Text("Account"),)


  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
       // drawerScrimColor: AppThemeClass.primary,
        appBar: AppBar(
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
                label: "Chat",
                icon: Icon(Icons.chat), // Updated icon for clarity
              ),
              BottomNavigationBarItem(
                label: "Create",
                icon: Icon(Icons.add_circle), // Updated icon for clarity
              ),
              BottomNavigationBarItem(
                label: "Account",
                icon: Icon(Icons.perm_identity),
              ),
            ],
          ),
        ),
      /*
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: Consumer(
            builder:(context,ref,child)=> BottomNavigationBar(
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
              items: const [
                BottomNavigationBarItem(
                  label: "Feed",
                  icon: Icon(Icons.feed),
                ),
                BottomNavigationBarItem(
                  label: "Chat",
                  icon: Icon(Icons.chat), // Updated icon for clarity
                ),
                BottomNavigationBarItem(
                  label: "Create",
                  icon: Icon(Icons.add_circle), // Updated icon for clarity
                ),
                BottomNavigationBarItem(
                  label: "Account",
                  icon: Icon(Icons.perm_identity),
                ),
              ],
            ),
          ),
        ),
      */
      ),
    );
  }
}
