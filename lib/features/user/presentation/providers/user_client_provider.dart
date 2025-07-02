import 'package:flutter/material.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/read_users_use_case.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/update_client_fields_use_case.dart';

class UserClientProvider extends ChangeNotifier {
  final UpdateClientFieldsUseCase updateClientFieldsUseCase;
  final ReadUsersUseCase readUsersUseCase;

  UserClientProvider({
    required this.updateClientFieldsUseCase,
    required this.readUsersUseCase,
  });

  List<UserClientEntity> _users = [];
  UserClientEntity? updatedUser;

  bool _isLoading = false;
  bool _isUpdating = false;

  List<UserClientEntity> get users => _users;

  bool get isLoading => _isLoading;

  bool get isUpdating => _isUpdating;

  Future<void> updateUser({
    required String userUid,
    required String companyRole,
    required String empId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      updatedUser = await updateClientFieldsUseCase(
        userUid,
        companyRole,
        empId,
      );
      AppLogger.success("✅ User updated");
    } catch (e) {
      AppLogger.error("⛔ Failed to update user: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await readUsersUseCase();
      AppLogger.info("✅ Fetched ${_users.length} users");
    } catch (e) {
      AppLogger.error("⛔ Error fetching users: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
