import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';

class UserClientModel extends UserClientEntity {
  UserClientModel({
    required super.userEmail,
    required super.userUid,
    required super.userName,
    required super.companyRole,
    required super.empId,
  });

  factory UserClientModel.fromJson(Map<String, dynamic> json) {
    return UserClientModel(
      userEmail: json['userEmail'] ?? '',
      userUid: json['userUid'] ?? '',
      userName: json['userName'] ?? '',
      companyRole: json['companyRole'] ?? '',
      empId: json['empId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userUid': userUid,
      'userName': userName,
      'companyRole': companyRole,
      'empId': empId,
    };
  }
}