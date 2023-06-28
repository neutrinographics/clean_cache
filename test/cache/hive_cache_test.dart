import 'dart:convert';

import 'package:clean_cache/cache/hive_cache.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hive_cache_test.mocks.dart';

class MockModel extends Equatable {
  final String id;

  const MockModel({required this.id});

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  static MockModel fromJson(Map<String, dynamic> json) {
    return MockModel(id: json['id']);
  }
}

@GenerateMocks([Box])
void main() {
  late MockBox mockBox;
  late HiveCache<String, MockModel> cache;

  setUp(() {
    mockBox = MockBox();
    cache = HiveCache(
      box: mockBox,
      loader: (json) => MockModel.fromJson(json),
    );
  });

  group('write', () {
    const tModel = MockModel(id: 'id');
    final tModelString = json.encode(tModel.toJson());

    test(
      'should write the model to hive',
      () async {
        // nothing to arrange
        // act
        await cache.write(tModel.id, tModel);
        // assert
        verify(mockBox.put(tModel.id, tModelString));
      },
    );

    test(
      'should raise CacheException if the model cannot be written',
      () async {
        // arrange
        when(mockBox.put(any, any)).thenThrow(Exception());
        // act
        final call = cache.write;
        // assert
        expect(() => call(tModel.id, tModel),
            throwsA(const TypeMatcher<Exception>()));
      },
    );
  });

  group('read', () {
    const tModel = MockModel(id: 'id');
    final tModelString = json.encode(tModel.toJson());

    test(
      'should read the model from hive',
      () async {
        // arrange
        when(mockBox.get(any)).thenReturn(tModelString);
        // act
        final result = await cache.read(tModel.id);
        // assert
        expect(result, tModel);
        verify(mockBox.get(tModel.id));
      },
    );

    test(
      'should raise CacheException if the model does not exist',
      () async {
        // arrange
        when(mockBox.get(any)).thenReturn(null);
        // act
        final call = cache.read;
        // assert
        expect(() => call(tModel.id), throwsA(const TypeMatcher<Exception>()));
      },
    );

    test(
      'should raise CacheException if the model cannot be parsed',
      () async {
        // arrange
        when(mockBox.get(any)).thenReturn('invalid');
        // act
        final call = cache.read;
        // assert
        expect(() => call(tModel.id), throwsA(const TypeMatcher<Exception>()));
      },
    );
  });

  group('exists', () {
    const tId = 'id';

    test(
      'should use hive to check if a model exists',
      () async {
        // arrange
        const tExists = true;
        when(mockBox.containsKey(any)).thenReturn(tExists);
        // act
        final result = await cache.exists(tId);
        // assert
        expect(result, tExists);
        verify(mockBox.containsKey(tId));
      },
    );
  });

  group('values', () {
    const tModel = MockModel(id: 'id');
    final tModelString = json.encode(tModel.toJson());

    test(
      'should use hive to return all the models',
      () async {
        // arrange
        when(mockBox.values).thenReturn([tModelString]);
        // act
        final result = await cache.values();
        // assert
        expect(result, [tModel]);
        verify(mockBox.values);
      },
    );

    test(
      'should raise CacheException if the model cannot be parsed',
      () async {
        // arrange
        when(mockBox.values).thenReturn(['invalid']);
        // act
        final call = cache.values;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<Exception>()));
      },
    );
  });

  group('keys', () {
    const List<String> tKeys = ['id'];

    test(
      'should use hive to return a list of model keys',
      () async {
        // arrange
        when(mockBox.keys).thenReturn(tKeys);
        // act
        final result = await cache.keys();
        // assert
        expect(result, tKeys);
        verify(mockBox.keys);
      },
    );
  });

  group('delete', () {
    const tId = 'id';

    test(
      'should use hive to remove a model',
      () async {
        // nothing to arrange
        // act
        await cache.delete(tId);
        // assert
        verify(mockBox.delete(tId));
      },
    );

    test(
      'should raise CacheException if the model cannot be deleted',
      () async {
        // arrange
        when(mockBox.delete(any)).thenThrow(Exception());
        // act
        final call = cache.delete;
        // assert
        expect(() => call(tId), throwsA(const TypeMatcher<Exception>()));
      },
    );
  });

  group('clear', () {
    test(
      'should use hive to remove all models',
      () async {
        // arrange
        when(mockBox.clear()).thenAnswer((_) => Future.value(1));
        // act
        await cache.clear();
        // assert
        verify(mockBox.clear());
      },
    );

    test(
      'should raise CacheException if hive cannot be cleared',
      () async {
        // arrange
        when(mockBox.clear()).thenThrow(Exception());
        // act
        final call = cache.clear;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<Exception>()));
      },
    );
  });
}
