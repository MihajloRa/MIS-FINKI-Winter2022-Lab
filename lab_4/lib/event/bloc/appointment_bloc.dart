import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lab_4/event/bloc/appointment_events.dart';
import 'package:lab_4/event/bloc/appointment_list_state.dart';
import 'package:repository/repository.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentListState> {
  AppointmentBloc() : super(const AppointmentListState()) {
    _appointmentRepository =
        GetIt.instance.get(instanceName: "appointmentRepository");
    on<AppointmentEvent>((event,emitter) async => _mapEventToState(event, emitter));
  }

  late final Repository<AppointmentEntity> _appointmentRepository;

  Future<void> _mapEventToState(AppointmentEvent event,
      Emitter<AppointmentListState> emit) async {
    if (event is AddAppointment) {
      await _mapAddAppointmentEvent(event, emit);
    } else if (event is RemoveAppointment) {
      await _mapRemoveAppointmentEvent(event, emit);
    } else if (event is FetchAppointments) {
      await _mapFetchAppointmentsEvent(event, emit);
    } else if (event is AppointmentsFilterChanged) {
      await _mapAppointmentsFilterChangeEvent(event, emit);
    } else if (event is AppointmentUndoRemove) {
      await _mapUndoRemoveEvent(event, emit);
    }
  }

  Future<void> _mapAddAppointmentEvent(AddAppointment event,
      Emitter<AppointmentListState> emit) async {
    assert(!state.appointments.contains(event.appointment), "Appointment already exists");
    assert(event.appointment != AppointmentEntity.empty(), "Can't save empty appointment");
    emit(state.copyWith(status: () => AppointmentListStatus.loading));

    List<AppointmentEntity> newAppointments = state.appointments;

    await _appointmentRepository.save(event.appointment)
    .then((appointments) => newAppointments = appointments)
    .whenComplete(() =>
      emit(state.copyWith(
        status: () => AppointmentListStatus.success,
        appointments: () => newAppointments,
      ))
    ).onError((error, stackTrace) {
      emit(state.copyWith(status: () => AppointmentListStatus.failure));
      return Future.error(error!, stackTrace);
    });

  }

  Future<void> _mapRemoveAppointmentEvent(
      RemoveAppointment event,
      Emitter<AppointmentListState> emit) async {
    assert(state.appointments.contains(event.appointment), "Appointment should exist");
    emit(state.copyWith(status: () => AppointmentListStatus.loading));

    List<AppointmentEntity> newAppointments = state.appointments;

    await _appointmentRepository.delete(event.appointment)
    .then((appointments) => newAppointments = appointments)
    .whenComplete(() =>
      emit(state.copyWith(
        status: () => AppointmentListStatus.success,
        appointments: () => newAppointments,
        lastDeleted: () => event.appointment,
      ))
    ).onError((error, stackTrace) {
      emit(state.copyWith(status: () => AppointmentListStatus.failure));
      return Future.error(error!, stackTrace);
    });

  }

  Future<void> _mapFetchAppointmentsEvent(FetchAppointments event,
      Emitter<AppointmentListState> emit) async {
    assert(state.appointments.isEmpty, "Appointments are already loaded");
    emit(state.copyWith(status: () => AppointmentListStatus.loading));

    List<AppointmentEntity> newAppointments = state.appointments;

    await _appointmentRepository.findAll()
    .then((appointments) => newAppointments = appointments)
    .whenComplete(() =>
      emit(state.copyWith(
        status: () => AppointmentListStatus.success,
        appointments: () => newAppointments,
      ))
    ).onError((error, stackTrace) {
      emit(state.copyWith(status: () => AppointmentListStatus.failure));
      return Future.error(error!, stackTrace);
    });

  }

  Future<void> _mapAppointmentsFilterChangeEvent(AppointmentsFilterChanged event,
      Emitter<AppointmentListState> emit) async {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _mapUndoRemoveEvent(AppointmentUndoRemove event,
      Emitter<AppointmentListState> emit) async {
    assert(state.lastDeleted != null , "No appointment has been deleted");
    emit(state.copyWith(status: () => AppointmentListStatus.loading));

    List<AppointmentEntity> newAppointments = state.appointments;

    await _appointmentRepository.save(state.lastDeleted!)
    .then((appointments) => newAppointments = appointments)
    .whenComplete(() =>
      emit(state.copyWith(
        status: () => AppointmentListStatus.success,
        appointments: () => newAppointments,
      ))
    ).onError((error, stackTrace) {
      emit(state.copyWith(status: () => AppointmentListStatus.failure));
      return Future.error(error!, stackTrace);
    });

  }

}