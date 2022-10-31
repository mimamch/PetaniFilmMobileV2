import 'package:hive_flutter/adapters.dart';

class HiveService {
  Future<bool> isExists({required String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  Future<void> addBoxes(
      {required List items,
      required String boxName,
      Duration duration = const Duration(hours: 6)}) async {
    final openBox = await Hive.openBox(boxName);
    final exp = await Hive.openBox<DateTime>('cache_expired');
    exp.put(boxName, DateTime.now().add(duration));
    for (var item in items) {
      openBox.add(item);
    }
  }

  Future<void> addBoxMap(
      {required Map item,
      required String boxName,
      Duration duration = const Duration(hours: 6)}) async {
    final openBox = await Hive.openBox(boxName);
    final exp = await Hive.openBox<DateTime>('cache_expired');
    exp.put(boxName, DateTime.now().add(duration));
    openBox.add(item);
  }

  Future<void> addSingleBoxKeyMap(
      {required Map item,
      required String boxName,
      required String boxKey,
      Duration duration = const Duration(hours: 12)}) async {
    final openBox = await Hive.openBox(boxName);
    final exp = await Hive.openBox<DateTime>('cache_expired');
    exp.put(boxName, DateTime.now().add(duration));
    openBox.put(boxKey, item);
  }

  Future<List<Map<String, dynamic>>> getBoxes(String boxName) async {
    List<Map<String, dynamic>> boxList = [];
    final openBox = await Hive.openBox(boxName);

    for (var element in openBox.values) {
      boxList.add(Map<String, dynamic>.from(element));
    }
    return boxList;
  }

  Future<dynamic> getBoxesKey(String boxName, String key) async {
    if (await isExpired(boxName: boxName)) return null;
    final openBox = await Hive.openBox(boxName);
    return openBox.get(key);
  }

  Future<bool> isExpired({required String boxName}) async {
    final box = await Hive.openBox<DateTime>('cache_expired');
    DateTime? exp = box.get(boxName);
    if (exp == null || exp.isBefore(DateTime.now())) {
      await clearBoxes(boxName: boxName);
      return true;
    }
    return false;
  }

  Future<void> clearBoxes({
    required String boxName,
  }) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
    final exp = await Hive.openBox<DateTime>('cache_expired');
    await exp.delete(boxName);
  }
}
