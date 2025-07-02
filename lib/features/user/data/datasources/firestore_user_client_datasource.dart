import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:socket_io_admin_client/features/user/data/models/user_client_models.dart';

class FirestoreUserClientDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserClientModel> updateClientFields({
    required String userUid,
    required String companyRole,
    required String empId,
  }) async {


    final docRef = _firestore
        .collection(AppDBConstants.userCollection)
        .doc(userUid);

    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      throw Exception("User document not found");
    }

    await docRef.update({'companyRole': companyRole, 'empId': empId});

    final updatedDoc = await docRef.get();
    return UserClientModel.fromJson({
      ...updatedDoc.data()!,
      'userUid': userUid,
    });
  }

  Future<List<UserClientModel>> readAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      return UserClientModel.fromJson({...doc.data(), 'userUid': doc.id});
    }).toList();
  }


  Future<UserClientModel> getUserByUid(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) throw Exception("User not found");
    return UserClientModel.fromJson(doc.data()!, uid);
  }
}
