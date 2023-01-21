import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String id;
  final String appointmentTitle;
  final String appointmentDateTime;

  const AppointmentModel({
    required this.id,
    required this.appointmentTitle,
    required this.appointmentDateTime
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    id: json['id'] ?? "",
    appointmentTitle: json['appointmentTitle'] ?? "",
    appointmentDateTime: json['appointmentDateTime'] ??  ""
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'appointmentTitle': appointmentTitle,
    'appointmentDateTime': appointmentDateTime,
  };

  factory AppointmentModel.empty() => const AppointmentModel(
    id: "",
    appointmentTitle: "",
    appointmentDateTime: ""
  );

  @override
  List<Object?> get props => [appointmentTitle, appointmentDateTime];
}
