import '../model/appointment_model.dart';

abstract class AppointmentListState {
  final List<AppointmentModel> appointmentList;
  const AppointmentListState({required this.appointmentList});

  @override
  List<Object> get props => [];
}

class AppointmentListLoadInProgress extends AppointmentListState {
  AppointmentListLoadInProgress({required super.appointmentList});
}

class AppointmentAdded extends AppointmentListState {
  final List<AppointmentModel> appointmentList;

  const AppointmentAdded({required this.appointmentList})
      : super(appointmentList: appointmentList);

  @override
  List<Object> get props => [appointmentList];

  @override
  String toString() => 'Appointment added {$appointmentList}';
}

class AppointmentAlreadyExists extends AppointmentListState {
  final List<AppointmentModel> appointmentList;

  const AppointmentAlreadyExists({required this.appointmentList})
    : super(appointmentList: appointmentList);

  @override
  List<Object> get props => [appointmentList];

  @override
  String toString() => 'Appointment already exists.';
}

class AppointmentRemoved extends AppointmentListState {
  final List<AppointmentModel> appointmentList;

  const AppointmentRemoved({required this.appointmentList})
      : super(appointmentList: appointmentList);

  @override
  List<Object> get props => [appointmentList];

  @override
  String toString() => 'Appointment removed {$appointmentList}';
}

class AppointmentDoesNotExist extends AppointmentListState {
  final List<AppointmentModel> appointmentList;

  const AppointmentDoesNotExist({required this.appointmentList})
      : super(appointmentList: appointmentList);

  @override
  List<Object> get props => [appointmentList];

  @override
  String toString() => 'Appointment does not exist.';
}