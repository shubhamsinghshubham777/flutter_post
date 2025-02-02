// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<String> get likeEmails => throw _privateConstructorUsedError;

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call(
      {String id,
      String email,
      @TimestampConverter() DateTime timestamp,
      String message,
      List<String> likeEmails});
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? timestamp = null,
    Object? message = null,
    Object? likeEmails = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      likeEmails: null == likeEmails
          ? _value.likeEmails
          : likeEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
          _$PostImpl value, $Res Function(_$PostImpl) then) =
      __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      @TimestampConverter() DateTime timestamp,
      String message,
      List<String> likeEmails});
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
      : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? timestamp = null,
    Object? message = null,
    Object? likeEmails = null,
  }) {
    return _then(_$PostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      likeEmails: null == likeEmails
          ? _value._likeEmails
          : likeEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostImpl with DiagnosticableTreeMixin implements _Post {
  const _$PostImpl(
      {required this.id,
      required this.email,
      @TimestampConverter() required this.timestamp,
      required this.message,
      required final List<String> likeEmails})
      : _likeEmails = likeEmails;

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @TimestampConverter()
  final DateTime timestamp;
  @override
  final String message;
  final List<String> _likeEmails;
  @override
  List<String> get likeEmails {
    if (_likeEmails is EqualUnmodifiableListView) return _likeEmails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likeEmails);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Post(id: $id, email: $email, timestamp: $timestamp, message: $message, likeEmails: $likeEmails)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Post'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('likeEmails', likeEmails));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._likeEmails, _likeEmails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, timestamp, message,
      const DeepCollectionEquality().hash(_likeEmails));

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(
      this,
    );
  }
}

abstract class _Post implements Post {
  const factory _Post(
      {required final String id,
      required final String email,
      @TimestampConverter() required final DateTime timestamp,
      required final String message,
      required final List<String> likeEmails}) = _$PostImpl;

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  @TimestampConverter()
  DateTime get timestamp;
  @override
  String get message;
  @override
  List<String> get likeEmails;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
