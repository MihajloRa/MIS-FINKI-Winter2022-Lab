// import 'package:date_format/date_format.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lab_4/event/bloc/appointment_bloc.dart';
// import 'package:lab_4/event/bloc/appointment_list_state.dart';
// import 'package:nanoid/async.dart';
// import 'package:repository/repository.dart';
//
// import '../../auth/bloc/authentication_bloc.dart';
// import '../bloc/appointment_events.dart';
// import '../model/appointment_model.dart';
// import 'appointment_list.dart';
//
// class CreateNewAppointment extends StatefulWidget {
//   const CreateNewAppointment({Key? key}) : super(key: key);
//
//   @override
//   _CreateNewAppointmentState createState() => _CreateNewAppointmentState();
// }
//
// class _CreateNewAppointmentState extends State<CreateNewAppointment> {
//   final _eventTitleController = TextEditingController();
//   final _eventDateController = TextEditingController();
//   final _eventTimeController = TextEditingController();
//   late final AppointmentModel newAppointment;
//
//   late String _hour, _minute, _time;
//   late String dateTime;
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
//   late String appointmentTitle;
//   late DateTime appointmentDate;
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime(
//             selectedDate.year, selectedDate.month, selectedDate.day),
//         initialDatePickerMode: DatePickerMode.day,
//         firstDate: DateTime.now(),
//         lastDate: DateTime(selectedDate.year + 1, selectedDate.month));
//     if (pickedDate != null) {
//       setState(() {
//         selectedDate = pickedDate;
//         _eventDateController.text = formatDate(selectedDate,
//             [dd, "-", mm, "-", yy]);
//       });
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (pickedTime != null) {
//       setState(() {
//         selectedTime = pickedTime;
//         _hour = selectedTime.hour.toString();
//         _minute = selectedTime.minute.toString();
//         _time = "$_hour : $_minute";
//         _eventTimeController.text = _time;
//         _eventTimeController.text = formatDate(DateTime(
//             selectedDate.year, selectedDate.month, selectedDate.day,
//             selectedTime.hour, selectedTime.minute),
//             [hh, ':', nn, " ", am])
//             .toString();
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     appointmentTitle = "";
//     DateTime currentDate = DateTime.now();
//     _eventDateController.text = formatDate(currentDate,
//         [dd, "-", mm, "-", yy]);
//
//     _eventTimeController.text = formatDate(
//         DateTime(currentDate.year, currentDate.month, currentDate.day,
//             currentDate.hour, currentDate.minute),
//         [hh, ':', nn, " ", am]);
//     super.initState();
//   }
//
//   Future<AppointmentEntity?> _submitData(BuildContext context) async {
//     if (_eventTitleController.text.isEmpty) {
//       return null;
//     }
//
//     appointmentTitle = _eventTitleController.text;
//     final appointmentDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
//         selectedTime.hour, selectedTime.minute);
//
//     if (appointmentTitle.isEmpty || appointmentDate.isBefore(DateTime.now())) {
//       return null;
//     }
//
//     String? id = await nanoid();
//     late AuthenticationState authState;
//
//     if (context.mounted) {
//       authState = context.read<AuthenticationBloc>().state;
//     }
//
//     return AppointmentEntity(
//         id: id,
//         userId: authState.email,
//         appointmentTitle: appointmentTitle,
//         appointmentDateTime: formatDate(appointmentDate,
//             [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, " ", am]),
//         updatedAt: formatDate(DateTime.now(),
//             [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, " ", am]),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     dateTime = formatDate(DateTime.now(), [dd, ":", mm, ":", yy]);
//     return BlocListener<AppointmentBloc, AppointmentListState>(
//       listener: (context, state) {
//         if (state.status == AppointmentListStatus.success
//             || state.status == AppointmentListStatus.failure) {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const AppointmentList(),
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//         title: const Text("Create Appointment"),
//         centerTitle: true,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width / 2,
//                 child: TextField(
//                   controller: _eventTitleController,
//                   decoration: const InputDecoration(hintText: 'Appointment Title'),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width / 2,
//                 child: TextField(
//                   controller: _eventDateController,
//                   decoration: const InputDecoration(
//                     hintText: 'Appointment Date',
//                   ),
//                   onTap: () async => _selectDate(context),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width / 2,
//                 child: TextField(
//                   controller: _eventTimeController,
//                   decoration: const InputDecoration(
//                     hintText: 'Appointment Time',
//                   ),
//                   onTap: () async => _selectTime(context),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   AppointmentEntity? newAppointment = await _submitData(context);
//                   if (newAppointment != null && mounted) {
//                     context.read<AppointmentBloc>().add(AddAppointment(newAppointment));
//                   }
//                 },
//                 child: const Text('Create'),
//               ),
//             ]
//           ),
//         ),
//       ),
//     );
//   }
// }