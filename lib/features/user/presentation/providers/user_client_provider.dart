import 'package:flutter/cupertino.dart';
import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/update_client_fields_use_case.dart';

class UserClientProvider extends ChangeNotifier {
  final UpdateClientFieldsUseCase updateClientFieldsUseCase;

  UserClientProvider({required this.updateClientFieldsUseCase});

  UserClientEntity? updatedUser;

  Future<void> updateFields({
    required String userUid,
    required String companyRole,
    required String empId,
  }) async {
    updatedUser = await updateClientFieldsUseCase(userUid, companyRole, empId);
    notifyListeners();
  }
}
