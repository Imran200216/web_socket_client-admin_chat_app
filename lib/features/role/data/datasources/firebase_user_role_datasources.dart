import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:socket_io_admin_client/features/role/domain/entities/user_role_entitiy.dart';
import 'package:socket_io_admin_client/features/role/data/models/user_role_model.dart';

class FirebaseUserRoleDataSources {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<UserRoleEntity> updateUserRole(String userUid, String userSelectedRole) async {
    // Update the field in Firestore
    await firebaseFirestore
        .collection(AppDBConstants.userCollection)
        .doc(userUid)
        .update({
      'userDesignationRole': userSelectedRole,
    });

    // Return the updated role entity
    return UserRoleModel(
      userUid: userUid,
      userDesignationRole: userSelectedRole,
    );
  }
}
