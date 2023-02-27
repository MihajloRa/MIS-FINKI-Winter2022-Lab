import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:repository/repository.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/appointment_bloc.dart';


class AppointmentCalendar extends StatefulWidget {
  const AppointmentCalendar({super.key});

  @override
  _AppointmentCalendarState createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> with TickerProviderStateMixin {
  late final ValueNotifier<List> _selectedEvents;
  late Map<DateTime, List> _events;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  late AnimationController _animationController;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late DateTime kToday;
  late DateTime kFirstDay;
  late DateTime kLastDay;

  @override
  void initState() {
    super.initState();

    kToday = DateTime.now();
    kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _events = createAppointmentMap();
  }

  Map<DateTime, List<AppointmentEntity>> createAppointmentMap() {
    final appointments = GetIt.instance<AppointmentBloc>().state.appointments;
    Map<DateTime, List<AppointmentEntity>> appointmentMap = {};
    for (var element in appointments) {
      var appointmentTime = DateTime(element.dateTime.year, element.dateTime.month, element.dateTime.day);
      var original = appointmentMap[appointmentTime];
      if (original == null) {
        appointmentMap[appointmentTime] = [element];
      } else {
        appointmentMap[appointmentTime] = List.from(original)
          ..addAll([element]);
      }
    }
    return appointmentMap;
  }


  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List _getEventsForDay(DateTime day) {
    // Implementation example
    return _events[day] ?? [];
  }

  List<AppointmentEntity> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      eventLoader: (day) => _getEventsForDay(day),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: const TextStyle().copyWith(color: Colors.blue[800]),
        holidayTextStyle: const TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: const TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: const TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: const TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          final children = Column();

          if (events.isNotEmpty) {
            children.children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.value
          .map((event) => Container(
          decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin:
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }

  daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
          (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}