import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:repository/src/model/abstract_repository_entity.dart';

part '../../generated/src/model/appointment_entity.g.dart';


@HiveType(typeId: 1)
@JsonSerializable()
class AppointmentEntity extends AbstractRepositoryEntity {
  const AppointmentEntity({
    required id,
    required userId,
    required updatedAt,
    required this.appointmentTitle,
    required this.appointmentDateTime
  }) : super(id: id, userId: userId, updatedAt: updatedAt);

  @HiveField(3)
  final String appointmentTitle;

  @HiveField(4)
  final String appointmentDateTime;

  @override
  factory AppointmentEntity.fromJson(Map<String, dynamic>? entity)
    => _$AppointmentEntityFromJson(entity!);

  @override
  Map<String, dynamic> toJson() => _$AppointmentEntityToJson(this);

  factory AppointmentEntity.empty() => const AppointmentEntity(
      id: "",
      userId: "",
      appointmentTitle: "",
      appointmentDateTime: "",
      updatedAt: ""
  );

  @override
  List<Object?> get props => [appointmentTitle, appointmentDateTime];

  static String get pluralName => "appointments";

  static String get singularName => "appointment";

  DateTime get dateTime => DateTime.parse(appointmentDateTime);
}
