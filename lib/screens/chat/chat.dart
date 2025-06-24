import 'package:booksexchange/components/cards/listTile_card.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:booksexchange/screens/chat/message_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/textfield.dart';
import '../../model/chat_model.dart';
import '../../utils/fontsize/app_theme/theme.dart';



final _chats = StreamProvider<
    List<ChatRoomModel>>((ref) {
     final user=FirebaseAuth.instance.currentUser;
     if(user!=null){
       final data=FirebaseFirestore.instance
           .collection('chats')
           .where('participants', arrayContains: user.uid)
           .orderBy('createdAt', descending: true)
           .snapshots()
           .map((snapshot) => snapshot.docs
           .map((doc) => ChatRoomModel.fromJson(doc.data()))
           .toList());
       return data;
     }else {
       return Stream.value([]); // Return an empty stream if not signed in
     }
});

class ChatScreen extends ConsumerStatefulWidget {
   const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
final TextEditingController controller=TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     controller.dispose();
  }
@override
  Widget build(BuildContext context) {
    print("ChatScreen build called at: ${DateTime.now()}");
    final textField=buildTextField(controller);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Chat",isBold: true,fontSize: 20,),
                SizedBox(height: 20,),
                textField,
                SizedBox(height: 10,),
                CustomText(text: "Messages",fontSize: 16,isBold: true,),
                SizedBox(height: 10,),
                Consumer(builder: (context,ref,child){
                  final asyncValue=ref.watch(_chats);

                  return asyncValue.when(data: (data){
                    if(data.isNotEmpty){
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context,index){
                              final UserProfile user = data[index].users.firstWhere(
                                (user) => user.uid != FirebaseAuth.instance.currentUser!.uid,
                          );

                            bool isMe=data[index].lastMessageFrom==FirebaseAuth.instance.currentUser!.uid;
                              print(data[index].createdAt);
                            return ListTileCard(
                              isMe:isMe,
                              time: data[index].createdAt.toString(),
                              title: user.name,
                                subTitle: data[index].lastMessageFrom==FirebaseAuth.instance.currentUser!.uid?data[index].lastMessage:data[index].lastMessage,
                                imageUrl: user.profilePicUrl,
                              function: (){
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>MessageRoom(userProfile: user)));
                              },
                            );
                          });
                    }else{
                      return Padding(
                        padding: const EdgeInsets.only(top: 250.0),
                        child: Center(child: CustomText(text: "No Messages!",fontSize: 15,)),
                      );
                    }
                  },
                      error: (error,track){
                    return CustomText(text: "Check Your Network Connection",isBold: true,fontSize: 20,);
                      },
                      loading: (){
                    return Center(child: CircularProgressIndicator(color: AppThemeClass.primary,),);
                      }
                  );
                }),
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