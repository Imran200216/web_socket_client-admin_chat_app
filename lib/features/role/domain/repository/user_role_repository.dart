import 'package:socket_io_admin_client/features/role/domain/entities/user_role_entitiy.dart';

abstract class UserRoleRepository {

  // Update User Role
  Future<UserRoleEntity> updateUserRole(
    String userUid,
    String userSelectedRole,
  );
}
