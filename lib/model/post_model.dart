import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class BooksModel with _$BooksModel {
  const factory BooksModel({
    required String userID,
    required String type,
    required String category,
    required String grade,
    required String location,
    required String description,
    required String board,
    required List<String> subjects,
    required String imageUrl,

  }) = _BooksModel;
  factory BooksModel.fromJson(Map<String, dynamic> json) => _$BooksModelFromJson(json);
}


@freezed
abstract class ClothesModel with _$ClothesModel {
  const factory ClothesModel({
    required String userID,
    required String type,
    required String size,
    required String description,
    required String location,
    required String category,
    required String imageUrl,

  }) = _ClothesModel;
  factory ClothesModel.fromJson(Map<String, dynamic> json) => _$ClothesModelFromJson(json);
}

