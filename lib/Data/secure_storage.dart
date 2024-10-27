import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:learning_bloc_app/Viewmodels/list_model.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveSecureData(String key, List<ListDataModel> value) async {
    final jsonString = jsonEncode(value.map((e) => e.toJson()).toList());
    await storage.write(key: key, value: jsonString);
  }

  Future<List<ListDataModel>?> readSecureData(String key) async {
    final jsonString = await storage.read(key: key);
    if (jsonString == null) return null;

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ListDataModel.fromJson(json)).toList();
  }

  Future<void> deleteData(String key) async {
    await storage.delete(key: key);
  }
}