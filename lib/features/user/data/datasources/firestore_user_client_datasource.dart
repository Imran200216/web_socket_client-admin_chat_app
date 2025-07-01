import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_admin_client/features/user/data/models/user_client_models.dart';

class FirestoreUserClientDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserClientModel> updateClientFields({
    required String userUid,
    required String companyRole,
    required String empId,
  }) async {
    final docRef = _firestore.collection('userClients').doc(userUid);

    await docRef.update({'companyRole': companyRole, 'empId': empId});

    final updatedSnap = await docRef.get();

    return UserClientModel.fromJson(updatedSnap.data()!);
  }
}
