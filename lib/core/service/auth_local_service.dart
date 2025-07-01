import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalService {
  static const String _authStatusKey = 'isAuthenticated';
  static const String _hasDesignationKey = 'hasDesignation';
  static const String _userRoleKey = 'userRole';

  /// Set Auth status
  static Future<void> setAuthStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authStatusKey, status);
  }

  /// Get Auth status
  static Future<bool> getAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authStatusKey) ?? false;
  }

  /// Set whether the user has selected a designation
  static Future<void> setHasDesignation(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasDesignationKey, status);
  }

  /// Get whether the user has selected a designation
  static Future<bool> getHasDesignation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasDesignationKey) ?? false;
  }

  /// Set user role (e.g. "admin" or "user")
  static Future<void> setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  /// Get user role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  /// Clear all auth-related local data
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authStatusKey);
    await prefs.remove(_hasDesignationKey);
    await prefs.remove(_userRoleKey);
  }
}
