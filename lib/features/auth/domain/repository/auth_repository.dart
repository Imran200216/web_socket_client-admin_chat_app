import 'package:socket_io_admin_client/features/auth/domain/entities/user_entitiy.dart';

abstract class AuthRepository {
  // Sign Up
  Future<UserEntity> signUp(String userName, String email, String password);

  // Sign In
  Future<UserEntity> signIn(String email, String password);

  Future<void> signOut();

  // Forget Password
  Future<void> forgetPassword(String email);
}
