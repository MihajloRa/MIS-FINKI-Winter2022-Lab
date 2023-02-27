import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];

}

class AddAppointment extends AppointmentEvent {
  final AppointmentEntity appointment;

  const AddAppointment(this.appointment);

  @override
  String toString() => 'Added appointment {$appointment}';

  @override
  List<Object> get props => [appointment];
}

class RemoveAppointment extends AppointmentEvent {
  final AppointmentEntity appointment;

  const RemoveAppointment(this.appointment);

  @override
  List<Object> get props => [appointment];

  @override
  String toString() => 'Removed appointment {$appointment}';
}

class FetchAppointments extends AppointmentEvent {
  const FetchAppointments();
}

class AppointmentsFilterChanged extends AppointmentEvent {
  const AppointmentsFilterChanged(this.filter);

  final AppointmentViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class AppointmentUndoRemove extends AppointmentEvent {
  const AppointmentUndoRemove();
}
