import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_4/event/bloc/appointment_bloc.dart';
import 'package:lab_4/event/bloc/appointment_list_state.dart';
import 'package:lab_4/event/screen/create_appointment_screen.dart';

import '../model/appointment_model.dart';
import '../widgets/appointment_tile.dart';
import '../widgets/new_appointment.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    return  BlocConsumer<AppointmentBloc, AppointmentListState>(
        buildWhen: (prev, curr) => curr is AppointmentAdded || curr is AppointmentRemoved,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      state.toString()
                  )
              )
          );
        },
        builder: (context, state) =>
            LayoutBuilder(
                builder: (context, constraints) =>
                state.appointmentList.isNotEmpty
                    ? ListView.builder(
                    itemCount: 100,
                    itemBuilder: (context, ind) =>
                        AppointmentTile(
                          appointment: state.appointmentList.elementAt(ind),
                        )
                )
                    : ListView()
            )
    );
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    return AppBar(
      // The title text which will be shown on the action bar
        title: const Text("Event Planner"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>  Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) =>  AppointmentBloc(),
                      child: const CreateNewAppointment()
                  ),
                )
            ),
          )
        ]
    );
  }
}