// Mid-level: Business logic, app-wide rules, connects Service ↔ Provider
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/infrastructure/auth/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<User?> signup(String name, String email, String password) async {
    final user = await _authService.signup(name, email, password);
    if (user != null) {
      await _saveUserToHive(user);
    }
    return user;
  }

  Future<User?> login(String email, String password) async {
    final user = await _authService.login(email, password);
    if (user != null) {
      await _saveUserToHive(user);
    }
    return user;
  }

  Future<User?> loadUserFromHive() async {
    final box = await Hive.openBox('authBox');
    final user = box.get('user');

    if (user != null && user is User) {
      return user;
    }
    return null;
  }

  Future<void> logout() async {
    final box = await Hive.openBox('authBox');
    await box.delete('user');
  }

  Future<void> _saveUserToHive(User user) async {
    final box = await Hive.openBox('authBox');
    await box.put('user', user);
  }
}
