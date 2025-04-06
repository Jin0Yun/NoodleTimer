import 'package:flutter/services.dart';

abstract class IDataLoader {
  Future<String> load(String path);
}

class DataLoader implements IDataLoader {
  @override
  Future<String> load(String path) async {
    return await rootBundle.loadString(path);
  }
}
