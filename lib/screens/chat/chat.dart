import 'package:booksexchange/components/cards/listTile_card.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:booksexchange/screens/chat/message_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/textfield.dart';
import '../../controller/firebase_crud_operations/firestore_crud_operations.dart';

import '../../controller/providers/global_providers.dart';
import '../../model/chat_model.dart';
import '../../utils/fontsize/app_theme/theme.dart';


final countMessage=StateProvider<int>((ref)=>0);

final messageCountProvider = StateProvider<int>((ref) {
  final user=ref.watch(currentUserAuthStatus).asData?.value;
  if(user!=null){
    final List<ChatIds> chatList = ref.watch(chats).maybeWhen(
      data: (value) => value.isNotEmpty?value:[],
      orElse: () => [],
    );
    final unreadCount = chatList
        .where((chat) => chat.chatRoomModel.isRead == false && chat.chatRoomModel.lastMessageFrom==user.uid )
        .length;
    return unreadCount;
  }else{
    return 0;
  }
});

final chats = StreamProvider<
    List<ChatIds>>((ref) {
  final user=ref.watch(currentUserAuthStatus).asData?.value;
     if(user!=null){
       final data=FirebaseFirestore.instance
           .collection('chats')
           .where('participants', arrayContains: user.uid)
           .orderBy('createdAt', descending: true)
           .snapshots()
           .map((snapshot) {
         return snapshot.docs.map((doc) {
           final data = doc.data();
           return ChatIds(
               chatRoomModel: ChatRoomModel.fromJson(data),
               docId: doc.id);
         }).toList();
       });

       return data;
     }else {
       return Stream.value([]); // Return an empty stream if not signed in
     }
});

class ChatIds{
  final ChatRoomModel chatRoomModel;
  final String docId;
  ChatIds({required this.chatRoomModel, required this.docId});
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'chatRoomModel': chatRoomModel.toJson(),
      'docId': docId,
    };
  }

  // Construct from JSON
  factory ChatIds.fromJson(Map<String, dynamic> json) {
    return ChatIds(
      chatRoomModel: ChatRoomModel.fromJson(json['chatRoomModel']),
      docId: json['docId'],
    );
  }

}

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
    print(ref.watch(messageCountProvider));
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
                  final asyncValue=ref.watch(chats);

                  return asyncValue.when(data: (data){

                    print("rebuilds");
                    if(data.isNotEmpty){
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context,index){
                              final UserProfile user = data[index].chatRoomModel.users.firstWhere(
                                (user) => user.uid != FirebaseAuth.instance.currentUser!.uid,
                          );
                              int count=0;
                            bool isMe=data[index].chatRoomModel.lastMessageFrom==FirebaseAuth.instance.currentUser!.uid;
                            bool newMessage=data[index].chatRoomModel.isRead;
                            if(!isMe && !data[index].chatRoomModel.isRead){

                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) {
                                ref.read(countMessage.notifier).state= count+1;
                              });
                            }
                              return ListTileCard(
                              isIcon: true,
                              newMessage:newMessage,
                              isMe:isMe,
                              time: data[index].chatRoomModel.createdAt.toString(),
                              title: user.name,
                                subTitle: data[index].chatRoomModel.lastMessage,
                                imageUrl: user.profilePicUrl,
                              function: (){
                                final value=ref.watch(messageCountProvider);
                                if(value>0){
                                  //ref.read(messageCountProvider.no)
                                  ref.read(messageCountProvider.notifier).state=value-1;
                                }
                                ChatRoomModel model=data[index].chatRoomModel;
                              if(!isMe && !data[index].chatRoomModel.isRead){
                               final chatModel= model.copyWith(isRead: true);
                                FirebaseFireStoreServices instance =
                                FirebaseFireStoreServices();
                                instance
                                    .createDocumentWithId(
                                  'chats',
                                  data[index].docId,
                                  chatModel.toJson(),
                                );
                              }
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