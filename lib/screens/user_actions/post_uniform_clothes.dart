import 'dart:io';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/screens/user_actions/clothes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/button.dart';
import '../../components/layout_components/alert_dialogue.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../controller/firebase_Storage/crud_storage.dart';
import '../../controller/firebase_crud_operations/firestore_crud_operations.dart';
import '../../controller/providers/global_providers.dart';
import '../../model/post_model.dart';
import '../../utils/fontsize/app_theme/theme.dart';


final uniformSize = StateProvider<String?>((ref)=>null);
final isSchoolUniform=StateProvider<String?>((ref)=>null);
final selectedUniformImageProvider = StateProvider.autoDispose<File?>((ref) => null);

class UniformClothesScreen extends ConsumerStatefulWidget {
 const  UniformClothesScreen({super.key,required this.clothesIds,required this.isEdit});
final ClothesIds clothesIds;
final bool isEdit;
  @override
  ConsumerState<UniformClothesScreen> createState() => _UniformClothesScreenState();
}

class _UniformClothesScreenState extends ConsumerState<UniformClothesScreen> {
  final TextEditingController description=TextEditingController();

  final TextEditingController location=TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String?> _upload(WidgetRef ref) async{
    try{
      FirebaseStorageService storage=FirebaseStorageService();
      final fileName = '${ref.watch(userProfileProvider)!.uid}_${DateTime.now().millisecondsSinceEpoch}';
      final url=await storage.uploadFile('posts/outfits/$fileName', File(ref.watch(selectedUniformImageProvider)!.path));
      return url;
    } catch (e){
      return null;
    }
  }

  Future<void> imagePickAndCompressed(WidgetRef ref) async{
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      FirebaseStorageService storage=FirebaseStorageService();
      final XFile? file= await storage.pickImageAndCompress(pickedFile);
      if(file!=null){
        final fileData = File(file.path);
        ref.read(selectedUniformImageProvider.notifier).state = fileData;
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location.text=widget.clothesIds.clothesModel.location;
    description.text=widget.clothesIds.clothesModel.description;
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
    ref.invalidate(selectedUniformImageProvider);
    ref.invalidate(isSchoolUniform);
    ref.invalidate(uniformSize);
  }
  //final List<String> type = ["Exchange", "Sell", "Donate"];
  @override
  Widget build(BuildContext context) {

    print("build");
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
      appBar: AppBar(
        surfaceTintColor: AppThemeClass.whiteText,
        backgroundColor: Colors.transparent,
        title: CustomText(text: "Post Uniform & Clothes",isBold: true,fontSize: 20,),
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
                CustomText(text: "Select size",isGoogleFont: true,color: AppThemeClass.primary,),
                Consumer(
                    builder:(context,ref,child)=>  buildRadioButtons(
                      options: ["S", "M","L","XL"],
                      selectedOption: ref.watch(uniformSize)??'',
                      onChanged: (newValue) {
                        ref.read(uniformSize.notifier).state=newValue;
                      },
                    )
                ),
                CustomText(text: "Location",isGoogleFont: true,color: AppThemeClass.primary,),
                CustomTextField(controller: location,hintText: "Noor Colony,Jutial Gilgit",
                  validator: (value) {
                    if (value!.isEmpty) return "Address is required";
                    return null;
                  },),
                CustomText(text: "Description",isGoogleFont: true,color: AppThemeClass.primary,),
                CustomTextField(controller: description,hintText:  "I want to exchange my books.....",maxLines:  4,
                  validator: (value) {
                    if (value!.isEmpty) return "Description is required";
                    if (value.length <50) return "Minimum character length is 50";
                    return null;
                  },
                ),
                CustomText(text: "Is this school uniform?",isGoogleFont: true,color: AppThemeClass.primary,),
                Consumer(
                  builder:(context,ref,child)=> buildRadioButtons(
                    options: ["Yes","No"],
                    selectedOption: ref.watch(isSchoolUniform)??'',
                    onChanged: (newValue) {
                      ref.read(isSchoolUniform.notifier).state=newValue;
                    },
                  ),
                ),
                /*  CustomText(text: "Select Institutional Board",isBold: true,),
                    customDropdownField(value: list[0], itemsList: list, onChanged: (String? val ) {
                    }),*/
             if(!widget.isEdit)   CustomText(text: "Select Picture",isGoogleFont: true,color: AppThemeClass.primary,),
                if(!widget.isEdit)    Consumer(
                  builder:(context,ref,child){
                    final selectedImage=ref.watch(selectedUniformImageProvider);
                    print(selectedImage);

                    return GestureDetector(
                      onTap: ()=>imagePickAndCompressed(ref),
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

                SizedBox(height: 10,),Consumer(
                  builder:(context,ref,child)=> CustomButton(onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>UniformClothes()));

                  },title: "Post",fontSize: 15,isBold: true,),
                ),
                widget.isEdit==true? Row(
                  spacing: 20,
                  children: [
                    Flexible(child:CustomButton(onPress: (){
                      if (_formKey.currentState!.validate() && ref.watch(isSchoolUniform)!=null && ref.watch(uniformSize)!=null) {
                        ClothesModel clothe=ClothesModel(
                          userID: widget.clothesIds.clothesModel.userID,
                          type: 'outfits',
                          size: ref.watch(uniformSize)??'M',
                          isSchoolUniform: ref.watch(isSchoolUniform)??'Yes',
                          location: location.text,
                          description: description.text,
                          imageUrl: widget.clothesIds.clothesModel.imageUrl,
                          createdAt: DateTime.now(),
                        );
                        FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                        instance.updateDocument('outfits', widget.clothesIds.docId,clothe.toJson()).whenComplete((){
                          if(context.mounted){
                            invalidate();
                            Navigator.pop(context);
                            //  Navigator.pop(context);
                            UiEventHandler.snackBarWidget(context, "Successfully updated");
                          }
                        });

                      } else {
                        UiEventHandler.snackBarWidget(context, "Please fill all the required fields");
                      }
                    },title: "Update",fontSize: 15,isBold: true,)),
                    Flexible(child: CustomButton(onPress: () async{
                      FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                      FirebaseStorageService storage =FirebaseStorageService();
                      bool result=await storage.deleteFile(widget.clothesIds.clothesModel.imageUrl);
                      if(result){
                        instance.deleteDocument('clothes', widget.clothesIds.docId).then((onValue){
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
                    if (_formKey.currentState!.validate() && ref.watch(isSchoolUniform)!=null && ref.watch(uniformSize)!=null && ref.watch(selectedUniformImageProvider)!=null) {

                      _upload(ref).then((val){
                        if(val!=null){
                          ClothesModel clothe=ClothesModel(
                            userID: ref.watch(userProfileProvider)!.uid,
                            type: 'outfits',
                            size: ref.watch(uniformSize)??'M',
                            isSchoolUniform: ref.watch(isSchoolUniform)??'Yes',
                            location: location.text,
                            description: description.text,
                            imageUrl: val,
                            createdAt: DateTime.now(),
                          );
                          FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                          instance.createDocument('outfits', clothe.toJson()).whenComplete((){
                            if(context.mounted){
                              Navigator.pop(context);
                              description.clear();
                              location.clear();
                              //  Navigator.pop(context);
                              UiEventHandler.snackBarWidget(context, "Successfully updated");
                            }

                          });
                        }
                      });

                    } else {
                      UiEventHandler.snackBarWidget(context, "Please fill all the required fields");
                    }
                  },title: "Post",fontSize: 15,isBold: true,),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

Widget buildRadioButtons({
  required List<String> options,
  required String selectedOption,
  required Function(String) onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes items evenly
    children: options.map((option) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            activeColor: AppThemeClass.primary,
            value: option,
            groupValue: selectedOption,
            onChanged: (String? value) {
              onChanged(value!);
            },
          ),
          CustomText(text: option), // Label next to radio button
        ],
      );
    }).toList(),
  );
}
