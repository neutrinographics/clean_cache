library clean_cache;

/// The base cache abstraction. Implement this to create your own cache.
///
/// Usually, implementations should raise an exception if a problem occurs,
/// such as a record does not exist while reading.
abstract class CleanCache<K, T> {
  /// Writes a value to the data source.
  Future<void> write(K key, T data);

  /// Writes all values to the data source.
  Future<void> writeAll(Map<K, T> data);

  /// Reads a value from the data source.
  /// This will raise a [CacheException] if the value does not exist,
  Future<T> read(K key);

  /// Checks if an element exists
  Future<bool> exists(K key);

  /// Returns a list of all values in the data source.
  Future<List<T>> values();

  /// Returns a list of all keys in the data source.
  Future<List<K>> keys();

  /// Removes an item from the data source.
  Future<void> delete(K key);

  /// Truncates all data in the data source.
  Future<void> clear();
}
