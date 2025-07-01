import 'package:flutter/cupertino.dart';
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

  UserClientEntity? updatedUser;

  List<UserClientEntity> _users = [];

  List<UserClientEntity> get users => _users;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isUpdating = false;

  bool get isUpdating => _isUpdating;

  // 🔄 Update user fields with loading state
  Future<void> updateFields({
    required String userUid,
    required String companyRole,
    required String empId,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      updatedUser = await updateClientFieldsUseCase(
        userUid,
        companyRole,
        empId,
      );
      AppLogger.success("User updated successfully");
    } catch (e) {
      AppLogger.error("Error updating user: $e");
    }

    _isUpdating = false;
    notifyListeners();
  }

  // 📥 Fetch all users
  Future<void> fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await readUsersUseCase();
      AppLogger.info("Fetched ${_users.length} users");
    } catch (e) {
      AppLogger.error("Error fetching users: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
