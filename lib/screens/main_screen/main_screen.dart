
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/home/feed_portion.dart';
import 'package:booksexchange/screens/home/uniform_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/providers/global_providers.dart';
import '../../drawer/drawer.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../chat/chat.dart';
import '../home/post_item.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    const BookClassifier(),

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



class BookClassifier extends StatefulWidget {
  const BookClassifier({super.key});

  @override
  State<BookClassifier> createState() => _BookClassifierState();
}

class _BookClassifierState extends State<BookClassifier> {
  static const platform = MethodChannel('book_detector');

  Uint8List? imageBytes;
  String result = 'No image selected';

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      imageBytes = bytes;
      result = 'Processing...';
    });

    try {
      final isBook = await platform.invokeMethod<bool>(
        ' Book Models - v5 2024-11-05 3-17am',
        {'image': bytes},
      );
      setState(() {
        result = isBook == true ? '✅ This is a book!' : '❌ Not a book';
      });
    } catch (e) {
      setState(() {
        result = 'Error: ${e.toString()}';
        print("=====================================================================================");
        print("Error:${e.toString()}");
        print("=====================================================================================");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Detector')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image_search),
                label: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              if (imageBytes != null)
                Image.memory(imageBytes!, height: 200),
              const SizedBox(height: 20),
              Text(result, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

/*
const kModelName = "book-detector";


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initWithLocalModel();
  }

  FirebaseCustomModel? model;

  /// Initially get the lcoal model if found, and asynchronously get the latest one in background.
  initWithLocalModel() async {
    final newModel = await FirebaseModelDownloader.instance.getModel(
        kModelName, FirebaseModelDownloadType.localModelUpdateInBackground);

    setState(() {
      model = newModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: model != null
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Model name: ${model!.name}'),
                          Text('Model size: ${model!.size}'),
                        ],
                      )
                          : const Text("No local model found"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final newModel =
                          await FirebaseModelDownloader.instance.getModel(
                              kModelName,
                              FirebaseModelDownloadType.latestModel);

                          setState(() {
                            model = newModel;
                          });
                        },
                        child: const Text('Get latest model'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseModelDownloader.instance
                              .deleteDownloadedModel(kModelName);

                          setState(() {
                            model = null;
                          });
                        },
                        child: const Text('Delete local model'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
