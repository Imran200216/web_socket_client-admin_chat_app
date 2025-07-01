import 'package:socket_io_admin_client/features/auth/domain/entities/user_entitiy.dart';
import 'package:socket_io_admin_client/features/auth/domain/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<UserEntity> call(String email, String password) {
    return authRepository.signIn(email, password);
  }
}
