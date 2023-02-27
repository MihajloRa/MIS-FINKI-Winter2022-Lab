import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lab_4/event/bloc/appointment_events.dart';

import 'package:nanoid/async.dart';
import 'package:repository/repository.dart';

import '../../auth/bloc/authentication_bloc.dart';
import '../bloc/appointment_bloc.dart';
import 'add_appointment_button.dart';

class NewAppointmentDialog extends StatefulWidget {

  const NewAppointmentDialog({super.key});
  @override
  State<StatefulWidget> createState() => _NewAppointmentDialogState();
}

class _NewAppointmentDialogState extends State<NewAppointmentDialog> {
  final _eventTitleController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();

  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  late String appointmentTitle;
  late DateTime appointmentDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day),
        lastDate: DateTime(selectedDate.year + 1, selectedDate.month));
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _eventDateController.text = formatDate(selectedDate,
            [dd, ":", mm, ":", "yy"]);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = "$_hour : $_minute";
        _eventTimeController.text = _time;
        _eventTimeController.text = formatDate(DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day,
            selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am])
            .toString();
      });
    }
  }

  @override
  void initState() {
    DateTime currentDate = DateTime.now();
    _eventDateController.text = formatDate(currentDate,
        [dd, ":", mm, ":", "yy"]);

    _eventTimeController.text = formatDate(
        DateTime(currentDate.year, currentDate.month, currentDate.day,
            currentDate.hour, currentDate.minute),
        [hh, ':', nn, " ", am]);
    super.initState();
  }

  Future<AppointmentEntity> _submitData(BuildContext context) async {
    if (_eventTitleController.text.isEmpty) {
      return AppointmentEntity.empty();
    }

    appointmentTitle = _eventTitleController.text;
    final appointmentDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        selectedTime.hour, selectedTime.minute);

    if (appointmentTitle.isEmpty || appointmentDate.isBefore(DateTime.now())) {
      return AppointmentEntity.empty();
    }

    String? id = await nanoid();
    late AuthenticationState authState;

    if (context.mounted) {
      authState = context.read<AuthenticationBloc>().state;
    }

    return AppointmentEntity(
      id: id,
      userId: authState.user.id,
      appointmentTitle: appointmentTitle,
      appointmentDateTime: formatDate(appointmentDate,
          [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, " ", am]),
      updatedAt: formatDate(DateTime.now(),
          [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, " ", am]),
    );
  }

  @override
  Widget build(BuildContext context) {
    dateTime = formatDate(DateTime.now(), [dd, ":", mm, ":", yy]);
    return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
            children: [
              TextField(
                controller: _eventTitleController,
                decoration: const InputDecoration(labelText: "Enter the event title:"),
                onChanged: (newVal) => appointmentTitle = newVal,
                onSubmitted: (_) => _submitData(context),
              ),
              TextField(
                controller: _eventDateController,
                decoration:
                const InputDecoration(labelText: "Select the event date:"),
                onTap: () async => _selectDate(context),
                onChanged: (newVal) => appointmentDate = selectedDate,
                onSubmitted: (_) => _submitData(context),
              ),
              TextField(
                controller: _eventTimeController,
                decoration: const InputDecoration(labelText: "Select the event time:"),
                onTap: () async => _selectTime(context),
                onSubmitted: (_) => _submitData(context),
              ),
              AddEventButton("Add Event",
                () async {
                AppointmentEntity? newAppointment = await _submitData(context);
                if (newAppointment != AppointmentEntity.empty() && mounted) {
                  GetIt.instance<AppointmentBloc>().add(AddAppointment(newAppointment));
                  Navigator.of(context).pop();
                }
              })
            ],
          ),
        )
    );
  }
}

