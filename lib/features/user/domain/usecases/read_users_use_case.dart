import 'package:socket_io_admin_client/features/user/domain/entities/user_client_entity.dart';
import 'package:socket_io_admin_client/features/user/domain/repository/user_client_repository.dart';

class ReadUsersUseCase {
  final UserClientRepository userClientRepository;

  ReadUsersUseCase({required this.userClientRepository});

  Future<List<UserClientEntity>> call() async {
    return await userClientRepository.readAllUser();
  }
}
