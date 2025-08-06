// AuthState → stores user, isLoading, error

// AuthNotifier → controls login, signup, and logout
import 'package:hive/hive.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/infrastructure/auth/auth_repositary.dart';
import 'package:my_new_project/infrastructure/auth/auth_service.dart';

// 1️⃣ This holds user + loading + error
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, User? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

// 2️⃣ This handles login, signup, and logout,loadUser using AuthRepository
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState());

  Future<void> signup(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final user = await _authRepository.signup(name, email, password);

    if (user != null) {
      // ✅ Save user or token to Hive
      // final box = await Hive.openBox('authBox');
      // await box.put('user', user.toJson());
      // state = state.copyWith(isLoading: false, user: user);
      await login(email, password);
    } else {
      state = state.copyWith(isLoading: false, error: "Signup failed");
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final user = await _authRepository.login(email, password);

    if (user != null) {
      // ✅ Save user or token to Hive
      final box = await Hive.openBox('authBox');
      await box.put('user', user.toJson());
      state = state.copyWith(isLoading: false, user: user);
    } else {
      state = state.copyWith(isLoading: false, error: "Login failed");
    }
  }

  Future<void> logout() async {
    state = AuthState(); // Clear in memory state

    final box = await Hive.openBox('authBox');
    await box.delete('user'); // Remove saved user from Hive
  }

  // Read that saved user info from Hive Load it into your app’s state (via Riverpod)So user doesn’t need to log in again
  Future<void> loadUserFromHive() async {
    final box = await Hive.openBox('authBox'); // Open Hive box
    final userJson = box.get('user'); // Try to get the saved user

    if (userJson != null) {
      // Convert the saved map back into a User object
      final user = User.fromJson(Map<String, dynamic>.from(userJson));

      // Update the app's auth state with this user
      state = state.copyWith(user: user);
    }
  }
}
