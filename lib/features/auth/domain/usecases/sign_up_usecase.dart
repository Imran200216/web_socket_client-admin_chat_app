import 'package:socket_io_admin_client/features/auth/domain/entities/user_entitiy.dart';
import 'package:socket_io_admin_client/features/auth/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  Future<UserEntity> call(String userName, String email, String password) {
    return authRepository.signUp(userName, email, password);
  }
}
