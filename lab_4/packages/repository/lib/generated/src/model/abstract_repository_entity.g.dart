// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../src/model/abstract_repository_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbstractRepositoryEntityAdapter
    extends TypeAdapter<AbstractRepositoryEntity> {
  @override
  final int typeId = 0;

  @override
  AbstractRepositoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AbstractRepositoryEntity(
      id: fields[0] as String,
      userId: fields[1] as String,
      updatedAt: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AbstractRepositoryEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbstractRepositoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbstractRepositoryEntity _$AbstractRepositoryEntityFromJson(
        Map<String, dynamic> json) =>
    AbstractRepositoryEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$AbstractRepositoryEntityToJson(
        AbstractRepositoryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'updatedAt': instance.updatedAt,
    };
