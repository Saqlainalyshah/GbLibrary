import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/button.dart';
import '../../components/drop_down.dart';
import '../../components/layout_components/small_components.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../utils/fontsize/app_theme/theme.dart';

final _subjectsList=StateProvider.autoDispose<List<String>>((ref)=>[]);
final _item=StateProvider<String>((ref)=>'');



class PostBooks extends StatelessWidget {
   PostBooks({super.key, required this.isEdit});
  final bool isEdit;
   final TextEditingController location=TextEditingController();
   final TextEditingController description=TextEditingController();

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
  final _category = StateProvider.autoDispose<String>((ref)=>'Exchange');


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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  CustomText(text: "Select one option",isGoogleFont: true,),
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
                  CustomText(text: "Select Class",isGoogleFont: true,),
                  CustomDropDown(value: nameOfClassList[0], list: nameOfClassList, onChanged: (String? val ) {
                  }),
                  CustomText(text: "Location",isGoogleFont: true,),
                  CustomTextField(controller: location,hintText: "Noor Colony,Jutial Gilgit",),
                  CustomText(text: "Description",isGoogleFont: true,),
                 CustomTextField(controller: description,hintText:  "I want to exchange my books.....",maxLines:  6),
                  CustomText(text: "Select Institutional Board",isGoogleFont: true,),
                  CustomDropDown(value: list[0], list: list, onChanged: (String? val ) {
                  }),
                  CustomText(text: "Select Subjects",isGoogleFont: true,),
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
                  CustomText(text: "Only one image can be upload",isGoogleFont: true,fontSize: 9,),
                  SizedBox(height: 10,),
                 isEdit==true? Row(
                   spacing: 20,
                   children: [
                     Flexible(child:CustomButton(onPress: (){},title: "Update",fontSize: 15,isBold: true,)),
                     Flexible(child: CustomButton(onPress: (){},title: "Delete",fontSize: 15,isBold: true,))
                   ],
                 ):CustomButton(onPress: (){},title: "Post",fontSize: 15,isBold: true,),
                ],
              ),
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
