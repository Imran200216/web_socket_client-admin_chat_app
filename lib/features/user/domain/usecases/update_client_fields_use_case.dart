import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';
import 'package:socket_io_admin_client/features/user/domain/repository/user_client_repository.dart';

class UpdateClientFieldsUseCase {
  final UserClientRepository userClientRepository;

  UpdateClientFieldsUseCase({required this.userClientRepository});

  Future<UserClientEntity> call(
    String companyRole,
    String empId,
    String userUid,
  ) async {
    return await userClientRepository.updateClientFields(
      companyRole,
      empId,
      userUid,
    );
  }
}
