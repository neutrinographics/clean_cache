import 'package:data_cache/cache/hive_cache.dart';
import 'package:data_cache/cache/hybrid_cache.dart';
import 'package:data_cache/cache/memory_cache.dart';
import 'package:hive/hive.dart';

/// Utility to create a hybrid cache from Hive and Memory.
Future<HybridCache<K, T>> buildHybridHiveCache<K, T>(
  String boxName, {
  required HiveCipher encryptionCipher,
  required HiveModelLoader<T> loader,
}) async {
  final slowCache = await buildHiveCache<K, T>(
    boxName,
    encryptionCipher: encryptionCipher,
    loader: loader,
  );
  final fastCache = MemoryCache<K, T>();
  return HybridCache(
    slowCache: slowCache,
    fastCache: fastCache,
  );
}

/// Utility to create a Hive cache.
Future<HiveCache<K, T>> buildHiveCache<K, T>(
  String boxName, {
  HiveCipher? encryptionCipher,
  required HiveModelLoader<T> loader,
}) {
  return Hive.openBox(boxName, encryptionCipher: encryptionCipher)
      .then((value) {
    return HiveCache<K, T>(box: value, loader: loader);
  });
}
