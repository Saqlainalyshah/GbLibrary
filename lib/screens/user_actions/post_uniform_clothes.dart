import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/button.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../utils/fontsize/app_theme/theme.dart';

class UniformClothes extends StatelessWidget {
  UniformClothes({super.key});
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
    final List<String> list = ["small", "medium","Large","Extra Large"];
    return list.first; // Safe access to first element
  });

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              CustomText(text: "Select size",isGoogleFont: true,),
              Consumer(
                  builder:(context,ref,child)=>  _buildRadioButtons(
                    options: ["S", "M","L","XL"],
                    selectedOption: ref.watch(_category),
                    onChanged: (newValue) {
                      ref.read(_category.notifier).state=newValue;
                    },
                  )
              ),
              CustomText(text: "Description",isGoogleFont: true,),
              CustomTextField(controller: controller,hintText:  "I want to exchange my books.....",maxLines:  4),
              CustomText(text: "Location",isGoogleFont: true,),
              CustomTextField(controller: controller,hintText: "Noor Colony,Jutial Gilgit",),

              CustomText(text: "Is this school uniform?",isGoogleFont: true,),
              Consumer(
                builder:(context,ref,child)=> _buildRadioButtons(
                  options: ["Yes","No"],
                  selectedOption: ref.watch(_category),
                  onChanged: (newValue) {
                    ref.read(_category.notifier).state=newValue;
                  },
                ),
              ),
              /*  CustomText(text: "Select Institutional Board",isBold: true,),
                  customDropdownField(value: list[0], itemsList: list, onChanged: (String? val ) {
                  }),*/
              CustomText(text: "Select Picture",isGoogleFont: true,),
              Container(
                clipBehavior: Clip.antiAlias,
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:Border.all(
                        color: AppThemeClass.primary,
                        width: 1.0
                    )
                ),
                child: Center(child: CustomText(text: "Upload Image",color: AppThemeClass.primary,)),
              ),
              CustomText(text: "Only one image can be upload",isGoogleFont:true,fontSize: 10,),
              SizedBox(height: 10,),
              CustomButton(onPress: (){},title: "Post",fontSize: 20,),
            ],
          ),
        ),
      ),
    ));
  }
}

Widget _buildRadioButtons({
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
