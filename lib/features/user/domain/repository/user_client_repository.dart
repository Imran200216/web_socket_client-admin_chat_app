import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';

abstract class UserClientRepository {
  // Update Client Fields
  Future<UserClientEntity> updateClientFields(String companyRole, String empId, String userUid);
}
