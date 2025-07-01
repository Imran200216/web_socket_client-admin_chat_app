import 'package:socket_io_admin_client/features/auth/domain/repository/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository authRepository;

  ForgetPasswordUseCase({required this.authRepository});

  Future<void> call(String email) {
    return authRepository.forgetPassword(email);
  }
}
