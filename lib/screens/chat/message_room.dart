import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/message_bubble_card.dart';
import '../../components/textfield.dart';
import '../../components/text_widget.dart';
import '../../controller/providers/global_providers.dart';
import '../../controller/time_format/time_format.dart';
import '../../model/chat_model.dart';
import '../../model/message_model.dart';
import '../../utils/fontsize/app_theme/theme.dart';

final _messages = StreamProvider.family<List<MessagesIDs>, String>((ref, roomID) {
  final data = FirebaseFirestore.instance
      .collection('chats')
      .doc(roomID)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map(
          (doc) => MessagesIDs(
        messageModel: MessageModel.fromJson(doc.data()),
        docId: doc.id,
      ),
    ).toList(),
  );
  return data;
});


class MessagesIDs {
  final MessageModel messageModel;
  final String docId;

  MessagesIDs({required this.messageModel, required this.docId});

  factory MessagesIDs.fromJson(Map<String, dynamic> json) {
    return MessagesIDs(
      messageModel: MessageModel.fromJson(json['messageModel']),
      docId: json['docId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageModel': messageModel.toJson(),
      'docId': docId,
    };
  }
}

class MessageRoom extends ConsumerStatefulWidget {
  const MessageRoom({super.key, required this.userProfile});
  final UserProfile userProfile;

  @override
  ConsumerState<MessageRoom> createState() => _MessageRoomState();
}

class _MessageRoomState extends ConsumerState<MessageRoom> {
  final TextEditingController controller = TextEditingController();


  final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String id = FirebaseAuth.instance.currentUser!.uid+widget.userProfile.uid;
    final roomID = TimeFormater.sortString(id);
    ref.read(_messages(roomID));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

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
            leading: ClipOval(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                imageUrl: widget.userProfile.profilePicUrl,
              ),
            ),
            title: CustomText(
              text: widget.userProfile.name,
              isBold: true,
              maxLines: 2,
            ),
            subtitle: CustomText(text: "Offline"),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        ),
        body: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                String id =
                    ref.watch(userProfileProvider)!.uid +
                    widget.userProfile.uid;
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
                                String id = FirebaseAuth.instance.currentUser!.uid+widget.userProfile.uid;
                                final roomID = TimeFormater.sortString(id);
                               bool isMyMessage= data[index].messageModel.userId ==
                                    FirebaseAuth.instance.currentUser!.uid;
                               if(isMyMessage){
                                 UiEventHandler.customAlertDialog(context, "Do you want to delete this message?",data[index].messageModel.message,'Delete','Cancel',()async {
                                   FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                                   await instance.deleteDocument('chats/$roomID/messages', data[index].docId);
                                   if(context.mounted){
                                     Navigator.pop(context);
                                   }
                                 },false
                                 );
                               }
                              },
                              child: MessageBubble(
                                messageModel: data[index].messageModel,
                                index: index,
                                message: data[index].messageModel.message,
                                isMe:
                                    data[index].messageModel.userId ==
                                    FirebaseAuth.instance.currentUser!.uid,
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: CustomText(
                            text: "Hello! ${widget.userProfile.name}👋!",
                            isBold: true,
                            fontSize: 15,
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
            Padding(
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
                        onPressed: () async {
                          if (controller.text.trim().isNotEmpty && RegExp(r'[a-zA-Z0-9]').hasMatch(controller.text)) {
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
                          controller.clear();
                          instance
                              .createDocumentWithId(
                            'chats',
                            roomID,
                            chatRoomModel.toJson(),
                          )
                              .then((onValue) {
                            instance
                                .createSubCollectionDocument(
                              'chats',
                              roomID,
                              'messages',
                              messageModel.toJson(),
                            );
                          });
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
            ),
          ],
        ),
      ),
    );
  }
}
