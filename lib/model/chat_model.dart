
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

/// class for chat room creation

@freezed
sealed class ChatRoomModel with _$ChatRoomModel {
  const factory ChatRoomModel({
    @Default('') String chatDocId,
    @Default([]) List<String> participants,
    @Default([]) List<String> deleteChatFrom,
   @Default([]) List<UserProfile> users,
    required DateTime createdAt,
  //  @TimestampSerializer() required DateTime createdAt,
    @Default('') String lastMessage,
    @Default(false) bool isRead,
    @Default('') String lastMessageFrom,
  }) = _ChatRoomModel;
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);
}

