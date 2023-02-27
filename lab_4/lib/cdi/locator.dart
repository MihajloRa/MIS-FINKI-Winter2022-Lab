import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lab_4/event/bloc/appointment_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repository/repository.dart';

final GetIt locator = GetIt.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> setupLocator() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(AppointmentEntityAdapter());

  await Hive.openBox<AppointmentEntity>(AppointmentEntity.pluralName);

  // Register services
  locator.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<Connectivity>(() => Connectivity());

  // Register repository services
  locator.registerLazySingleton<Box<AppointmentEntity>>(
          () => Hive.box<AppointmentEntity>(AppointmentEntity.pluralName));
  locator.registerLazySingleton<RepositoryService<AppointmentEntity>>(
          () => FirebaseAppointmentRepositoryService(),
      instanceName: "firebaseRepositoryService");
  locator.registerLazySingleton<RepositoryService<AppointmentEntity>>(
          () => HiveRepositoryService<AppointmentEntity>(locator<Box<AppointmentEntity>>()),
      instanceName: "hiveRepositoryService");

  // Register repositories
  locator.registerLazySingleton<Repository<AppointmentEntity>>(
          () => AppointmentRepositoryImpl(locator),
      instanceName: "appointmentRepository");

  // Register blocs
  locator.registerFactory(() => AppointmentBloc());

}