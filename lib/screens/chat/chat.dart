import 'dart:async';
import 'package:booksexchange/components/cards/listTile_card.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:booksexchange/screens/chat/message_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/layout_components/alert_dialogue.dart';
import '../../components/textfield.dart';
import '../../controller/firebase_crud_operations/firestore_crud_operations.dart';
import '../../controller/providers/global_providers.dart';
import '../../model/chat_model.dart';


class FilterChats {
  final List<ChatRoomModel> allChats;
  final List<ChatRoomModel> filteredChats;
  final int unreadMessageCount;

  FilterChats({
    required this.allChats,
    required this.filteredChats,
    required this.unreadMessageCount,
  });

  FilterChats copyWith({
    List<ChatRoomModel>? allChats,
    List<ChatRoomModel>? filteredChats,
    int? unreadMessageCount,
  }) {
    return FilterChats(
      allChats: allChats ?? this.allChats,
      filteredChats: filteredChats ?? this.filteredChats,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
    );
  }
}

class FilterFeedNotifier extends StateNotifier<FilterChats> {
  late final StreamSubscription? _sub;

  FilterFeedNotifier(String uid)
      : super(FilterChats(allChats: [], filteredChats: [], unreadMessageCount: 0)) {
    _sub = FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final chatsData = snapshot.docs.map((doc) {
        final data = doc.data();
        final decoded=ChatRoomModel.fromJson(data);
        final model=decoded.copyWith(chatDocId: doc.id);
       return model;
      }).toList();

      final unreadCount = chatsData.where((chat) =>
      chat.isRead == false &&
          chat.lastMessageFrom != uid,
      ).length;

      state = state.copyWith(
        allChats: chatsData,
        filteredChats: chatsData,
        unreadMessageCount: unreadCount,
      );
    });
  }

  FilterFeedNotifier.empty()
      : _sub = null,
        super(FilterChats(allChats: [], filteredChats: [], unreadMessageCount: 0));

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }


  void filterChatRoomsByUser(bool Function(UserProfile user) condition) {
    final filtered = state.allChats.where((chatRoom) {
      return chatRoom.users.any(condition);
    }).toList();
    state = state.copyWith(filteredChats: filtered);
  }

  void filterBySearch(String search) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    filterChatRoomsByUser((UserProfile user) {
      return user.uid != uid &&
          user.name.toLowerCase().startsWith(search.toLowerCase());
    });
  }

  void resetFilters() {
    state = state.copyWith(filteredChats: state.allChats);
  }
}


final filterChatProvider = StateNotifierProvider<FilterFeedNotifier, FilterChats>((ref) {
  final authAsync = ref.watch(currentUserAuthStatus);

  // Handle loading or error
  if (authAsync is AsyncLoading || authAsync is AsyncError || authAsync.value == null) {
    return FilterFeedNotifier.empty(); // fallback safe version
  }

  final uid = authAsync.value!.uid;
  return FilterFeedNotifier(uid);
});




class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
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
  _searchFocusNode.dispose();
  }
outside(){
    _searchFocusNode.unfocus();
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        //backgroundColor: AppThemeClass.whiteText,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Chat", isBold: true, fontSize: 20),
                SizedBox(height: 20),
                Consumer(
                  builder: (context, ref, child) {
                    return CustomTextField(
                      controller: controller,
                      hintText: "Search",
                      leadingIcon: Icons.search,
                      trailingIcon: Icons.close,
                      onChanged: (String search) {
                        ref.read(filterChatProvider.notifier).filterBySearch(search);
                      },
                      trailingFn: () {
                        controller.clear();
                        ref.read(filterChatProvider.notifier).resetFilters();
                      },
                    );
                  },
                ),

                SizedBox(height: 10),
                CustomText(text: "Messages", fontSize: 16, isBold: true),
                SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, child) {
                    final filterState = ref.watch(filterChatProvider);
                    final isSearching = controller.text.isNotEmpty;
                    final data = isSearching ? filterState.filteredChats : filterState.allChats;
                    if (data.isNotEmpty) {
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final UserProfile user = data[index].users.firstWhere(
                                (user) => user.uid != FirebaseAuth.instance.currentUser!.uid,
                          );

                          bool isMe = data[index].lastMessageFrom ==
                              FirebaseAuth.instance.currentUser!.uid;
                          return GestureDetector(
                            onLongPress: (){
                              if(data[index].participants.length==1){
                                UiEventHandler.customAlertDialog(context, "Do you want to delete this Conversation?",'','Delete','Cancel',()async {
                                  FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                                  if(context.mounted){
                                    Navigator.pop(context);
                                  }
                                  instance.deleteDocument('chats', data[index].chatDocId);
                                },
                                    false
                                );
                              }
                            },
                            child: ListTileCard(
                            //  isBorder: true,
                              isRead: data[index].isRead,
                              isMe: isMe,
                              time: data[index].createdAt.toString(),
                              title: user.name,
                              subTitle: data[index].lastMessage,
                              imageUrl: user.profilePicUrl,
                              function: () {
                                ChatRoomModel model = data[index];

                                if (!isMe && !model.isRead) {
                                  final chatModel = model.copyWith(isRead: true);
                                  FirebaseFireStoreServices instance = FirebaseFireStoreServices();
                                  instance.createDocumentWithId(
                                    'chats',
                                    data[index].chatDocId,
                                    chatModel.toJson(),
                                  );
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MessageRoom(
                                      userProfile: user,
                                      chatRoomModel: data[index],
                                      userNotFound: data[index].participants.length==1?true:false,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Padding(padding: EdgeInsets.all(5)),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 250.0),
                        child: Center(
                          child: CustomText(
                            text: isSearching ? "No user found" : "No Messages!",
                            fontSize: 15,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


