import 'package:auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:lab_4/auth/bloc/authentication_bloc.dart';
import 'package:lab_4/auth/screen/create_account.dart';
import 'package:lab_4/auth/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_4/cdi/locator.dart';
import 'package:lab_4/event/screen/appointment_list.dart';
import 'package:lab_4/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                authService: GetIt.instance<AuthService>()
            )..add(UserAlreadyLoggedInEvent())
        ),
      ],
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationInitial) {
            Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
          }
        },
        builder: (context, state) {
          return MaterialApp(
            title: 'Appointments',
            initialRoute: "/login",
            routes: {
              "/login": (context) => LoginScreen(),
              "/signup": (context) => CreateAccount(),
              "/appointments": (context) => const AppointmentList(),
            },
          );
        },
      )
    );
  }
}