import 'dart:io';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/user_actions/post_uniform_clothes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../components/button.dart';
import '../../components/drop_down.dart';
import '../../components/layout_components/alert_dialogue.dart';
import '../../components/layout_components/small_components.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../controller/firebase_Storage/crud_storage.dart';
import '../../controller/providers/global_providers.dart';
import '../../model/ui_models.dart';
import '../../utils/fontsize/app_theme/theme.dart';

import 'package:image/image.dart' as img;
import 'dart:math'; // Import for max function

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;


















final bookSubjectsList=StateProvider<List<String>>((ref)=>[]);
final _item=StateProvider<String>((ref)=>'');
final selectedImageProvider = StateProvider.autoDispose<File?>((ref) => null);
final bookGrade=StateProvider<String?>((ref)=>null);
final bookCategory = StateProvider<String?>((ref)=>null);
final _imageUrl=StateProvider.autoDispose<String?>((ref)=>null);
final bookBoard=StateProvider<String?>((ref)=>null);

class PostBooks extends ConsumerStatefulWidget {
   const PostBooks({super.key, required this.isEdit,  required this.booksWithIds});
  final bool isEdit;
  final BookIds booksWithIds;

  @override
  ConsumerState<PostBooks> createState() => _PostBooksState();
}

class _PostBooksState extends ConsumerState<PostBooks> {
   final TextEditingController location=TextEditingController();
   final TextEditingController description=TextEditingController();

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


   Future<void> _pickImageAndCompress(WidgetRef ref) async{
     final picker = ImagePicker();
     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
     if(pickedFile!=null){
       FirebaseStorageService storage=FirebaseStorageService();
       final XFile? file= await storage.pickImageAndCompress(pickedFile);
       if(file!=null){
         final fileData = File(file.path);
         ref.read(selectedImageProvider.notifier).state = fileData;
       }
     }
   }

   Future<void> uploadPost(WidgetRef ref) async {
     final fileName = '${ref.watch(userProfileProvider)!.uid}_${DateTime.now().millisecondsSinceEpoch}';
     final storageRef = FirebaseStorage.instance.ref().child('posts/books/$fileName');
     try {
       await storageRef.putFile(ref.watch(selectedImageProvider)!);
       final downloadUrl = await storageRef.getDownloadURL();

       ref.read(_imageUrl.notifier).state=downloadUrl;
       print('Download URL: $downloadUrl');
     } catch (e) {
       print('Error uploading file: $e');
     }
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location.text=widget.booksWithIds.booksModel.location;
    description.text=widget.booksWithIds.booksModel.description;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    location.dispose();
    description.dispose();
  }
   late Interpreter _interpreter;


   invalidate(){
    location.clear();
    description.clear();
    ref.invalidate(selectedImageProvider);
    ref.invalidate(bookBoard);
    ref.invalidate(bookGrade);
    ref.invalidate(bookCategory);
    ref.invalidate(bookSubjectsList);
  }
  /// model function



  ///build function
  @override
  Widget build(BuildContext context) {
    print("Create Post Rebuilds.....");
    return  SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: CustomText(text: "Post Books",fontSize: 20,isBold: true,),
            leading: buildCustomBackButton(context),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  CustomText(text: "Do you want to Exchange or Donate?",isGoogleFont: true,color: AppThemeClass.primary,),
                  Row(
                    children: List.generate(2, (index) {
                      List<String> list = ["Exchange", "Donate"];
                      final option = list[index];
                      return Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            return RadioListTile<String>(
                              activeColor: AppThemeClass.primary,
                              value: list[index],
                              groupValue: ref.watch(bookCategory.select((index)=>index)),
                              onChanged: (val) {
                                ref.read(bookCategory.notifier).state = val!;
                              },
                              title: CustomText(text: option),
                            );
                          },
                        ),
                      );
                    }),
                  ),

                  CustomText(text: "Location",isGoogleFont: true,color: AppThemeClass.primary,),
                  CustomTextField(controller: location,hintText: "Noor Colony,Jutial Gilgit", validator: (value) {
                    if (value!.isEmpty) return "Address is required";
                    return null;
                  },),
                  CustomText(text: "Description",isGoogleFont: true,color: AppThemeClass.primary,),
                  CustomTextField(controller: description,hintText:  "I want to exchange my books.....",maxLines:  6,
                    validator: (value) {
                      if (value!.isEmpty) return "Description is required";
                      if (value.length <50) return "Minimum character length is 50";
                      return null;
                    },
                  ),

                  CustomText(text: "Select Class",isGoogleFont: true,color: AppThemeClass.primary,),
                  Consumer(
                    builder:(context,ref,child)=> CustomDropDown(value:  ref.watch(bookGrade),hintText: "Class",list: nameOfClassList, onChanged: (String? val ) {
                      ref.read(bookGrade.notifier).state=val;
                    }, validator: (value) {
                      if (value==null) return "Class is required";
                      return null;
                    },
                    ),
                  ),
                  CustomText(text: "Select Institutional Board",isGoogleFont: true,color: AppThemeClass.primary,),
                  Consumer(
                    builder:(context,ref,child)=> CustomDropDown( value: ref.watch(bookBoard),hintText: "Board",list: list, onChanged: (String? val ) {
                      ref.read(bookBoard.notifier).state=val!;
                    },
                      validator: (value) {
                        if (value==null) return "Board is required";
                        return null;
                      },
                    ),
                  ),
                  CustomText(text: "Select Subjects",isGoogleFont: true,color: AppThemeClass.primary,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:Border.all(
                            color: AppThemeClass.primary,
                            width: 1.0
                        )
                    ),
                    child: Wrap(
                      spacing: 5.0,
                      children: List.generate(subjects.length, (index){
                        return ProviderScope(
                          overrides: [_item.overrideWith((it)=>subjects[index])],
                          child: const ButtonSubjects(),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 10,),
                  if(!widget.isEdit)   CustomText(text: "Select Picture",isGoogleFont: true,color: AppThemeClass.primary,),
                 if(!widget.isEdit) Consumer(
                    builder:(context,ref,child){
                      final selectedImage=ref.watch(selectedImageProvider);
                      return GestureDetector(
                        onTap: () => _pickImageAndCompress(ref),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:Border.all(
                                  color: AppThemeClass.primary,
                                  width: 1.0
                              ),
                            image:selectedImage!=null? DecorationImage(image: FileImage(selectedImage,),fit: BoxFit.cover):null
                          ),
                          child: selectedImage!=null?SizedBox.shrink():Center(child: CustomText(text: "Upload Image",color: AppThemeClass.primary,)),
                        ),
                      );
                    },
                  ),
                  if(!widget.isEdit)   CustomText(text: "Only one image can be upload",isGoogleFont: true,fontSize: 9,color: AppThemeClass.primary,),

                  SizedBox(height: 10,),
                  widget.isEdit==true? Row(
                    spacing: 20,
                    children: [
                      Flexible(child:CustomButton(onPress: (){

                        if (_formKey.currentState!.validate() && ref.watch(bookCategory)!=null && ref.watch(bookSubjectsList).isNotEmpty ) {
                          // UiEventHandler.customAlertDialog(context, "Please wait it will takes few seconds! Uploading...", CircularProgressIndicator(color: AppThemeClass.primary,));

                          uploadPost(ref).whenComplete((){
                            BooksModel book=BooksModel(
                              userID: widget.booksWithIds.booksModel.userID,
                              category: ref.read(bookCategory)!,
                              type: 'books',
                              grade: ref.read(bookGrade)??'',
                              location: location.text,
                              description: description.text,
                              board: ref.read(bookBoard)??'',
                              subjects: ref.read(bookSubjectsList),
                              createdAt: DateTime.now(),
                              imageUrl: widget.booksWithIds.booksModel.imageUrl,
                            );
                            FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                            instance.updateDocument('posts',widget.booksWithIds.docId,book.toJson()).whenComplete((){
                              invalidate();
                              if(context.mounted){
                                Navigator.pop(context);
                              }
                            });
                          });
                          UiEventHandler.snackBarWidget(context, "Successfully updated");
                        } else {
                          UiEventHandler.snackBarWidget(context, "Please fill all the required fields");
                        }
                      },title: "Update",fontSize: 15,isBold: true,)),
                      Flexible(child: CustomButton(onPress: () async{
                        FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                        FirebaseStorageService storage =FirebaseStorageService();
                      bool result=await storage.deleteFile(widget.booksWithIds.booksModel.imageUrl);
                      if(result){
                        instance.deleteDocument('posts', widget.booksWithIds.docId).then((onValue){
                          invalidate();
                        });
                      }
                   if(context.mounted){
                     Navigator.pop(context);
                   }
                      },title: "Delete",fontSize: 15,isBold: true,))
                    ],
                  ):Consumer(
                    builder:(context,ref,child)=> CustomButton(onPress: () {
                      if (_formKey.currentState!.validate() && ref.watch(bookCategory)!=null && ref.watch(bookSubjectsList).isNotEmpty && ref.watch(selectedImageProvider)!=null) {
                      // UiEventHandler.customAlertDialog(context, "Please wait it will takes few seconds! Uploading...", CircularProgressIndicator(color: AppThemeClass.primary,));
                         uploadPost(ref).whenComplete((){
                           BooksModel book=BooksModel(
                               userID: ref.watch(userProfileProvider)!.uid,
                               type: 'books',
                               category: ref.read(bookCategory)!,
                               grade: ref.read(bookGrade)??'',
                               location: location.text,
                               description: description.text,
                               board: ref.read(bookBoard)??'',
                               subjects: ref.read(bookSubjectsList),
                               imageUrl: ref.read(_imageUrl)??'',
                             createdAt: DateTime.now(),
                           );
                          FirebaseFireStoreServices firestore=FirebaseFireStoreServices();
                           firestore.createDocument('posts', book.toJson()).whenComplete((){
                             invalidate();
                           if(context.mounted){
                             Navigator.pop(context);
                           }
                          });

                        });

                        UiEventHandler.snackBarWidget(context, "Successfully updated");
                      } else {
                        UiEventHandler.snackBarWidget(context, "Please fill all the required fields");
                      }
                    },title: "Post",fontSize: 15,isBold: true,),
                  ),
                ],
              )),
            ),
          ),
        ));
  }
}

class ButtonSubjects extends ConsumerWidget {
  const ButtonSubjects({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item=ref.watch(_item);
    final isSelected = ref.watch(
      bookSubjectsList.select((list) => list.contains(item)),
    );
    print("Only $item was rebuilt");
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppThemeClass.primary : null,
        side: BorderSide(width: 1, color: AppThemeClass.primary),
      ),
      onPressed: () {
        final list = [...ref.read(bookSubjectsList)];
        if (isSelected) {
          list.remove(item);
        } else {
          list.add(item);
        }
        ref.read(bookSubjectsList.notifier).state = list;
      },
      child: CustomText(
        text: item,
        color: isSelected ? AppThemeClass.whiteText : AppThemeClass.darkText,
      ),
    );
  }
}





class BookDetector extends StatefulWidget {
  @override
  _BookDetectorState createState() => _BookDetectorState();
}

class _BookDetectorState extends State<BookDetector> {
  late Interpreter _interpreter;
  List<int> _inputShape = [1, 640, 640, 3]; // Assuming YOLOv8 input size
  List<int> _outputShape = [1, 8, 8400]; // Assuming YOLOv8 output size
  final picker = ImagePicker();
  String _resultText = 'Select an image to begin.';

  // 🔧 Set this to the label index of the "book" class
  // You'll need to know the index of the 'book' class from your dataset's labels.txt or data.yaml
  // If your dataset has only one class (book), the index is likely 0.
  final int bookClassIndex = 0; // ← Update based on your training

  // Adjust confidence threshold as needed
  final double confidenceThreshold = 0.5;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/best_float32.tflite');
      _inputShape = _interpreter.getInputTensor(0).shape;
      _outputShape = _interpreter.getOutputTensor(0).shape;
      print('Model loaded successfully with input shape: $_inputShape and output shape: $_outputShape');
      setState(() {});
    } catch (e) {
      print('Failed to load model: $e');
      setState(() {
        _resultText = 'Error loading model: $e';
      });
    }
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  Future<void> _pickImageAndDetect() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    setState(() {
      _resultText = 'Detecting...';
    });
    final result = await detectBook(file);

    setState(() {
      _resultText = result ? 'Book detected 📚' : 'No book detected ❌';
    });
  }

  Future<bool> detectBook(File imageFile) async {
    final imgBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imgBytes);
    if (image == null) {
      print("Invalid image file.");
      return false;
    }


    final width = _inputShape[1];
    final height = _inputShape[2];

    // Resize image to model's input size
    final resized = img.copyResize(image, width: width, height: height);

    // Prepare input tensor
    final input = Float32List(1 * width * height * 3);
    final buffer = Float32List.view(input.buffer);

    int pixelIndex = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = resized.getPixel(x, y);
        // Assuming RGB format, normalize pixel values to [0, 1]
        buffer[pixelIndex++] = pixel.r / 255.0;
        buffer[pixelIndex++] = pixel.g / 255.0;
        buffer[pixelIndex++] = pixel.b / 255.0;
      }
    }

    // Prepare output tensor (assuming [1, 8, 8400])
    // You might need to adjust the output shape based on your model's actual output
    var output = List.filled(_outputShape.reduce((a, b) => a * b), 0).reshape(_outputShape);


    // Run inference
    _interpreter.run(input.buffer, output);

    // Process the output to check for detections
    // Assuming the output structure is [1, 8, 8400] where 8 contains box + class scores
    // and class scores start from index 4

    // Transpose the output for easier processing [1, 8400, 8]
    List<List<List<double>>> transposedOutput = List.generate(
      output.length,
          (batchIndex) => List.generate(
        output[batchIndex][0].length,
            (predictionIndex) => List.generate(
          output[batchIndex].length,
              (paramIndex) => output[batchIndex][paramIndex][predictionIndex].toDouble(),
        ),
      ),
    );


    for (var prediction in transposedOutput[0]) {
      // Check the confidence score for the book class
      // Assuming class scores start at index 4 and bookClassIndex is the index within those scores
      if (bookClassIndex >= 0 && bookClassIndex < (prediction.length - 4)) {
        if (prediction[4 + bookClassIndex] > confidenceThreshold) {
          // Book detected
          return true;
        }
      } else {
        print('Warning: bookClassIndex ($bookClassIndex) is out of bounds for prediction output.');
      }
    }

    // No book detected above the confidence threshold
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _resultText,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: _loadModel, // Option to reload model
              child: Text('Reload Model'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageAndDetect,
              child: Text('Pick Image and Detect Book'),
            ),
          ],
        ),
      ),
    );
  }
}