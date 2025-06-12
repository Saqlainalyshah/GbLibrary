// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  profilePicUrl: json['profilePicUrl'] as String? ?? '',
  name: json['name'] as String,
  gender: json['gender'] as String? ?? '',
  address: json['address'] as String? ?? '',
  number: json['number'] as String? ?? '',
  email: json['email'] as String,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'profilePicUrl': instance.profilePicUrl,
      'name': instance.name,
      'gender': instance.gender,
      'address': instance.address,
      'number': instance.number,
      'email': instance.email,
    };
