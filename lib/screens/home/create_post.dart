import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/button.dart';
import '../../components/layout_components/small_components.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../utils/fontsize/app_theme/theme.dart';

class _SubjectNotifier extends StateNotifier<List<String>>{
  _SubjectNotifier():super([]);
  addItem(String value){
    if(state.contains(value)){
      state.remove(value);
      state=[...state];
      return;
    }
    state = [...state, value];
  }
  void removeItem(String value) {
    state = state.where((item) => item != value).toList();
  }
}
final _subjectProvider = StateNotifierProvider<_SubjectNotifier, List<String>>((ref) {
  return _SubjectNotifier();
});

class CreatePost extends StatelessWidget {
  CreatePost({super.key});
  final TextEditingController controller=TextEditingController();


  final List<String> list=['KIU Examination Board','AKU-EB Aga Khan University Examination Board ','FBISE-Federal Board of Intermediate and Secondary Education'];
  final List<String> nameOfClassList=['1th Class','2th Class','3th Class','4th Class','5th Class','6th Class','7th Class','8th Class','9th Class','10th Class','11th Class','12th Class'];

  final List<String> subjects = [
    "English",
    "Urdu",
    "Science",
    "Computer Science",
    "Pak-Studies",
    "Biology",
    "Physics",
    "Maths",
    "Chemistry",
    "Other"
  ];
  //final List<String> type = ["Exchange", "Sell", "Donate"];
  final _category = StateProvider.autoDispose<String>((ref) {
    final List<String> list = ["Exchange", "Sell", "Donate"];
    return list.first; // Safe access to first element
  });

  @override
  Widget build(BuildContext context) {
    print("build");
    return  SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  CustomText(text: "Select one option",isBold: true,),
                  Consumer(
                    builder:(context,ref,child)=> Column(
                      children: [
                        buildCustomRadioButtons(
                          options: ["Exchange", "Donate"],
                          selectedOption: ref.watch(_category),
                          onChanged: (newValue) {
                            ref.read(_category.notifier).state=newValue;
                          },
                        ),
                        if(ref.watch(_category)=="Sell")Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: "Price",isBold: true,),
                            CustomTextField(controller: controller,hintText: "200",textInputType: TextInputType.number,maxLength: 5,counterText: '',),
                          ],)
                      ],
                    ),
                  ),
                  CustomText(text: "Select Picture",isBold: true,),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:Border.all(
                            color: AppThemeClass.primary,
                            width: 1.0
                        )
                    ),
                    child: Center(child: Text("Upload Image")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomText(text: "Only one image can be upload",fontSize: 10,)
                    ],
                  ),
                  CustomText(text: "Select Class",isBold: true,),
                  customDropdownField(value: nameOfClassList[0], itemsList: nameOfClassList, onChanged: (String? val ) {
                  }),
                  CustomText(text: "Location",isBold: true,),
                  CustomTextField(controller: controller,hintText: "Noor Colony,Jutial Gilgit",),
                  CustomText(text: "Description",isBold: true,),
                 buildTextField(controller, "I want to exchange my books.....", 4),
                  CustomText(text: "Select Institutional Board",isBold: true,),
                  customDropdownField(value: list[0], itemsList: list, onChanged: (String? val ) {
                  }),
                  CustomText(text: "Select Subjects",isBold: true,),
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
                      children: subjects.map((buttonText) {
                        return Consumer(
                            builder:(context,ref,child) {
                              final subjects = ref.watch(_subjectProvider); // Watching state changes
                              final subjectNotifier = ref.read(_subjectProvider.notifier);
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: subjects.contains(buttonText)?AppThemeClass.primary:null,
                                  side: BorderSide(
                                      width:  1,
                                      color: AppThemeClass.primary
                                  ),
                                ),
                                onPressed: () {
                                  subjectNotifier.addItem(buttonText);
                                },
                                child: CustomText(text:
                                buttonText,
                                  color: subjects.contains(buttonText)?AppThemeClass.whiteText:AppThemeClass.darkText,
                                ),
                              );
                            }
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  CustomButton(onPress: (){},title: "Post",fontSize: 20,),
                ],
              ),
            ),
          ),
        ));
  }
}

Widget customDropdownField({
  required String? value,
  required List<String> itemsList,
  required void Function(String?) onChanged,
  String hintText = "Select an option",
}) {
  return DropdownButtonFormField<String>(
    isExpanded: true,
    icon: Icon(Icons.keyboard_arrow_down, color: AppThemeClass.primary),
    value: value,
    onChanged: onChanged,
    items: itemsList.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: CustomText(
          text: item,
        ),
      );
    }).toList(),
    decoration: InputDecoration(
      hintStyle: GoogleFonts.robotoSerif(
        color: AppThemeClass.darkTextOptional,
        fontSize: 13,
      ),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppThemeClass.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppThemeClass.primary,
          width: 2.0,
        ),
      ),
    ),
  );
}
buildTextField( TextEditingController controller,String hintText,int maxLines){
  return TextFormField(
    controller: controller,
    onChanged: (String text) {},
    maxLines: maxLines,
    cursorColor: AppThemeClass.primary,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppThemeClass.primary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppThemeClass.primary,
          width: 2.0,
        ),
      ),
      filled: true,
      fillColor: AppThemeClass.whiteText,
      hintText: hintText,
      hintStyle: GoogleFonts.robotoSerif(
        color: AppThemeClass.darkTextOptional,
        fontSize: 13,
      ),
    ),
  );
}