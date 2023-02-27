import 'dart:core';

import 'package:auth/auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import '../../repository.dart';

class AppointmentRepositoryImpl extends Repository<AppointmentEntity> {
  AppointmentRepositoryImpl(this.cdiContext) {
    setupRepository(cdiContext);
  }

  setupRepository(GetIt cdiContext) {
    _firebaseRepositoryService = cdiContext<RepositoryService<AppointmentEntity>>(instanceName: "firebaseRepositoryService");
    _hiveService = cdiContext<RepositoryService<AppointmentEntity>>(instanceName: "hiveRepositoryService");
    connectivity = cdiContext<Connectivity>();

    connectivity.onConnectivityChanged.listen((ConnectivityResult status) => {
      if (status == ConnectivityResult.wifi || status == ConnectivityResult.mobile) {
        _sync(status)
      }
    });
  }

  final GetIt cdiContext;
  late final RepositoryService<AppointmentEntity> _firebaseRepositoryService;
  late final RepositoryService<AppointmentEntity> _hiveService;
  late final Connectivity connectivity;

  Future<void> _sync(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return;
    }
    UserEntity loggedInUser = await cdiContext<AuthService>().getLoggedInUser();

    if (loggedInUser.isAnonymous) {
      return;
    }
    final entities = await _hiveService.findAll(loggedInUser.id);
    final entitiesToSave = <AppointmentEntity>[];
    for (final entity in entities) {
      final remoteEntity = await _firebaseRepositoryService.findById(entity.id);
      if (remoteEntity != AppointmentEntity.empty()  && remoteEntity != null) {
        entitiesToSave.add(remoteEntity);
      } else if (remoteEntity == null || remoteEntity == AppointmentEntity.empty()) {
        await _firebaseRepositoryService.delete(entity);
      }
    }
    await _hiveService.saveAll(entitiesToSave);
    await _firebaseRepositoryService.saveAll(entitiesToSave);
  }

  @override
  Future<List<AppointmentEntity>> findAll() async {
    UserEntity loggedInUser = await cdiContext<AuthService>().getLoggedInUser();

    if (loggedInUser.isAnonymous) {
      return List<AppointmentEntity>.empty();
    }

    return _hiveService.findAll(loggedInUser.id);
  }

  @override
  Future<AppointmentEntity?> findById(String id) async {
    UserEntity loggedInUser = await cdiContext<AuthService>().getLoggedInUser();

    if (loggedInUser.isAnonymous) {
      return AppointmentEntity.empty();
    }

    AppointmentEntity? entity = await _hiveService.findById(id);
    if (entity == null) {
      entity = await _firebaseRepositoryService.findById(id);
      if (entity == null) {
        return null;
      }
      _hiveService.save(entity);
    }

    return entity;
  }

  @override
  Future<List<AppointmentEntity>> save(AppointmentEntity entity) async {
    final UserEntity loggedInUser = await cdiContext<AuthService>().getLoggedInUser();

    if (loggedInUser.isAnonymous) {
      return List<AppointmentEntity>.empty();
    }

    return await _hiveService.save(entity)
    .whenComplete(() async => await _firebaseRepositoryService.save(entity))
    .then((value) => _hiveService.findAll(loggedInUser.id));
  }

  @override
  Future<List<AppointmentEntity>> update(AppointmentEntity entity) async {
    final UserEntity loggedInUser = await cdiContext<AuthService>().getLoggedInUser();

    if (loggedInUser.isAnonymous) {
      return List<AppointmentEntity>.empty();
    }

    return await _hiveService.update(entity)
        .whenComplete(() async => await _firebaseRepositoryService.update(entity))
        .then((value) => _hiveService.findAll(loggedInUser.id));
  }

  @override
  Future<List<AppointmentEntity>> delete(AppointmentEntity entity) async {
    final UserEntity loggedInUser = await cdiContext<AuthService>().getLoggedInUser();

    if (loggedInUser.isAnonymous) {
      return List<AppointmentEntity>.empty();
    }

    return await _hiveService.delete(entity)
    .whenComplete(() async => await _firebaseRepositoryService.delete(entity))
    .then((value) async => await _hiveService.findAll(loggedInUser.id));
  }

}
