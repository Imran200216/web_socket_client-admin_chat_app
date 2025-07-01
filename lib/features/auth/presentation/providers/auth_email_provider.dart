import 'package:flutter/material.dart';
import 'package:socket_io_admin_client/features/auth/domain/entities/user_entitiy.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/sign_up_usecase.dart';

class AuthEmailProvider with ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final SignOutUseCase signOutUseCase;

  AuthEmailProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.forgetPasswordUseCase,
    required this.signOutUseCase,
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  UserEntity? _currentUser;

  UserEntity? get currentUser => _currentUser;

  String? _error;

  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // Sign In
  Future<void> signInWithEmailPassword(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await signInUseCase(email, password);
      _currentUser = user;
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  // Sign Up
  Future<void> signUpWithEmailPassword(
    String userName,
    String email,
    String password,
  ) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await signUpUseCase(userName, email, password);
      _currentUser = user;
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  // Sign Out
  Future<void> signOut() async {
    _setLoading(true);
    _setError(null);

    try {
      // Call domain-level sign out use case
      await signOutUseCase();

      // Clear current user
      _currentUser = null;
    } catch (e) {
      // Log the error and set error state
      _setError(e.toString());
    }

    // End loading and notify UI
    _setLoading(false);

    // Final notify to update UI with cleared user
    notifyListeners();
  }

  // Forgot Password
  Future<void> sendResetEmailPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      await forgetPasswordUseCase(email);
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }
}
