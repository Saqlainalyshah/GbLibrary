import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class BooksModel with _$BooksModel {
  const factory BooksModel({
    @Default('') String userID,
    @Default('') String type,
     DateTime? createdAt,
    @Default('') String category,
    @Default('') String grade,
    @Default('') String location,
    @Default('') String description,
    @Default('') String board,
    @Default([]) List<String> subjects,
    @Default('') String imageUrl,

  }) = _BooksModel;
  factory BooksModel.fromJson(Map<String, dynamic> json) => _$BooksModelFromJson(json);
}


@freezed
abstract class ClothesModel with _$ClothesModel {
  const factory ClothesModel({
     @Default('')  String userID,
     @Default('')  String type,
     @Default('')  String size,
      DateTime? createdAt,
     @Default('')  String description,
     @Default('')  String location,
     @Default('')  String category,
     @Default('')  String imageUrl,

  }) = _ClothesModel;
  factory ClothesModel.fromJson(Map<String, dynamic> json) => _$ClothesModelFromJson(json);
}


class User{
  String profileName;
  Timestamp createdAt;
  User({
    required this.profileName,
    required this.createdAt,
});
}