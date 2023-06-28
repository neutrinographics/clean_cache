Designed for use in projects that follow [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) pattern,
data_cache is a simple cache abstraction allowing you to easily mock it for unit tests.

## Features

Several prebuilt cache are included:

* Memory cache
* Hive cache
* Hybrid cache

If you need something specific, you just need to implement the `LocalCache` abstraction.

## Getting started

Just install the package to get started.

```bash
flutter pub add data_cache
```

## Usage

```dart
import 'package:data_cache/cache/memory_cache.dart';

// This stores an ExampleModel with a String key.
final cache = MemoryCache<String, ExampleModel>();
final model = ExampleModel();
await cache.write(model.id, model);
```