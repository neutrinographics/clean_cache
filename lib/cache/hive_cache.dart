import 'dart:convert';
import 'package:data_cache/data_cache.dart';
import 'package:hive/hive.dart';

/// Transforms JSON into a model.
typedef HiveModelLoader<T> = T Function(Map<String, dynamic> json);

class HiveCache<K, T> implements DataCache<K, T> {
  final Box box;
  final HiveModelLoader<T> loader;

  HiveCache({required this.box, required this.loader});

  @override
  Future<void> clear() async {
    await box.clear();
  }

  @override
  Future<void> delete(K key) {
    return box.delete(key);
  }

  @override
  Future<T> read(K key) async {
    String? result = box.get(key);
    if (result == null) {
      throw Exception('The model identified by $key does not exist');
    }

    return loader(json.decode(result));
  }

  @override
  Future<void> write(K key, T data) {
    return box.put(key, json.encode(data));
  }

  @override
  Future<List<K>> keys() async {
    return box.keys.toList() as List<K>;
  }

  @override
  Future<List<T>> values() async {
    List<T> models = [];
    for (String element in box.values) {
      models.add(loader(json.decode(element)));
    }
    return models;
  }

  @override
  Future<bool> exists(K key) async {
    return box.containsKey(key);
  }
}
