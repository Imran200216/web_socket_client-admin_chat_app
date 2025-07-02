import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';

abstract class UserClientRepository {
  // Update Client Fields
  Future<UserClientEntity> updateClientFields(
    String userUid,
    String companyRole,
    String empId,
  );

  // Real All User Data
  Future<List<UserClientEntity>> readAllUser();

  //  Get User By Uid
  Future<UserClientEntity> getUserByUid(String uid);
}
