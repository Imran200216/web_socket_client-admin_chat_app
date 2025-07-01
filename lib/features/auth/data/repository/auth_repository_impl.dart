import 'package:socket_io_admin_client/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:socket_io_admin_client/features/auth/domain/entities/user_entitiy.dart';
import 'package:socket_io_admin_client/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;

  AuthRepositoryImpl(this.firebaseAuthDataSource);

  @override
  Future<void> forgetPassword(String email) async {
    await firebaseAuthDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final user = await firebaseAuthDataSource.signInWithEmailPassword(
      email,
      password,
    );
    final username = await firebaseAuthDataSource.fetchUsername(user.uid);

    return UserEntity(uid: user.uid, email: user.email!, userName: username);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuthDataSource.signOut();
  }

  @override
  Future<UserEntity> signUp(
    String userName,
    String email,
    String password,
  ) async {
    final user = await firebaseAuthDataSource.signUpWithEmailPassword(
      userName,
      email,
      password,
    );
    final fetchedUsername = await firebaseAuthDataSource.fetchUsername(
      user.uid,
    );

    return UserEntity(
      uid: user.uid,
      email: user.email!,
      userName: fetchedUsername,
    );
  }
}
