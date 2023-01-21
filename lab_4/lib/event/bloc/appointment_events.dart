import 'package:equatable/equatable.dart';

import '../model/appointment_model.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

class AddAppointment extends AppointmentEvent {
  final AppointmentModel appointment;

  const AddAppointment(this.appointment);

  @override
  List<Object> get props => [appointment];

  @override
  String toString() => 'AddAppointment {$appointment}';
}

class RemoveAppointment extends AppointmentEvent {
  final AppointmentModel appointment;

  const RemoveAppointment(this.appointment);

  @override
  List<Object> get props => [appointment];

  @override
  String toString() => 'RemoveAppointment {$appointment}';
}