import 'package:bloc/bloc.dart';
import 'package:lab_4/event/bloc/appointment_events.dart';
import 'package:lab_4/event/bloc/appointment_list_state.dart';

import '../model/appointment_model.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentListState> {
  AppointmentBloc() : super(const AppointmentAdded(appointmentList: [])) {


    on<AddAppointment>((event, emit) {
      !appointments.contains(event.appointment)
      ?  {
        _appointments.add(event.appointment),
        emit(AppointmentAdded(appointmentList: _appointments))
      } : emit(AppointmentAlreadyExists(appointmentList: _appointments));
    });

    on<RemoveAppointment>((event, emit) {
      appointments.contains(event.appointment)
      ? {
        _appointments.remove(event.appointment),
        emit(AppointmentRemoved(appointmentList: _appointments))
      } : emit(AppointmentRemoved(appointmentList: _appointments));
    });
  }

  final List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;

  Future<void> _mapAppointmentAddedEvent(
      AddAppointment event,
      Emitter<AppointmentListState> emitter
      ) async {

  }
}