// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 0;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      id: fields[0] as String,
      email: fields[5] as String,
      timestamp: fields[1] as DateTime,
      message: fields[2] as String,
      likeEmails: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.likeEmails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
