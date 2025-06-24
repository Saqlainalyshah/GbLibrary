
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/home/feed_portion.dart';
import 'package:booksexchange/screens/home/uniform_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/providers/global_providers.dart';
import '../../drawer/drawer.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../chat/chat.dart';
import '../user_actions/post_books.dart';
import '../user_actions/post_uniform_clothes.dart';

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
    ref.read(getUserDocument);
    ref.read(booksFeedProvider);
    ref.read(myBooksPosts);
    ref.read(myClothesPosts);
    ref.read(uniformFeedProvider);

    super.initState();
  }

  final List<Widget> screens=  [
    const FeedPortion(),
    const UniformFeed(),
    const PostItem(),
    const ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
        body: IndexedStack(
          index: ref.watch(_bottomNavigationIndex),
          children: screens,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppThemeClass.primaryOptional,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,

          ),
          child: BottomNavigationBar(
            //fixedColor: AppThemeClass.primaryOptional,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppThemeClass.whiteText,
            unselectedItemColor: AppThemeClass.primary,
            unselectedIconTheme: IconThemeData(color: AppThemeClass.primary),
            elevation: 3.0,
            currentIndex: ref.watch(_bottomNavigationIndex),
            selectedIconTheme: const IconThemeData(size: 30),
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            ),
            onTap: (index) {
              ref.read(_bottomNavigationIndex.notifier).state = index;
            },
            items: const [
              BottomNavigationBarItem(
                label: "Books",
                icon: Icon(Icons.feed),
              ),
              BottomNavigationBarItem(
                label: "Clothes",
                icon: Icon(Icons.groups),
              ),
              BottomNavigationBarItem(
                label: "Post",
                icon: Icon(Icons.add_circle),
              ),
              BottomNavigationBarItem(
                label: "Chat",
                icon: Icon(Icons.chat),
              ),
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
    print("PostItem Screen Rebuilds");
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
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>UniformClothesScreen()));
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
