import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repository/repository.dart';

class FirebaseAppointmentRepositoryService extends RepositoryService<AppointmentEntity> {
  FirebaseAppointmentRepositoryService() {
    _firestoreStorage = FirebaseFirestore.instance;
  }

  late final FirebaseFirestore _firestoreStorage;

  @override
  Future<void> save(AppointmentEntity entity) async {
    await _firestoreStorage.collection(AppointmentEntity.pluralName).add(entity.toJson());
  }

  @override
  Future<List<AppointmentEntity>> findAll(String userId) async {
    QuerySnapshot<Map<String, dynamic>> query =
    await _firestoreStorage.collection(AppointmentEntity.pluralName)
        .where("userId", isEqualTo: userId)
        .orderBy("updatedAt")
        .get();
    return query.docs
      .map((document) =>
        AppointmentEntity.fromJson(document.data())
      ).toList();
  }

  @override
  Future<void> update(AppointmentEntity entity) async {
    await _firestoreStorage.collection(AppointmentEntity.pluralName).doc(entity.id)
        .update(entity.toJson());
  }

  @override
  Future<void> delete(AppointmentEntity entity) async {
    await _firestoreStorage.collection(AppointmentEntity.pluralName).doc(entity.id)
        .delete();
  }

  @override
  Future<AppointmentEntity> findById(String id) async {
    final query = await _firestoreStorage
        .collection(AppointmentEntity.pluralName)
        .where("id", isEqualTo: id).get();

    return query.docs.map((doc) => AppointmentEntity.fromJson(doc.data())).first;
  }

  @override
  saveAll(List<AppointmentEntity> entitiesToSave) async {
    WriteBatch batch = _firestoreStorage.batch();

    for (final entity in entitiesToSave) {
      batch.set(
        _firestoreStorage.collection(AppointmentEntity.pluralName).doc(entity.id),
        entity.toJson()
      );
    }

    await batch.commit();
  }
}