// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      message: json['message'] as String,
      likeEmails: (json['likeEmails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
      'message': instance.message,
      'likeEmails': instance.likeEmails,
    };
