library clean_cache;

import 'package:clean_cache/clean_cache.dart';

/// Stores data in two different local cache to keep speed up reads.
/// Ideally, [slowCache] will be a persistent storage, and [fastCache] will be a memory storage with faster read access.
class HybridCache<K, T> implements CleanCache<K, T> {
  final CleanCache<K, T> slowCache;
  final CleanCache<K, T> fastCache;

  HybridCache({required this.slowCache, required this.fastCache});

  @override
  Future<void> clear() async {
    await fastCache.clear();
    await slowCache.clear();
  }

  @override
  Future<void> delete(K key) async {
    await slowCache.delete(key);
    await fastCache.delete(key);
  }

  @override
  Future<bool> exists(K key) async {
    if (await fastCache.exists(key)) {
      return true;
    } else {
      return slowCache.exists(key);
    }
  }

  @override
  Future<List<K>> keys() {
    return slowCache.keys();
  }

  @override
  Future<T> read(K key) async {
    if (await fastCache.exists(key)) {
      return fastCache.read(key);
    } else {
      final value = await slowCache.read(key);
      await fastCache.write(key, value);
      return value;
    }
  }

  /// Reads values from the slow cache.
  /// This is generally slower than calling `keys()` combined with `read(key)` because the values are not stored in the fast cache.
  @override
  Future<List<T>> values() {
    return slowCache.values();
  }

  @override
  Future<void> write(K key, T data) async {
    await slowCache.write(key, data);
    await fastCache.write(key, data);
  }
}
