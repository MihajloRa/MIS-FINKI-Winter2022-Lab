import 'package:hive/hive.dart';
import 'package:repository/repository.dart';

class HiveRepositoryService<T extends AbstractRepositoryEntity> extends RepositoryService<T>{
  final Box<T> _box;

  HiveRepositoryService(this._box);

  @override
  Future<List<T>> findAll(String userId) async {
    return _box.values
      .where((entity) => entity.userId == userId)
      .toList(growable: false);
  }

  @override
  Future<T?> findById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> save(T entity) async {
    if (!_box.containsKey(entity.id)) {
      _box.put(entity.id, entity);
    } else {
      update(entity);
    }
  }

  @override
  Future<void> delete(T entity) async {
    return _box.delete(entity.id);
  }

  @override
  Future<void> update(T entity) async {
    return _box.put(entity.id, entity);
  }

  Future<Future<int>> clear() async {
    return _box.clear();
  }

  Future<void> close() async {
    return _box.close();
  }

  @override
  Future<void> saveAll(List<T> entitiesToSave) async {
   _box.isOpen ? await _box.addAll(entitiesToSave) : null;
  }
}