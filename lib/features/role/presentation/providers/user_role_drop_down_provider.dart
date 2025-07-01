import 'package:flutter/material.dart';

class UserRoleDropDownProvider with ChangeNotifier {
  final List<String> _roles = ['Admin', 'User'];
  String? _selectedRole;

  List<String> get roles => _roles;
  String? get selectedRole => _selectedRole;

  void setSelectedRole(String? role) {
    _selectedRole = role;
    notifyListeners();
  }
}
