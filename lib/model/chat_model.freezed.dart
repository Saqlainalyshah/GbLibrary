// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomModel {

 List<String> get participants; List<String> get deleteChatFrom; List<UserProfile> get users; DateTime get createdAt; String get lastMessage; bool get isRead; String get lastMessageFrom;
/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomModelCopyWith<ChatRoomModel> get copyWith => _$ChatRoomModelCopyWithImpl<ChatRoomModel>(this as ChatRoomModel, _$identity);

  /// Serializes this ChatRoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomModel&&const DeepCollectionEquality().equals(other.participants, participants)&&const DeepCollectionEquality().equals(other.deleteChatFrom, deleteChatFrom)&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.lastMessageFrom, lastMessageFrom) || other.lastMessageFrom == lastMessageFrom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(participants),const DeepCollectionEquality().hash(deleteChatFrom),const DeepCollectionEquality().hash(users),createdAt,lastMessage,isRead,lastMessageFrom);

@override
String toString() {
  return 'ChatRoomModel(participants: $participants, deleteChatFrom: $deleteChatFrom, users: $users, createdAt: $createdAt, lastMessage: $lastMessage, isRead: $isRead, lastMessageFrom: $lastMessageFrom)';
}


}

/// @nodoc
abstract mixin class $ChatRoomModelCopyWith<$Res>  {
  factory $ChatRoomModelCopyWith(ChatRoomModel value, $Res Function(ChatRoomModel) _then) = _$ChatRoomModelCopyWithImpl;
@useResult
$Res call({
 List<String> participants, List<String> deleteChatFrom, List<UserProfile> users, DateTime createdAt, String lastMessage, bool isRead, String lastMessageFrom
});




}
/// @nodoc
class _$ChatRoomModelCopyWithImpl<$Res>
    implements $ChatRoomModelCopyWith<$Res> {
  _$ChatRoomModelCopyWithImpl(this._self, this._then);

  final ChatRoomModel _self;
  final $Res Function(ChatRoomModel) _then;

/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participants = null,Object? deleteChatFrom = null,Object? users = null,Object? createdAt = null,Object? lastMessage = null,Object? isRead = null,Object? lastMessageFrom = null,}) {
  return _then(_self.copyWith(
participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<String>,deleteChatFrom: null == deleteChatFrom ? _self.deleteChatFrom : deleteChatFrom // ignore: cast_nullable_to_non_nullable
as List<String>,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<UserProfile>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,lastMessageFrom: null == lastMessageFrom ? _self.lastMessageFrom : lastMessageFrom // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ChatRoomModel implements ChatRoomModel {
  const _ChatRoomModel({final  List<String> participants = const [], final  List<String> deleteChatFrom = const [], final  List<UserProfile> users = const [], required this.createdAt, this.lastMessage = '', this.isRead = false, this.lastMessageFrom = ''}): _participants = participants,_deleteChatFrom = deleteChatFrom,_users = users;
  factory _ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);

 final  List<String> _participants;
@override@JsonKey() List<String> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  List<String> _deleteChatFrom;
@override@JsonKey() List<String> get deleteChatFrom {
  if (_deleteChatFrom is EqualUnmodifiableListView) return _deleteChatFrom;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deleteChatFrom);
}

 final  List<UserProfile> _users;
@override@JsonKey() List<UserProfile> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override final  DateTime createdAt;
@override@JsonKey() final  String lastMessage;
@override@JsonKey() final  bool isRead;
@override@JsonKey() final  String lastMessageFrom;

/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomModelCopyWith<_ChatRoomModel> get copyWith => __$ChatRoomModelCopyWithImpl<_ChatRoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomModel&&const DeepCollectionEquality().equals(other._participants, _participants)&&const DeepCollectionEquality().equals(other._deleteChatFrom, _deleteChatFrom)&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.lastMessageFrom, lastMessageFrom) || other.lastMessageFrom == lastMessageFrom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_deleteChatFrom),const DeepCollectionEquality().hash(_users),createdAt,lastMessage,isRead,lastMessageFrom);

@override
String toString() {
  return 'ChatRoomModel(participants: $participants, deleteChatFrom: $deleteChatFrom, users: $users, createdAt: $createdAt, lastMessage: $lastMessage, isRead: $isRead, lastMessageFrom: $lastMessageFrom)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomModelCopyWith<$Res> implements $ChatRoomModelCopyWith<$Res> {
  factory _$ChatRoomModelCopyWith(_ChatRoomModel value, $Res Function(_ChatRoomModel) _then) = __$ChatRoomModelCopyWithImpl;
@override @useResult
$Res call({
 List<String> participants, List<String> deleteChatFrom, List<UserProfile> users, DateTime createdAt, String lastMessage, bool isRead, String lastMessageFrom
});




}
/// @nodoc
class __$ChatRoomModelCopyWithImpl<$Res>
    implements _$ChatRoomModelCopyWith<$Res> {
  __$ChatRoomModelCopyWithImpl(this._self, this._then);

  final _ChatRoomModel _self;
  final $Res Function(_ChatRoomModel) _then;

/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participants = null,Object? deleteChatFrom = null,Object? users = null,Object? createdAt = null,Object? lastMessage = null,Object? isRead = null,Object? lastMessageFrom = null,}) {
  return _then(_ChatRoomModel(
participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<String>,deleteChatFrom: null == deleteChatFrom ? _self._deleteChatFrom : deleteChatFrom // ignore: cast_nullable_to_non_nullable
as List<String>,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<UserProfile>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,lastMessageFrom: null == lastMessageFrom ? _self.lastMessageFrom : lastMessageFrom // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
