import 'package:socket_io_admin_client/features/user/data/datasources/firestore_user_client_datasource.dart';
import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';
import 'package:socket_io_admin_client/features/user/domain/repository/user_client_repository.dart';

class UserClientRepositoryImpl extends UserClientRepository {
  final FirestoreUserClientDatasource firestoreUserClientDatasource;

  UserClientRepositoryImpl({required this.firestoreUserClientDatasource});

  @override
  Future<UserClientEntity> updateClientFields(
    String userUid,
    String companyRole,
    String empId,
  ) async {
    final model = await firestoreUserClientDatasource.updateClientFields(
      userUid: userUid,
      companyRole: companyRole,
      empId: empId,
    );
    return model;
  }

  @override
  Future<List<UserClientEntity>> readAllUser() {
    return firestoreUserClientDatasource.readAllUsers();
  }
}
