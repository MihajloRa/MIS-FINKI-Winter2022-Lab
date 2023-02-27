import 'package:repository/repository.dart';

enum AppointmentViewFilter { all, pastAppointment, futureAppointments }

extension AppointmentViewFilterX on AppointmentViewFilter {
  bool apply(AppointmentEntity entity) {
    switch (this) {
      case AppointmentViewFilter.all:
        return true;
      case AppointmentViewFilter.pastAppointment:
        return DateTime.now().isAfter(DateTime.parse(entity.appointmentDateTime));
      case AppointmentViewFilter.futureAppointments:
        return DateTime.now().isBefore(DateTime.parse(entity.appointmentDateTime));
    }
  }

  Iterable<AppointmentEntity> applyAll(Iterable<AppointmentEntity> entities) {
    return entities.where(apply);
  }

}