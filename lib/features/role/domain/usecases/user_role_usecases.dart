import 'package:socket_io_admin_client/features/role/domain/entities/user_role_entitiy.dart';
import 'package:socket_io_admin_client/features/role/domain/repository/user_role_repository.dart';

class UserRoleUseCase {
  final UserRoleRepository userRoleRepository;

  UserRoleUseCase({required this.userRoleRepository});

  Future<UserRoleEntity> call(String userUid, String userSelectedRole) async {
    return await userRoleRepository.updateUserRole(userUid, userSelectedRole);
  }
}
