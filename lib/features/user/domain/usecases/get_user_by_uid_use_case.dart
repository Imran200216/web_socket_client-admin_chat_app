import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';
import 'package:socket_io_admin_client/features/user/domain/repository/user_client_repository.dart';

class GetUserByUidUseCase {
  final UserClientRepository repository;

  GetUserByUidUseCase(this.repository);

  Future<UserClientEntity> call(String uid) {
    return repository.getUserByUid(uid);
  }
}
