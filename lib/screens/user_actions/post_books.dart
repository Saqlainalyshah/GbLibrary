import 'dart:io';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/user_actions/post_uniform_clothes.dart';
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
import '../../controller/firebase_Storage/crud_storage.dart';
import '../../controller/providers/global_providers.dart';
import '../../model/ui_models.dart';
import '../../utils/fontsize/app_theme/theme.dart';

final _subjectsList=StateProvider.autoDispose<List<String>>((ref)=>[]);
final _item=StateProvider<String>((ref)=>'');
final selectedImageProvider = StateProvider.autoDispose<File?>((ref) => null);
final _grade=StateProvider.autoDispose<String?>((ref)=>null);
final _category = StateProvider.autoDispose<String?>((ref)=>null);
final _imageUrl=StateProvider.autoDispose<String?>((ref)=>null);
final board=StateProvider.autoDispose<String?>((ref)=>null);

class PostBooks extends StatelessWidget {
   PostBooks({super.key, required this.isEdit,  this.booksModel});
  final bool isEdit;
  final BooksModel? booksModel;
   final TextEditingController location=TextEditingController();
   final TextEditingController description=TextEditingController();

  //final List<String> type = ["Exchange", "Sell", "Donate"];


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
                              groupValue: ref.watch(_category.select((index)=>index)),
                              onChanged: (val) {
                                ref.read(_category.notifier).state = val!;
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
                    builder:(context,ref,child)=> CustomDropDown(value:  ref.watch(_grade),hintText: "Class",list: nameOfClassList, onChanged: (String? val ) {
                      ref.read(_grade.notifier).state=val;
                      print(ref.read(_grade));
                    }, validator: (value) {
                      if (value==null) return "Class is required";
                      return null;
                    },
                    ),
                  ),
                  CustomText(text: "Select Institutional Board",isGoogleFont: true,color: AppThemeClass.primary,),
                  Consumer(
                    builder:(context,ref,child)=> CustomDropDown( value: ref.watch(board),hintText: "Board",list: list, onChanged: (String? val ) {
                      ref.read(board.notifier).state=val!;
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
                  if(!isEdit)   CustomText(text: "Select Picture",isGoogleFont: true,color: AppThemeClass.primary,),
                 if(!isEdit) Consumer(
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
                  if(!isEdit)   CustomText(text: "Only one image can be upload",isGoogleFont: true,fontSize: 9,color: AppThemeClass.primary,),

                  SizedBox(height: 10,),
                  isEdit==true? Row(
                    spacing: 20,
                    children: [
                      Flexible(child:CustomButton(onPress: (){},title: "Update",fontSize: 15,isBold: true,)),
                      Flexible(child: CustomButton(onPress: (){},title: "Delete",fontSize: 15,isBold: true,))
                    ],
                  ):Consumer(
                    builder:(context,ref,child)=> CustomButton(onPress: () {
                      if (_formKey.currentState!.validate() && ref.watch(_category)!=null && ref.watch(_subjectsList).isNotEmpty && ref.watch(selectedImageProvider)!=null) {
                       UiEventHandler.customAlertDialog(context, "Please wait it will takes few seconds! Uploading...", CircularProgressIndicator(color: AppThemeClass.primary,));

                         uploadPost(ref).whenComplete((){
                           BooksModel book=BooksModel(
                               userID: ref.watch(userProfileProvider)!.uid,
                               type: 'books',
                               category: ref.read(_category)!,
                               grade: ref.read(_grade)??'',
                               location: location.text,
                               description: description.text,
                               board: ref.read(board)??'',
                               subjects: ref.read(_subjectsList),
                               imageUrl: ref.read(_imageUrl)??'',
                             createdAt: DateTime.now(),
                           );
                          FirebaseFireStoreServices firestore=FirebaseFireStoreServices();
                           firestore.createDocument('posts', book.toJson()).whenComplete((){
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
      _subjectsList.select((list) => list.contains(item)),
    );
    print("Only $item was rebuilt");
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppThemeClass.primary : null,
        side: BorderSide(width: 1, color: AppThemeClass.primary),
      ),
      onPressed: () {
        final list = [...ref.read(_subjectsList)];
        if (isSelected) {
          list.remove(item);
        } else {
          list.add(item);
        }
        ref.read(_subjectsList.notifier).state = list;
      },
      child: CustomText(
        text: item,
        color: isSelected ? AppThemeClass.whiteText : AppThemeClass.darkText,
      ),
    );
  }
}
