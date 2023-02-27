import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lab_4/auth/bloc/authentication_bloc.dart';
import 'package:lab_4/event/bloc/appointment_bloc.dart';
import 'package:lab_4/event/bloc/appointment_list_state.dart';
import 'package:lab_4/event/widgets/new_appointment.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/appointment_events.dart';
import '../widgets/appointment_calendar.dart';
import '../widgets/appointment_tile.dart';


class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState();

}


class _AppointmentListState extends State<AppointmentList> {
  bool _isListView = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentBloc>(
        create: (context) => GetIt.instance<AppointmentBloc>()
        ,child: Scaffold(
          appBar: _createAppBar(context),
          body: _createBody(),
        ),
    );
  }

  Widget _createBody() {
    return  BlocConsumer<AppointmentBloc, AppointmentListState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    state.toString()
                )
            )
        );
      },
      builder: (context, state) {
        if (state.status == AppointmentListStatus.success
          || state.status == AppointmentListStatus.failure) {
          return _isListView
            ? LayoutBuilder(
              builder: (context, constraints) =>
              state.appointments.isNotEmpty
              ? ListView.builder(
                  itemCount: state.appointments.length,
                  itemBuilder: (context, ind) =>
                    AppointmentTile(
                      appointment: state.appointments.elementAt(ind)
                    )
              ) : ListView())
            : const AppointmentCalendar();
        } else {
          BlocProvider.of<AppointmentBloc>(context).add(const FetchAppointments());
          return const Center(child: CircularProgressIndicator());
        }
      });
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    return AppBar(
      // The title text which will be shown on the action bar
        leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthenticationBloc>().add(UserSignOutEvent()),
          ),
        title:  const Text("Appointments"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openDialog(context),
          ),
          IconButton(
            icon: _isListView
              ? const Icon(Icons.calendar_today)
              : const Icon(Icons.view_list),
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
          ),
        ]
    );
  }

  Future<void> _openDialog(BuildContext ct) async {
    showDialog (
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Wrap(
                  children: const [
                    NewAppointmentDialog()
                  ]
              )
          );
        });
  }
}