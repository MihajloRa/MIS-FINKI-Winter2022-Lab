import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_4/event/bloc/appointment_events.dart';


import 'package:repository/repository.dart';
import '../bloc/appointment_bloc.dart';

class AppointmentTile extends StatelessWidget {
  final AppointmentEntity appointment;

  const AppointmentTile ({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.all(10.0),
       child: ListTile(
         title: Text(appointment.appointmentTitle),
         subtitle: Text(appointment.appointmentDateTime),
         trailing: IconButton(
           icon: const Icon(Icons.delete),
           onPressed: () => BlocProvider.of<AppointmentBloc>(context)
            .add(RemoveAppointment(appointment))
         ),
       ),
    );
  }
}