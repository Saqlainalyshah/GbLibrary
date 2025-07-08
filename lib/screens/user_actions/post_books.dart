import 'dart:io';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/button.dart';
import '../../components/drop_down.dart';
import '../../components/layout_components/alert_dialogue.dart';
import '../../components/layout_components/small_components.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../controller/book_detection/book_detection.dart';
import '../../controller/firebase_Storage/crud_storage.dart';
import '../../controller/providers/global_providers.dart';
import '../../model/ui_models.dart';
import '../../utils/app_theme/theme.dart';
import '../chat/message_room.dart';

final bookSubjectsList=StateProvider<List<String>>((ref)=>[]);
final _item=StateProvider<String>((ref)=>'');
final selectedImageProvider = StateProvider.autoDispose<File?>((ref) => null);
final bookGrade=StateProvider<String?>((ref)=>null);
final bookCategory = StateProvider<String?>((ref)=>null);
final bookBoard=StateProvider<String?>((ref)=>null);

class PostBooks extends ConsumerStatefulWidget {
   const PostBooks({super.key, required this.isEdit,  required this.booksModel});
  final bool isEdit;
  final BooksModel booksModel;

  @override
  ConsumerState<PostBooks> createState() => _PostBooksState();
}

class _PostBooksState extends ConsumerState<PostBooks> {
   final TextEditingController location=TextEditingController();
   final TextEditingController description=TextEditingController();

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


   Future<void> _pickImageAndCompress(WidgetRef ref) async {
     final picker = ImagePicker();
     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
     if (pickedFile != null) {
       print("Image Picked Now show circular indicator");
    if(mounted){
      UiEventHandler.customAlertDialog(
          context,
          'Detecting book in the image...',
          '',
          '',
          '', () {},
          true);
    }
       // BookDetectorModel instance=BookDetectorModel();
       final res = await TFLiteService.runModelOnImage(pickedFile);

       if (res != null) {
         print("Model output ==================== $res");

         //TODO: Model threshold value is 0.5 you can change it up to 1
         if (res > 0.5) {

           FirebaseStorageService storage = FirebaseStorageService();
           final XFile? file = await storage.pickImageAndCompress(pickedFile);
           if (file != null) {
             final fileData = File(file.path);
             ref
                 .read(selectedImageProvider.notifier)
                 .state = fileData;
           }
         }else{
           if(mounted){
             UiEventHandler.snackBarWidget(context, 'Only books image acceptable! Try again');
           }
         }

       }
       print("Now at the end pop circular indicator");
     if(mounted){
        Navigator.of(context).pop();
     }
     }
   }
   Future<String?> uploadPost(WidgetRef ref) async {
     final fileName = '${ref.watch(userProfileProvider)!.uid}_${DateTime.now().millisecondsSinceEpoch}';
     final storageRef = FirebaseStorage.instance.ref().child('posts/books/$fileName');
     try {
       await storageRef.putFile(ref.watch(selectedImageProvider)!);
       final downloadUrl = await storageRef.getDownloadURL();

       return downloadUrl;
     } catch (e) {
       print('Error uploading file: $e');
       return null;
     }
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location.text=widget.booksModel.location;
    description.text=widget.booksModel.description;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    location.dispose();
    description.dispose();
  }

   invalidate(){
    location.clear();
    description.clear();
    ref.invalidate(selectedImageProvider);
    ref.invalidate(bookBoard);
    ref.invalidate(bookGrade);
    ref.invalidate(bookCategory);
    ref.invalidate(bookSubjectsList);
  }

  @override
  Widget build(BuildContext context) {
    print("Create Post Rebuilds.....");
    return  SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
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
                  Wrap(
                    spacing: 5.0,
                    children: List.generate(subjects.length, (index){
                      return ProviderScope(
                        overrides: [_item.overrideWith((it)=>subjects[index])],
                        child: const ButtonSubjects(),
                      );
                    }),
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
                                  color: AppThemeClass.primaryOptional,
                                  width: 1.0
                              ),
                            image:selectedImage!=null? DecorationImage(image: FileImage(selectedImage,),fit: BoxFit.cover):null
                          ),
                          child: selectedImage!=null?SizedBox.shrink():Center(child: CustomText(text: "Upload Image",color: AppThemeClass.primary,)),
                        ),
                      );
                    },
                  ),
                  if(!widget.isEdit)   CustomText(text: "Only one image can be upload. The image should be clear because our Book detection model is not 100% accurate",isGoogleFont: true,fontSize: 9,color: AppThemeClass.primary,),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Note:',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400,
                              fontSize: 12,
                              letterSpacing: -0.5),
                        ),
                        TextSpan(
                          text: 'You cannot edit image once image uploaded!',
                          style: TextStyle(
                              color: AppThemeClass.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              letterSpacing: -0.5
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  widget.isEdit==true? Row(
                    spacing: 20,
                    children: [
                      Flexible(child:CustomButton(onPress: () async{
                        final result = await NetworkChecker.hasInternetConnection();
                        if (_formKey.currentState!.validate() && ref.watch(bookCategory)!=null
                            && ref.watch(bookSubjectsList).isNotEmpty && result) {
                           UiEventHandler.customAlertDialog(context, "Please wait few seconds! updating...",'','','',(){} ,true);

                          BooksModel book=BooksModel(
                            userID: widget.booksModel.userID,
                            category: ref.read(bookCategory)!,
                            type: 'books',
                            grade: ref.read(bookGrade)??'',
                            location: location.text,
                            description: description.text,
                            board: ref.read(bookBoard)??'',
                            subjects: ref.read(bookSubjectsList),
                            createdAt: widget.booksModel.createdAt,
                            imageUrl: widget.booksModel.imageUrl,
                          );
                          BooksModel existingBook=widget.booksModel;
                          bool isSame=book==existingBook;
                          if(isSame){
                            if(context.mounted){
                              Navigator.pop(context);
                              UiEventHandler.snackBarWidget(context, "Make some changes and try again!");
                              return;
                            }
                          }else{
                            FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                            instance.updateDocument('books',widget.booksModel.bookDocId,book.toJson()).whenComplete((){
                              invalidate();
                              if(context.mounted){
                                Navigator.pop(context);
                                UiEventHandler.snackBarWidget(context, "Successfully updated");
                              }
                            });
                          }
                        } else {
                          if(context.mounted){
                            UiEventHandler.snackBarWidget(context, "Please fill all the required fields");
                          }
                        }
                      },title: "Update",fontSize: 15,isBold: true,)),
                      Flexible(child: CustomButton(onPress: () async{
                        UiEventHandler.customAlertDialog(context, "Please wait few seconds! Deleting...",'','','',(){} ,true);

                        FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                        FirebaseStorageService storage =FirebaseStorageService();
                      bool result=await storage.deleteFile(widget.booksModel.imageUrl);
                      if(result){
                        instance.deleteDocument('books', widget.booksModel.bookDocId).then((onValue){
                          invalidate();
                         if(context.mounted){
                           UiEventHandler.snackBarWidget(context, "Post Deleted");
                           Navigator.pop(context);
                         }
                        });
                      }
                        if(context.mounted){
                          UiEventHandler.snackBarWidget(context, "Try again!");
                          Navigator.pop(context);

                        }
                      },title: "Delete",fontSize: 15,isBold: true,))
                    ],
                  ):Consumer(
                    builder:(context,ref,child)=> CustomButton(onPress: () async{
                      final result = await NetworkChecker.hasInternetConnection();
                      if (_formKey.currentState!.validate() && ref.watch(bookCategory)!=null
                          && ref.watch(bookSubjectsList).isNotEmpty && ref.watch(selectedImageProvider)!=null &&result) {
                        UiEventHandler.customAlertDialog(context, "Please wait few seconds! Uploading...",'','','',(){} ,true);
                        FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                        uploadPost(ref).then((val){
                          if(val!=null){
                            BooksModel book=BooksModel(
                              userID: ref.watch(userProfileProvider)!.uid,
                              type: 'books',
                              category: ref.watch(bookCategory)!,
                              grade: ref.watch(bookGrade)??'',
                              location: location.text,
                              description: description.text,
                              board: ref.watch(bookBoard)??'',
                              subjects: ref.watch(bookSubjectsList),
                              imageUrl: val,
                              createdAt: DateTime.now(),
                            );
                            instance.createDocument('books', book.toJson()).whenComplete((){
                              invalidate();
                              if(context.mounted){
                                UiEventHandler.snackBarWidget(context, "Successfully uploaded");
                                Navigator.pop(context);
                              }
                            });
                          }
                        });
                      } else {
                       if(context.mounted){
                         UiEventHandler.snackBarWidget(context, "Please fill all the required fields");
                       }
                      }
                    },title: "Post",fontSize: 18,isBold: true,),
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
      ),
    );
  }
}






