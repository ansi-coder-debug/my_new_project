// Mid-level: Business logic, app-wide rules, connects Service ↔ Provider
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/infrastructure/auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🟩 ADD THIS
import 'package:my_new_project/application/auth/auth_provider.dart'; // 🟩 ADD THIS

class AuthRepository {
  final AuthService _authService;

  // 🟩 Add this to get access to AuthNotifier inside signup()
  final Ref ref; // 🟩 NEW: Accept Ref (Riverpod reference)

  AuthRepository(
    this._authService,
    this.ref,
  ); // 🟩 UPDATE constructor to include ref

  Future<User?> register(String name, String password) async {
    final user = await _authService.register(name, password);
    if (user != null) {
      await _saveUserToHive(user);

      // 🟩 NEW: Notify Riverpod's AuthNotifier
      ref.read(authNotifierProvider.notifier).setUser(user);
    }
    return user;
  }

  Future<User?> login(String username, String password) async {
    final user = await _authService.login(username, password);
    if (user != null) {
      await _saveUserToHive(user);
      ref.read(authNotifierProvider.notifier).setUser(user);
    }
    return user;
  }

  Future<User?> loadUserFromHive() async {
    final box = await Hive.openBox('authBox');
    // final user = box.get('user');
    // if (user != null && user is User) {
    //   print('📤 Loaded from Hive: ${user.toJson()}'); // 👈 ADD THIS LINE
    //   return user;
    // }

    final userJson = box.get('user');
    if (userJson != null) {
      return User.fromJson(Map<String, dynamic>.from(userJson));
    }
    return null;
  }

  Future<void> logout() async {
    final box = await Hive.openBox('authBox');
    await box.delete('user');
  }

  Future<void> _saveUserToHive(User user) async {
    final box = await Hive.openBox('authBox');
    await box.put('user', user.toJson()); // Ensure using updated toJson()
    print('📦 Saved to Hive: ${user.toJson()}'); // 👈 ADD THIS LINE
  }
}
