// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String,
  profilePicUrl: json['profilePicUrl'] as String? ?? '',
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  gender: json['gender'] as String? ?? '',
  address: json['address'] as String? ?? '',
  number: json['number'] as String? ?? '',
  email: json['email'] as String,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'profilePicUrl': instance.profilePicUrl,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'number': instance.number,
      'email': instance.email,
    };
