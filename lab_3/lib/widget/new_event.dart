import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:date_format/date_format.dart';

import 'package:lab_3/model/event_model.dart';

import 'add_event_button.dart';

class NewEvent extends StatefulWidget {
  final Function addEvent;

  NewEvent(this.addEvent, {super.key});
  @override
  State<StatefulWidget> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final _eventTitleController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();

  late String _setTime, _setDate;

  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  late String eventTitle;
  late DateTime eventDate;

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

  void _submitData() {
    if (_eventTitleController.text.isEmpty) {
      return;
    }
    final eventTitle = _eventTitleController.text;
    final eventDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            selectedTime.hour, selectedTime.minute);

    if (eventTitle.isEmpty || eventDate.isBefore(DateTime.now())) {
      return;
    }

    final newEvent = EventModel(eventTitle, eventDate);
    widget.addEvent(newEvent);
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
                onChanged: (newVal) => eventTitle = newVal,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _eventDateController,
                decoration:
                const InputDecoration(labelText: "Select the event date:"),
                onTap: () async => _selectDate(context),
                onChanged: (newVal) => eventDate = selectedDate,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _eventTimeController,
                decoration: const InputDecoration(labelText: "Select the event time:"),
                onTap: () async => _selectTime(context),
                onSubmitted: (_) => _submitData(),
              ),
              AddEventButton("Add Event", _submitData)
            ],
          ),
        )
    );
  }
}

