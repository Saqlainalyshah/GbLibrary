// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) =>
    _ChatRoomModel(
      chatDocId: json['chatDocId'] as String? ?? '',
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deleteChatFrom:
          (json['deleteChatFrom'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      users:
          (json['users'] as List<dynamic>?)
              ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessage: json['lastMessage'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      lastMessageFrom: json['lastMessageFrom'] as String? ?? '',
    );

Map<String, dynamic> _$ChatRoomModelToJson(_ChatRoomModel instance) =>
    <String, dynamic>{
      'chatDocId': instance.chatDocId,
      'participants': instance.participants,
      'deleteChatFrom': instance.deleteChatFrom,
      'users': instance.users.map((user)=>user.toJson()),
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMessage': instance.lastMessage,
      'isRead': instance.isRead,
      'lastMessageFrom': instance.lastMessageFrom,
    };
