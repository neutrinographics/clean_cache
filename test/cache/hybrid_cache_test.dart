import 'package:data_cache/cache/hybrid_cache.dart';
import 'package:data_cache/data_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hybrid_cache_test.mocks.dart';

@GenerateMocks([DataCache])
void main() {
  late MockDataCache<String, String> fastCache;
  late MockDataCache<String, String> slowCache;
  late HybridCache<String, String> hybridCache;

  setUp(() {
    fastCache = MockDataCache();
    slowCache = MockDataCache();
    hybridCache = HybridCache(
      fastCache: fastCache,
      slowCache: slowCache,
    );
  });

  const tValue = 'value';
  const tKey = 'key';

  test(
    'should write to both caches',
    () async {
      // nothing to arrange
      // act
      await hybridCache.write(tKey, tValue);
      // assert
      verify(fastCache.write(tKey, tValue));
      verify(slowCache.write(tKey, tValue));
    },
  );

  test(
    'should delete from both caches',
    () async {
      // nothing to arrange
      // act
      await hybridCache.delete(tKey);
      // assert
      verify(fastCache.delete(tKey));
      verify(slowCache.delete(tKey));
    },
  );

  test(
    'should clear both caches',
    () async {
      // arrange
      // act
      await hybridCache.clear();
      // assert
      verify(fastCache.clear());
      verify(slowCache.clear());
    },
  );

  test(
    'should return keys from slow cache',
    () async {
      // arrange
      const tKeys = ['one', 'two'];
      when(slowCache.keys()).thenAnswer((_) async => tKeys);
      // act
      final result = await hybridCache.keys();
      // assert
      expect(result, tKeys);
      verify(slowCache.keys());
      verifyZeroInteractions(fastCache);
    },
  );

  test(
    'should return values from slow cache',
    () async {
      // arrange
      const tValues = ['one', 'two'];
      when(slowCache.values()).thenAnswer((_) async => tValues);
      // act
      final result = await hybridCache.values();
      // assert
      expect(result, tValues);
      verify(slowCache.values());
      verifyZeroInteractions(fastCache);
    },
  );

  group('read', () {
    test(
      'should hit the fast cache first',
      () async {
        // arrange
        when(fastCache.exists(tKey)).thenAnswer((_) async => true);
        when(fastCache.read(tKey)).thenAnswer((_) async => tValue);
        // act
        final result = await hybridCache.read(tKey);
        // assert
        expect(result, tValue);
        verify(fastCache.exists(tKey));
        verify(fastCache.read(tKey));
        verifyZeroInteractions(slowCache);
      },
    );

    test(
      'should hit the slow cache if the fast cache does not contain the key',
      () async {
        // arrange
        when(fastCache.exists(tKey)).thenAnswer((_) async => false);
        when(slowCache.exists(tKey)).thenAnswer((_) async => true);
        when(slowCache.read(tKey)).thenAnswer((_) async => tValue);
        // act
        final result = await hybridCache.read(tKey);
        // assert
        expect(result, tValue);
        verify(fastCache.exists(tKey));
        verify(slowCache.read(tKey));
        verifyNoMoreInteractions(fastCache);
        verifyNoMoreInteractions(slowCache);
      },
    );
  });

  group('exists', () {
    test(
      'should hit the fast cache first',
      () async {
        // arrange
        when(fastCache.exists(tKey)).thenAnswer((_) async => true);
        // act
        await hybridCache.exists(tKey);
        // assert
        verify(fastCache.exists(tKey));
        verifyZeroInteractions(slowCache);
      },
    );

    test(
      'should hit the slow cache if the fast cache does not contain the key',
      () async {
        // arrange
        const tExists = true;
        when(fastCache.exists(tKey)).thenAnswer((_) async => false);
        when(slowCache.exists(tKey)).thenAnswer((_) async => tExists);
        // act
        final result = await hybridCache.exists(tKey);
        // assert
        expect(result, tExists);
        verify(fastCache.exists(tKey));
        verify(slowCache.exists(tKey));
      },
    );
  });
}
