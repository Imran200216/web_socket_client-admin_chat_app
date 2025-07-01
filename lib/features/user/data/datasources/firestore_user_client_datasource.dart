import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_admin_client/features/user/data/models/user_client_models.dart';

class FirestoreUserClientDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Update user fields
  Future<UserClientModel> updateClientFields({
    required String userUid,
    required String companyRole,
    required String empId,
  }) async {
    final docRef = _firestore.collection('userClients').doc(userUid);

    await docRef.update({
      'companyRole': companyRole,
      'empId': empId,
    });

    final updatedSnap = await docRef.get();
    return UserClientModel.fromJson(updatedSnap.data()!);
  }

  // ✅ Read all users from Firestore
  Future<List<UserClientModel>> readAllUsers() async {
    final snapshot = await _firestore.collection('userClients').get();

    return snapshot.docs.map((doc) {
      return UserClientModel.fromJson(doc.data());
    }).toList();
  }
}
