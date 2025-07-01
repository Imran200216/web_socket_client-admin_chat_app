import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UUIDGeneratorProvider extends ChangeNotifier {
  String _uuid = const Uuid().v4();

  String get uuid => _uuid;

  void generateNewUUID() {
    _uuid = const Uuid().v4();
    notifyListeners();
  }

  void setUUID(String value) {
    _uuid = value;
    notifyListeners();
  }
}
