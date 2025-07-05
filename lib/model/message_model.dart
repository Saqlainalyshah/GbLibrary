import 'package:booksexchange/model/post_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_model.freezed.dart';
part 'message_model.g.dart';
///Class for sending messages

@freezed
sealed class MessageModel with _$MessageModel {
  const factory MessageModel({
    @Default('') String messageDocId,
    required String userName,
    required  String userPic,
   @Default([]) List<String> reactions,
    required String userId,
    required DateTime createdAt,
  //  @TimestampSerializer() required DateTime createdAt,
    required String message,
    @Default(false) bool isRead,
  }) = _MessageModel;
  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
}
