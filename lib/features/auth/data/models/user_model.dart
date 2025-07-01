import 'package:socket_io_admin_client/features/auth/domain/entities/user_entitiy.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.userName,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'userName': userName};
  }

  factory UserModel.fromFirebaseUser(dynamic user, String userName) {
    return UserModel(uid: user.uid, email: user.email, userName: userName);
  }
}
