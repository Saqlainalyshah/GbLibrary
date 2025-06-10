import 'package:flutter/material.dart';

import '../../components/textfield.dart';
import '../../components/text_widget.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../user_actions/post_books.dart';

class MessageRoom extends StatelessWidget {
  MessageRoom({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("MessageRoom build called at: ${DateTime.now()}");
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppThemeClass.whiteText,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: ListTile(
            leading: CircleAvatar(),
            title: CustomText(text: "Saqlain Ali Shah hfhfhgfhgfhgfhfhgfhgfh", isBold: true, maxLines: 2,),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: index.isEven ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: index.isEven ? AppThemeClass.primary : AppThemeClass.secondary,
                        borderRadius: BorderRadius.only(
                          topLeft: index.isEven ? Radius.circular(0) : Radius.circular(30),
                          topRight: index.isEven ? Radius.circular(30) : Radius.circular(0),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text:
                            "Hello, this is a chat message!",
                            color: index.isEven ? Colors.white : Colors.black,fontSize: 15,
                          ),
                          SizedBox(height: 5), // Space for timestamp & ticks
                          Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(text:
                                "12:30 AM", // Example timestamp
                                fontSize: 12, color: index.isEven ?Colors.white70:Colors.black54,
                              ),
                              Icon(
                                Icons.done_all,
                                size: 16,
                                color: index.isEven ? Colors.white70 : Colors.blueAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: CustomTextField(controller: controller, hintText: "Type something....",maxLines:  4)),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send, color: AppThemeClass.primary, size: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}