import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/components/textfield.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/layout_components/small_components.dart';

///Update User Profile
class Profile extends StatefulWidget {
   const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
final TextEditingController name=TextEditingController();
   final TextEditingController address=TextEditingController();
   final TextEditingController whatsappNumber=TextEditingController();
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    address.dispose();
    whatsappNumber.dispose();
  }
  final List<String> list=["Male","Female"];
final _gender=StateProvider.autoDispose<String>((ref)=>"Male");
  @override
  Widget build(BuildContext context) {
    final nameField=CustomTextField(controller: name,hintText: name.text.isEmpty?"Name":name.text,);
    final addressField=CustomTextField(controller: address,hintText: address.text.isEmpty?"Noor Colony Jutial":address.text,);
    final whatsappField=CustomTextField(controller: whatsappNumber,hintText: whatsappNumber.text.isEmpty?"03134457244":whatsappNumber.text,);
    print("Profile Rebuilds");
    return Scaffold(
      backgroundColor: AppThemeClass.whiteText,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: buildCustomBackButton(context),
        title: CustomText(text: "Profile",isBold: true,fontSize: 20,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.add_circle,size: 35,color: AppThemeClass.primary,))
                  ],
                )
              ),
              CustomText(text: "Name"),
              nameField,
              CustomText(text: "Gender"),
             Consumer(builder: (context,ref,child)=> buildCustomRadioButtons(
               options: list,
               selectedOption: ref.watch(_gender),
               onChanged: (newValue) {
                 ref.read(_gender.notifier).state=newValue;
               },
             ),),
              CustomText(text: "Address"),
              addressField,
              CustomText(text: "WhatsApp Number"),
              whatsappField,
              CustomButton(onPress: (){},title: "Update",)
            ],
          ),
        ),
      ),
    );
  }
}
