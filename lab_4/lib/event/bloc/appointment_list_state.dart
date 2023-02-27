import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

enum AppointmentListStatus { initial, loading, success, failure }

class AppointmentListState extends Equatable {
  const AppointmentListState({
    this.status = AppointmentListStatus.initial,
    this.appointments = const [],
    this.filter = AppointmentViewFilter.all,
    this.lastDeleted,
  });

  final AppointmentListStatus status;
  final List<AppointmentEntity> appointments;
  final AppointmentViewFilter filter;
  final AppointmentEntity? lastDeleted;

  Iterable<AppointmentEntity> get filteredAppointments => filter.applyAll(appointments);

  AppointmentListState copyWith({
    AppointmentListStatus Function()? status,
    List<AppointmentEntity> Function()? appointments,
    AppointmentViewFilter Function()? filter,
    AppointmentEntity? Function()? lastDeleted,
  }) {
    return AppointmentListState(
      status: status != null ? status() : this.status,
      appointments: appointments != null ? appointments() : this.appointments,
      filter: filter != null ? filter() : this.filter,
      lastDeleted: lastDeleted != null ? lastDeleted() : this.lastDeleted
    );
  }

  @override
  List<Object?> get props => [
    status,
    appointments,
    filter,
    lastDeleted
  ];
}