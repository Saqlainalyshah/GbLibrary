// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      userName: json['userName'] as String,
      userPic: json['userPic'] as String,
      reactions:
          (json['reactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      message: json['message'] as String,
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userPic': instance.userPic,
      'reactions': instance.reactions,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'message': instance.message,
      'isRead': instance.isRead,
    };
