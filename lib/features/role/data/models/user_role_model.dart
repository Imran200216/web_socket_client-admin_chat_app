import 'package:socket_io_admin_client/features/role/domain/entities/user_role_entitiy.dart';

class UserRoleModel extends UserRoleEntity {
  UserRoleModel({required super.userUid, required super.userDesignationRole});

  // ✅ Factory constructor to create from JSON
  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      userUid: json['userUid'] as String,
      userDesignationRole: json['userDesignationRole'] as String,
    );
  }

  // ✅ Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {'userUid': userUid, 'userDesignationRole': userDesignationRole};
  }
}
