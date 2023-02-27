import 'package:repository/src/model/abstract_repository_entity.dart';

import '../../repository.dart';

abstract class Repository <T extends AbstractRepositoryEntity> {
  Future<List<T>> findAll();

  Future<T?> findById(String id);

  Future<List<T>> save(T entity);

  Future<List<T>> update(T entity);

  Future<List<T>> delete(T entity);
}