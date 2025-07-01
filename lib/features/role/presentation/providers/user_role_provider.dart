import 'package:flutter/material.dart';
import 'package:socket_io_admin_client/features/role/domain/entities/user_role_entitiy.dart';
import 'package:socket_io_admin_client/features/role/domain/usecases/user_role_usecases.dart';

class UserRoleProvider with ChangeNotifier {
  final UserRoleUseCase userRoleUseCase;

  UserRoleProvider({required this.userRoleUseCase});

  bool _isLoading = false;
  String? _error;
  UserRoleEntity? _userRole;

  bool get isLoading => _isLoading;

  String? get error => _error;

  UserRoleEntity? get userRole => _userRole;

  Future<void> updateUserRole(String userUid, String selectedRole) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userRole = await userRoleUseCase(userUid, selectedRole);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
