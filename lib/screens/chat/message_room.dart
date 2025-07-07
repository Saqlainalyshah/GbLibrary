import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/message_bubble_card.dart';
import '../../components/textfield.dart';
import '../../components/text_widget.dart';
import '../../controller/providers/global_providers.dart';
import '../../controller/time_format/time_format.dart';
import '../../model/chat_model.dart';
import '../../model/message_model.dart';
import '../../utils/app_theme/theme.dart';





import 'package:flutter/services.dart';

import 'chat.dart';

class NetworkChecker {
  static const platform = MethodChannel('com.example.network/check');

  static Future<bool> hasInternetConnection() async {
    try {
      final String result = await platform
          .invokeMethod('getNetworkStatus')
          .timeout(const Duration(seconds: 2),onTimeout: ()=>'none');

      print('Network status: $result');
      return result == 'wifi_internet' || result == 'mobile_internet';
    } on PlatformException catch (e) {
      print("Failed to get network status: '${e.message}'.");
      return false;
    }
  }

}


final _messages = StreamProvider.family<List<MessageModel>, String>((ref, roomID) {
  final data = FirebaseFirestore.instance
      .collection('chats')
      .doc(roomID)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map(
          (doc) {
            final decoded=MessageModel.fromJson(doc.data());
           final model= decoded.copyWith(messageDocId: doc.id);
           return model;
          },
    ).toList(),
  );
  return data;
});



class MessageRoom extends ConsumerStatefulWidget {
  const MessageRoom({super.key, required this.userProfile,this.chatRoomModel,this.userNotFound=false});
  final UserProfile userProfile;
  final ChatRoomModel? chatRoomModel;
  final bool userNotFound;

  @override
  ConsumerState<MessageRoom> createState() => _MessageRoomState();
}

class _MessageRoomState extends ConsumerState<MessageRoom> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      String id = user.uid+widget.userProfile.uid;
      final roomID = TimeFormater.sortString(id);
      ref.read(_messages(roomID));
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    controller.dispose();
  }

  clear(){
    controller.clear();
  }



  @override
  Widget build(BuildContext context) {
    print("MessageRoom build called at: ${DateTime.now()}");
    return SafeArea(
      top: false,
      child: Scaffold(
       // backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          elevation: 2,
          shadowColor: AppThemeClass.primary,
          //surfaceTintColor: Colors.transparent,
          //backgroundColor: ,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: ListTile(
            leading: ClipOval(
              child: CachedNetworkImage(
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                imageUrl: widget.userProfile.profilePicUrl,
              ),
            ),
            title: CustomText(
              text: widget.userProfile.name,
              isBold: true,
              maxLines: 1,
            ),
            subtitle: CustomText(text: "Offline"),
          ),
          actions: [
            Consumer(builder: (context,ref,child){
              final user=FirebaseAuth.instance.currentUser;

              String id =user!=null?user.uid+
                  widget.userProfile.uid:"12345677uuu5ii4";
              final roomID = TimeFormater.sortString(id);
              final allMessages=ref.watch(_messages(roomID));
            return  allMessages.when(data: (messages){
                if(messages.isNotEmpty){

                 return PopupMenuButton<String>(
//                    icon: Icon(Icons.more_vert), // 'More' icon
                    onSelected: (value){
                      FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                      // Handle option selection
                      print("Selected: $value");
                      if(value=='1'){
                        UiEventHandler.customAlertDialog(context, 'Do you want to block the user?', '', 'Block', 'Cancel', (){
                          Navigator.of(context).pop();

                          for(var item in messages){
                            if(item.userId==FirebaseAuth.instance.currentUser!.uid){
                              instance.deleteDocument('chats/$roomID/messages', item.messageDocId);
                            }
                          }
                          instance.removeArrayElement('chats', roomID, 'participants', FirebaseAuth.instance.currentUser!.uid);
                          if(widget.chatRoomModel!=null){
                            final result=widget.chatRoomModel;
                            if(result!.participants.length==1){
                              instance.deleteDocument('chats', result.chatDocId);
                            }
                          }
                        }, false);
                      }else if(value=='2'){
                        UiEventHandler.customAlertDialog(context, 'Do you want to delete all messages?', '', 'Delete all', 'Cancel', (){
                          Navigator.of(context).pop();
                          for(var item in messages){
                            if(item.userId==FirebaseAuth.instance.currentUser!.uid){
                             instance.deleteDocument('chats/$roomID/messages', item.messageDocId);
                            }
                          }
                          if(widget.userNotFound){
                            instance.deleteDocument('chats', widget.chatRoomModel!.chatDocId);
                          }
                        }, false);
                      }else{
                        instance.deleteDocument('chats', widget.chatRoomModel!.chatDocId);
                      }
                    },
                   // color: AppThemeClass.whiteText,
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: "1",
                        child: CustomText(text: "Block",isBold: true,),
                      ),
                      PopupMenuItem(
                        value: "2",
                        child: CustomText(text: "Delete all messages",isBold: true,),
                      ),
                      if(widget.userNotFound) PopupMenuItem(
                        value: "3",
                        child: CustomText(text: "Delete conversation",isBold: true,),
                      ),

                    ],
                  );
                }
                else{
                 return popupWidget();
                }
              },
                  error: (error,track)=>popupWidget(), loading:()=>popupWidget());
            })
          ],
        ),
        body: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final user=FirebaseAuth.instance.currentUser;
                String id =user!=null?user.uid+
                    widget.userProfile.uid:"12345677uuu5ii4";
               final roomID = TimeFormater.sortString(id);
                final asyncMessages = ref.watch(_messages(roomID));
               return asyncMessages.when(
                  data: (data) {
                    if (data.isNotEmpty) {
                    //  int length=data.length;
                      return Expanded(
                        child: ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: (){
                                String id =  ref.watch(userProfileProvider)!.uid+widget.userProfile.uid;
                                final roomID = TimeFormater.sortString(id);
                               bool isMyMessage= data[index].userId ==
                                    ref.watch(userProfileProvider)!.uid;
                               if(isMyMessage){
                                 UiEventHandler.customAlertDialog(context, "Do you want to delete this message?",data[index].message,'Delete','Cancel',()async {
                                   FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                                   if(context.mounted){
                                     Navigator.pop(context);
                                   }
                                   instance.deleteDocument('chats/$roomID/messages', data[index].messageDocId);
                                 },
                                     false
                                 );

                               }else{
                                 print("Not users");
                               }
                              },
                              child: MessageBubble(
                                messageModel: data[index],
                                index: index,
                                message: data[index].message,
                                isMe:
                                    data[index].userId ==
                                    FirebaseAuth.instance.currentUser!.uid,
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                               "Say! Hello ${widget.userProfile.name}👋! I am interested in your post",
                             // isBold: true,
                              style: TextStyle(
                                fontSize: 15,

                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }
                  },

                  error: (error, track) {
                    return Center(
                      child: CustomText(
                        text: "Something went wrong",
                        isBold: true,
                        fontSize: 15,
                      ),
                    );
                  },
                  loading: () => Expanded(child: Center(child: CircularProgressIndicator())),
                );
              },
            ),
            !widget.userNotFound?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      controller: controller,
                      hintText: "Type something....",
                      maxLines: 3,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return IconButton(
                        onPressed: ()  async{

                         final result = await NetworkChecker.hasInternetConnection();
                          if (controller.text.trim().isNotEmpty && RegExp(r'[a-zA-Z0-9]').hasMatch(controller.text) && result) {
                               String id =
                              ref.watch(userProfileProvider)!.uid +
                                  widget.userProfile.uid;
                          final roomID = TimeFormater.sortString(id);
                          ChatRoomModel chatRoomModel = ChatRoomModel(
                            users: [
                              ref.watch(userProfileProvider)!,
                              widget.userProfile,
                            ],
                            isRead: false,
                            createdAt: DateTime.now(),
                            participants: [
                              ref.watch(userProfileProvider)!.uid,
                              widget.userProfile.uid,
                            ],
                            deleteChatFrom: [],
                            lastMessage: controller.text,
                            lastMessageFrom: ref
                                .watch(userProfileProvider)!
                                .uid,
                            // users:[userProfile,ref.watch(currentUserData)!]
                          );
                          MessageModel messageModel = MessageModel(
                            userId: ref.watch(userProfileProvider)!.uid,
                            createdAt: DateTime.now(),
                            message: controller.text,
                            isRead: false,
                            userName: ref.watch(userProfileProvider)!.name,
                            userPic: ref
                                .watch(userProfileProvider)!
                                .profilePicUrl,
                          );
                          FirebaseFireStoreServices instance =
                          FirebaseFireStoreServices();
                          // print(chatRoomModel.toJson());
                              clear();
                               instance
                                   .createSubCollectionDocument(
                                 'chats',
                                 roomID,
                                 'messages',
                                 messageModel.toJson(),
                               )
                                   .whenComplete(() {
                                 instance
                                     .createDocumentWithId(
                                   'chats',
                                   roomID,
                                   chatRoomModel.toJson(),
                                 );
                               });
                          }else{
                            if(context.mounted){
                              UiEventHandler.snackBarWidget(context, "No internet connection!");
                            }
                          }
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: AppThemeClass.primary,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ):  Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: "This user is not available",fontSize: 13,isBold: true,),
            ),
          ],
        ),
      ),
    );
  }
}

Widget popupWidget(){
  return  PopupMenuButton<String>(
    icon: Icon(Icons.more_vert), // 'More' icon
    onSelected: (value) {
    },
    itemBuilder: (BuildContext context) => [
      PopupMenuItem(
        value: "1",
        child: Text("Block user"),
      ),
      PopupMenuItem(
        value: "2",
        child: Text("Delete all messages"),
      ),

    ],
  );
}