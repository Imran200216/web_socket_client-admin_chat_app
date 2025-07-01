import 'package:socket_io_admin_client/features/auth/domain/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase({required this.authRepository});

  Future<void> call() {
    return authRepository.signOut();
  }
}
