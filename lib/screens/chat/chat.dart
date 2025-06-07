import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/chat/message_room.dart';
import 'package:flutter/material.dart';
import '../../components/textfield.dart';
import '../../utils/fontsize/app_theme/theme.dart';

class ChatScreen extends StatelessWidget {
    ChatScreen({super.key});
final TextEditingController controller=TextEditingController();

@override
  Widget build(BuildContext context) {
    print("ChatScreen build called at: ${DateTime.now()}");
    final textField=buildTextField(controller);
    return SafeArea(
      top: false,
      child: Scaffold(

        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
        automaticallyImplyLeading: false
        ,surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: CustomText(text: "Chat",isBold: true,fontSize: 20,),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textField,
                SizedBox(height: 10,),
                CustomText(text: "Messages",fontSize: 16,isBold: true,),
                SizedBox(height: 10,),
                ...List.generate(10, (index){
                  print("Nested rebuilds $index");
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>MessageRoom()));
                    },
                    child: Container(
                      height: 100,
                      decoration:BoxDecoration(
                        boxShadow: [
                          /*BoxShadow(
                            color: Colors.black54.withOpacity(0.5),// Shadow color
                            blurRadius: 10, // Blur effect
                            spreadRadius: 2, // How far the shadow spreads
                            offset: Offset(4, 4), // Shadow position
                          ),*/
                        ],
                      /*  gradient: LinearGradient(
                          colors: [AppThemeClass.primary, AppThemeClass.secondary], // Gradient colors
                          begin: Alignment.topLeft, // Gradient start point
                          end: Alignment.bottomRight, // Gradient end point
                        ),*/
                        borderRadius: BorderRadius.circular(5), // Rounded corners
                        border: Border.all(color: AppThemeClass.secondary, width: 1.0), // Border properties
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all( 10),
                      child: Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle
                              ),
                            ),
                          ),
                          Flexible(flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0,left: 5),
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: "Saqlain Ali Shah",maxLines: 1,fontSize: 14,isBold: true,),
                                  CustomText(text: "Muja send karo aj lazimi hain please urgen hai please",maxLines: 1,fontSize: 13,),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
buildTextField( TextEditingController controller){
  return CustomTextField(controller: controller,hintText: "Search messages",leadingIcon: Icons.search,
                  trailingIcon: Icons.close,
                  trailingFn: (){
                    controller.clear();
                    //FocusScope.of(context).unfocus();
                  },);
}