library data_cache;

import 'package:data_cache/data_cache.dart';

/// A cache that's only stored in memory.
class MemoryCache<K, T> implements DataCache<K, T> {
  final Map<K, T> cache = {};

  @override
  Future<void> write(K key, T data) async {
    cache[key] = data;
  }

  @override
  Future<void> clear() async {
    cache.clear();
  }

  @override
  Future<void> delete(K key) async {
    cache.remove(key);
  }

  @override
  Future<bool> exists(K key) async {
    return cache.containsKey(key);
  }

  @override
  Future<List<K>> keys() async {
    return cache.keys.toList();
  }

  @override
  Future<T> read(K key) async {
    T? result = cache[key];
    if (result == null) {
      throw Exception('The model identified by $key does not exist');
    }
    return result;
  }

  @override
  Future<List<T>> values() async {
    return cache.values.toList();
  }
}
