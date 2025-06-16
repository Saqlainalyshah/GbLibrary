// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BooksModel _$BooksModelFromJson(Map<String, dynamic> json) => _BooksModel(
  userID: json['userID'] as String,
  type: json['type'] as String,
  category: json['category'] as String,
  grade: json['grade'] as String,
  location: json['location'] as String,
  description: json['description'] as String,
  board: json['board'] as String,
  subjects: (json['subjects'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$BooksModelToJson(_BooksModel instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'type': instance.type,
      'category': instance.category,
      'grade': instance.grade,
      'location': instance.location,
      'description': instance.description,
      'board': instance.board,
      'subjects': instance.subjects,
      'imageUrl': instance.imageUrl,
    };

_ClothesModel _$ClothesModelFromJson(Map<String, dynamic> json) =>
    _ClothesModel(
      userID: json['userID'] as String,
      type: json['type'] as String,
      size: json['size'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$ClothesModelToJson(_ClothesModel instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'type': instance.type,
      'size': instance.size,
      'description': instance.description,
      'location': instance.location,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
    };
