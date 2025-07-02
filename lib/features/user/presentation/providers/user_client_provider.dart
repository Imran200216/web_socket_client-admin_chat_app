import 'package:flutter/material.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/get_user_by_uid_use_case.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/read_users_use_case.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/update_client_fields_use_case.dart';

class UserClientProvider extends ChangeNotifier {
  final UpdateClientFieldsUseCase updateClientFieldsUseCase;
  final ReadUsersUseCase readUsersUseCase;
  final GetUserByUidUseCase getUserByUidUseCase;

  UserClientProvider({
    required this.updateClientFieldsUseCase,
    required this.readUsersUseCase,
    required this.getUserByUidUseCase,
  });

  List<UserClientEntity> _users = [];
  UserClientEntity? _user;
  UserClientEntity? updatedUser;

  bool _isLoading = false;
  bool _isUpdating = false;

  List<UserClientEntity> get users => _users;

  UserClientEntity? get user => _user;

  bool get isLoading => _isLoading;

  bool get isUpdating => _isUpdating;

  /// Update a user's company role and employee ID
  Future<void> updateUser({
    required String userUid,
    required String companyRole,
    required String empId,
  }) async {
    _isLoading = true;
    AppLogger.info("🔄 Updating user... UID: $userUid");
    notifyListeners();

    try {
      updatedUser = await updateClientFieldsUseCase(
        userUid,
        companyRole,
        empId,
      );
      AppLogger.success("✅ User updated: ${updatedUser?.userName}");
    } catch (e) {
      AppLogger.error("⛔ Failed to update user with UID $userUid: $e");
      rethrow;
    } finally {
      _isLoading = false;
      AppLogger.info("🟢 Update complete");
      notifyListeners();
    }
  }

  /// Fetch all users from Firestore
  Future<void> fetchAllUsers() async {
    _isLoading = true;
    AppLogger.info("🔄 Fetching all users...");
    notifyListeners();

    try {
      _users = await readUsersUseCase();
      AppLogger.success("✅ Fetched ${_users.length} users");
    } catch (e) {
      AppLogger.error("⛔ Error fetching users: $e");
    } finally {
      _isLoading = false;
      AppLogger.info("🟢 Finished fetching all users");
      notifyListeners();
    }
  }

  /// Fetch a single user by UID
  Future<void> fetchUser(String uid) async {
    _isLoading = true;
    AppLogger.info("🔄 Fetching user by UID: $uid");
    notifyListeners();

    try {
      _user = await getUserByUidUseCase(uid);
      AppLogger.success("✅ Fetched user: ${_user?.userName}");
    } catch (e) {
      AppLogger.error("❌ Error fetching user by UID $uid: $e");
    } finally {
      _isLoading = false;
      AppLogger.info("🟢 Done fetching single user");
      notifyListeners();
    }
  }
}
