// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../src/model/appointment_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentEntityAdapter extends TypeAdapter<AppointmentEntity> {
  @override
  final int typeId = 1;

  @override
  AppointmentEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentEntity(
      id: fields[0] as dynamic,
      userId: fields[1] as dynamic,
      updatedAt: fields[2] as dynamic,
      appointmentTitle: fields[3] as String,
      appointmentDateTime: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(3)
      ..write(obj.appointmentTitle)
      ..writeByte(4)
      ..write(obj.appointmentDateTime)
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
      other is AppointmentEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentEntity _$AppointmentEntityFromJson(Map<String, dynamic> json) =>
    AppointmentEntity(
      id: json['id'],
      userId: json['userId'],
      updatedAt: json['updatedAt'],
      appointmentTitle: json['appointmentTitle'] as String,
      appointmentDateTime: json['appointmentDateTime'] as String,
    );

Map<String, dynamic> _$AppointmentEntityToJson(AppointmentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'updatedAt': instance.updatedAt,
      'appointmentTitle': instance.appointmentTitle,
      'appointmentDateTime': instance.appointmentDateTime,
    };
