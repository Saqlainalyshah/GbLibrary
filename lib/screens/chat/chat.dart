import 'dart:async';

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


class ChatIds {
  final ChatRoomModel chatRoomModel;
  final String docId;
  final bool userNotFound;
  ChatIds({required this.chatRoomModel, required this.docId, required this.userNotFound});
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'chatRoomModel': chatRoomModel.toJson(), 'docId': docId, 'userNotFound':userNotFound};
  }

  // Construct from JSON
  factory ChatIds.fromJson(Map<String, dynamic> json) {
    return ChatIds(
      chatRoomModel: ChatRoomModel.fromJson(json['chatRoomModel']),
      docId: json['docId'],
        userNotFound:json['userNotFound']
    );
  }
}




class FilterChats {
  final List<ChatIds> allChats;
  final List<ChatIds> filteredChats;
  final int unreadMessageCount;

  FilterChats({
    required this.allChats,
    required this.filteredChats,
    required this.unreadMessageCount,
  });

  FilterChats copyWith({
    List<ChatIds>? allChats,
    List<ChatIds>? filteredChats,
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
        return ChatIds(
          chatRoomModel: decoded,
          docId: doc.id,
          userNotFound: decoded.participants.length==1?true:false
        );
      }).toList();

      final unreadCount = chatsData.where((chat) =>
      chat.chatRoomModel.isRead == false &&
          chat.chatRoomModel.lastMessageFrom != uid,
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

  void setChats(List<ChatIds> chats, String uid) {
    final unreadCount = chats.where((chat) =>
    chat.chatRoomModel.isRead == false &&
        chat.chatRoomModel.lastMessageFrom != uid,
    ).length;
    state = state.copyWith(
      allChats: chats,
      filteredChats: chats,
      unreadMessageCount: unreadCount,
    );
  }

  void filterChatRoomsByUser(bool Function(UserProfile user) condition) {
    final filtered = state.allChats.where((chatRoom) {
      return chatRoom.chatRoomModel.users.any(condition);
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
    print("ChatScreen build called at: ${DateTime.now()}");

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
                          final UserProfile user = data[index].chatRoomModel.users.firstWhere(
                                (user) => user.uid != FirebaseAuth.instance.currentUser!.uid,
                          );

                          bool isMe = data[index].chatRoomModel.lastMessageFrom ==
                              FirebaseAuth.instance.currentUser!.uid;

                          bool newMessage = data[index].chatRoomModel.isRead;

                          return ListTileCard(
                            isIcon: true,
                            newMessage: newMessage,
                            isMe: isMe,
                            time: data[index].chatRoomModel.createdAt.toString(),
                            title: user.name,
                            subTitle: data[index].chatRoomModel.lastMessage,
                            imageUrl: user.profilePicUrl,
                            function: () {
                              ChatRoomModel model = data[index].chatRoomModel;

                              if (!isMe && !model.isRead) {
                                final chatModel = model.copyWith(isRead: true);
                                FirebaseFireStoreServices instance = FirebaseFireStoreServices();
                                instance.createDocumentWithId(
                                  'chats',
                                  data[index].docId,
                                  chatModel.toJson(),
                                );
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MessageRoom(
                                    userProfile: user,
                                    chatIds: data[index],
                                    userNotFound: data[index].userNotFound,
                                  ),
                                ),
                              );
                            },
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


