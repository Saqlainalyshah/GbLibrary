
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/home/feed_portion.dart';
import 'package:booksexchange/screens/home/uniform_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/providers/global_providers.dart';
import '../../drawer/drawer.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../account/account.dart';
import '../chat/chat.dart';
import '../home/post_item.dart';
import '../user_actions/post_books.dart';
import '../user_actions/post_uniform_clothes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'dart:io';
import 'package:image/image.dart' as Iamg;
import 'package:image_picker/image_picker.dart';


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
    checkModelInput();
    ref.read(getUserDocument);
    ref.read(chats);
    ref.read(booksFeedProvider);
    ref.read(myBooksPosts);
    ref.read(myClothesPosts);
    ref.read(uniformFeedProvider);
    ref.read(messageCountProvider);
  }


  void checkModelInput() async {
    final interpreter = await Interpreter.fromAsset('assets/model/best_float32.tflite');


    // Get input tensor
    var inputTensor = interpreter.getInputTensor(0);
    var outputTensor=interpreter.getOutputTensor(0);

    // Print input shape and type
    print('Input shape: ${inputTensor.shape}');
    print('Input type: ${inputTensor.type}');
    print('outputTensor shape: ${outputTensor.shape}');
    print('outputTensor type: ${outputTensor.type}');


  }
  final List<Widget> screens=  [
    const FeedPortion(),
    const UniformFeed(),
    const PostItem(),
    const ChatScreen(),
     //InferencePage(),
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
        bottomNavigationBar: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
            padding: EdgeInsets.zero,
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
                  child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppThemeClass.whiteText, // Needed to avoid transparency
          selectedItemColor: AppThemeClass.primary,
          unselectedItemColor: AppThemeClass.darkText,
          unselectedIconTheme: IconThemeData(color: AppThemeClass.darkTextOptional),
          currentIndex: ref.watch(_bottomNavigationIndex),
          selectedIconTheme: const IconThemeData(size: 30),
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            letterSpacing: -0.5,
            fontWeight: FontWeight.w500,
          ),
          onTap: (index) {
            ref.read(_bottomNavigationIndex.notifier).state = index;
          },
          items:  [
           const BottomNavigationBarItem(label: "Books", icon: Icon(Icons.feed)),
            const BottomNavigationBarItem(label: "Clothes", icon: Icon(Icons.groups)),
            const BottomNavigationBarItem(label: "Post", icon: Icon(Icons.add_circle)),
            BottomNavigationBarItem(label: "Chat", icon:    Icon(Icons.chat,),
            ),
            const BottomNavigationBarItem(label: "Model", icon: Icon(Icons.model_training)),
          ],
                  ),
                ),
            Consumer(builder:(context,ref,child){
              if(ref.watch(messageCountProvider)>0){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Material(
                    elevation: 4.0, // Adjust the elevation value as needed
                    shape: CircleBorder(), // Ensures the material maintains circular shape
                    color: Colors.transparent, // Keep the container's original color
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppThemeClass.primary,
                      ),
                      child: CustomText(text: ref.watch(messageCountProvider).toString(),isBold: true,color:AppThemeClass.whiteText,),
                    ),

                  ),
                );
              }else{
                return SizedBox.shrink();
              }
            }
            )

          ],
        ),

      ),
    );
  }
}
