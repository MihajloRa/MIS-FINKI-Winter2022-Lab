import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_4/event/bloc/appointment_events.dart';

import 'package:lab_4/event/model/appointment_model.dart';
import 'package:nanoid/async.dart';

import '../bloc/appointment_bloc.dart';
import 'add_appointment_button.dart';

class NewAppointment extends StatefulWidget {

  const NewAppointment({super.key});
  @override
  State<StatefulWidget> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  final _eventTitleController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();
  late final List<AppointmentModel> appointments;

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

  void _submitData() async {
    if (_eventTitleController.text.isEmpty) {
      return;
    }
    final appointmentTitle = _eventTitleController.text;
    final appointmentDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            selectedTime.hour, selectedTime.minute);

    if (appointmentTitle.isEmpty || appointmentDate.isBefore(DateTime.now())) {
      return;
    }

    String? id = await nanoid();

    final newAppointment = AppointmentModel(
        id: id,
        appointmentTitle: appointmentTitle,
        appointmentDateTime: appointmentDate.toString()
    );

    if (!mounted) return;

    !appointments.contains(newAppointment) ?
        BlocProvider.of<AppointmentBloc>(context).add(AddAppointment(newAppointment))
      : Navigator.of(context).pop();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    dateTime = formatDate(DateTime.now(), [dd, ":", mm, ":", yy]);
    return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
            children: [
              TextField(
                controller: _eventTitleController,
                decoration: const InputDecoration(labelText: "Enter the event title:"),
                onChanged: (newVal) => appointmentTitle = newVal,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _eventDateController,
                decoration:
                const InputDecoration(labelText: "Select the event date:"),
                onTap: () async => _selectDate(context),
                onChanged: (newVal) => appointmentDate = selectedDate,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _eventTimeController,
                decoration: const InputDecoration(labelText: "Select the event time:"),
                onTap: () async => _selectTime(context),
                onSubmitted: (_) => _submitData(),
              ),
              AddEventButton("Add Event", () async => _submitData())
            ],
          ),
        )
    );
  }
}

