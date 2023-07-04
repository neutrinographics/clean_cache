## 1.0.3

* Reads from the `HybridCache` will now cache values from the slow cache into the fast cache. This will make subsequent reads faster.

## 1.0.2

* Made the `json` argument in the `HiveModelLoader` dynamic so it can handle any shape of json.

## 1.0.1

* Made Hive encryption optional

## 1.0.0

* Added base cache abstraction
* Added Memory Cache
* Added Hive Cache
* Added Hybrid Cache