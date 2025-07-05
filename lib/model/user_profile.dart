import 'package:booksexchange/model/post_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String userDocId,
    required String uid,
    @Default('') String profilePicUrl,
    required String name,
    required DateTime createdAt,
  //  @TimestampSerializer() required DateTime createdAt,
    @Default('') String gender,
    @Default('') String address,
    @Default('') String number,
    required String email,

  }) = _UserProfile;
  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

