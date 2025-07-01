import 'package:socket_io_admin_client/features/role/data/datasources/firebase_user_role_datasources.dart';
import 'package:socket_io_admin_client/features/role/domain/entities/user_role_entitiy.dart';
import 'package:socket_io_admin_client/features/role/domain/repository/user_role_repository.dart';

class UserRoleRepositoryImpl extends UserRoleRepository {
  final FirebaseUserRoleDataSources firebaseUserRoleDataSources;

  UserRoleRepositoryImpl({required this.firebaseUserRoleDataSources});

  @override
  Future<UserRoleEntity> updateUserRole(
      String userUid,
      String userSelectedRole,
      ) async {
    return await firebaseUserRoleDataSources.updateUserRole(userUid, userSelectedRole);
  }
}
