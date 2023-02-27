import '../../repository.dart';

abstract class RepositoryService<T extends AbstractRepositoryEntity>{

  Future<List<T>> findAll(String userId);

  Future<T?> findById(String id);

  Future<void> save(T entity);

  Future<void> update(T entity);

  Future<void> delete(T entity);

  Future<void> saveAll(List<T> entitiesToSave);

}