// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BooksModel {

 String get userID; String get type; DateTime? get createdAt; String get category; String get grade; String get location; String get description; String get board; List<String> get subjects; String get imageUrl;
/// Create a copy of BooksModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BooksModelCopyWith<BooksModel> get copyWith => _$BooksModelCopyWithImpl<BooksModel>(this as BooksModel, _$identity);

  /// Serializes this BooksModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BooksModel&&(identical(other.userID, userID) || other.userID == userID)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.board, board) || other.board == board)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userID,type,createdAt,category,grade,location,description,board,const DeepCollectionEquality().hash(subjects),imageUrl);

@override
String toString() {
  return 'BooksModel(userID: $userID, type: $type, createdAt: $createdAt, category: $category, grade: $grade, location: $location, description: $description, board: $board, subjects: $subjects, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $BooksModelCopyWith<$Res>  {
  factory $BooksModelCopyWith(BooksModel value, $Res Function(BooksModel) _then) = _$BooksModelCopyWithImpl;
@useResult
$Res call({
 String userID, String type, DateTime? createdAt, String category, String grade, String location, String description, String board, List<String> subjects, String imageUrl
});




}
/// @nodoc
class _$BooksModelCopyWithImpl<$Res>
    implements $BooksModelCopyWith<$Res> {
  _$BooksModelCopyWithImpl(this._self, this._then);

  final BooksModel _self;
  final $Res Function(BooksModel) _then;

/// Create a copy of BooksModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userID = null,Object? type = null,Object? createdAt = freezed,Object? category = null,Object? grade = null,Object? location = null,Object? description = null,Object? board = null,Object? subjects = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BooksModel implements BooksModel {
  const _BooksModel({this.userID = '', this.type = '', this.createdAt, this.category = '', this.grade = '', this.location = '', this.description = '', this.board = '', final  List<String> subjects = const [], this.imageUrl = ''}): _subjects = subjects;
  factory _BooksModel.fromJson(Map<String, dynamic> json) => _$BooksModelFromJson(json);

@override@JsonKey() final  String userID;
@override@JsonKey() final  String type;
@override final  DateTime? createdAt;
@override@JsonKey() final  String category;
@override@JsonKey() final  String grade;
@override@JsonKey() final  String location;
@override@JsonKey() final  String description;
@override@JsonKey() final  String board;
 final  List<String> _subjects;
@override@JsonKey() List<String> get subjects {
  if (_subjects is EqualUnmodifiableListView) return _subjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjects);
}

@override@JsonKey() final  String imageUrl;

/// Create a copy of BooksModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BooksModelCopyWith<_BooksModel> get copyWith => __$BooksModelCopyWithImpl<_BooksModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BooksModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BooksModel&&(identical(other.userID, userID) || other.userID == userID)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.board, board) || other.board == board)&&const DeepCollectionEquality().equals(other._subjects, _subjects)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userID,type,createdAt,category,grade,location,description,board,const DeepCollectionEquality().hash(_subjects),imageUrl);

@override
String toString() {
  return 'BooksModel(userID: $userID, type: $type, createdAt: $createdAt, category: $category, grade: $grade, location: $location, description: $description, board: $board, subjects: $subjects, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$BooksModelCopyWith<$Res> implements $BooksModelCopyWith<$Res> {
  factory _$BooksModelCopyWith(_BooksModel value, $Res Function(_BooksModel) _then) = __$BooksModelCopyWithImpl;
@override @useResult
$Res call({
 String userID, String type, DateTime? createdAt, String category, String grade, String location, String description, String board, List<String> subjects, String imageUrl
});




}
/// @nodoc
class __$BooksModelCopyWithImpl<$Res>
    implements _$BooksModelCopyWith<$Res> {
  __$BooksModelCopyWithImpl(this._self, this._then);

  final _BooksModel _self;
  final $Res Function(_BooksModel) _then;

/// Create a copy of BooksModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userID = null,Object? type = null,Object? createdAt = freezed,Object? category = null,Object? grade = null,Object? location = null,Object? description = null,Object? board = null,Object? subjects = null,Object? imageUrl = null,}) {
  return _then(_BooksModel(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,subjects: null == subjects ? _self._subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ClothesModel {

 String get userID; String get type; String get size; DateTime? get createdAt; String get description; String get location; String get category; String get imageUrl;
/// Create a copy of ClothesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClothesModelCopyWith<ClothesModel> get copyWith => _$ClothesModelCopyWithImpl<ClothesModel>(this as ClothesModel, _$identity);

  /// Serializes this ClothesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClothesModel&&(identical(other.userID, userID) || other.userID == userID)&&(identical(other.type, type) || other.type == type)&&(identical(other.size, size) || other.size == size)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userID,type,size,createdAt,description,location,category,imageUrl);

@override
String toString() {
  return 'ClothesModel(userID: $userID, type: $type, size: $size, createdAt: $createdAt, description: $description, location: $location, category: $category, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $ClothesModelCopyWith<$Res>  {
  factory $ClothesModelCopyWith(ClothesModel value, $Res Function(ClothesModel) _then) = _$ClothesModelCopyWithImpl;
@useResult
$Res call({
 String userID, String type, String size, DateTime? createdAt, String description, String location, String category, String imageUrl
});




}
/// @nodoc
class _$ClothesModelCopyWithImpl<$Res>
    implements $ClothesModelCopyWith<$Res> {
  _$ClothesModelCopyWithImpl(this._self, this._then);

  final ClothesModel _self;
  final $Res Function(ClothesModel) _then;

/// Create a copy of ClothesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userID = null,Object? type = null,Object? size = null,Object? createdAt = freezed,Object? description = null,Object? location = null,Object? category = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ClothesModel implements ClothesModel {
  const _ClothesModel({this.userID = '', this.type = '', this.size = '', this.createdAt, this.description = '', this.location = '', this.category = '', this.imageUrl = ''});
  factory _ClothesModel.fromJson(Map<String, dynamic> json) => _$ClothesModelFromJson(json);

@override@JsonKey() final  String userID;
@override@JsonKey() final  String type;
@override@JsonKey() final  String size;
@override final  DateTime? createdAt;
@override@JsonKey() final  String description;
@override@JsonKey() final  String location;
@override@JsonKey() final  String category;
@override@JsonKey() final  String imageUrl;

/// Create a copy of ClothesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClothesModelCopyWith<_ClothesModel> get copyWith => __$ClothesModelCopyWithImpl<_ClothesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClothesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClothesModel&&(identical(other.userID, userID) || other.userID == userID)&&(identical(other.type, type) || other.type == type)&&(identical(other.size, size) || other.size == size)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userID,type,size,createdAt,description,location,category,imageUrl);

@override
String toString() {
  return 'ClothesModel(userID: $userID, type: $type, size: $size, createdAt: $createdAt, description: $description, location: $location, category: $category, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ClothesModelCopyWith<$Res> implements $ClothesModelCopyWith<$Res> {
  factory _$ClothesModelCopyWith(_ClothesModel value, $Res Function(_ClothesModel) _then) = __$ClothesModelCopyWithImpl;
@override @useResult
$Res call({
 String userID, String type, String size, DateTime? createdAt, String description, String location, String category, String imageUrl
});




}
/// @nodoc
class __$ClothesModelCopyWithImpl<$Res>
    implements _$ClothesModelCopyWith<$Res> {
  __$ClothesModelCopyWithImpl(this._self, this._then);

  final _ClothesModel _self;
  final $Res Function(_ClothesModel) _then;

/// Create a copy of ClothesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userID = null,Object? type = null,Object? size = null,Object? createdAt = freezed,Object? description = null,Object? location = null,Object? category = null,Object? imageUrl = null,}) {
  return _then(_ClothesModel(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
