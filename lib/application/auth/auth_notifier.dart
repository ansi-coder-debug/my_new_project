// AuthState → stores user, isLoading, error

// AuthNotifier → controls login, signup, and logout
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/infrastructure/auth/auth_service.dart';


// 1️⃣ This holds user + loading + error
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}


// 2️⃣ This handles login, signup, and logout
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(AuthState());

  Future<void> signup(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final user = await authService.signup(name, email, password);

    if (user != null) {
      state = state.copyWith(isLoading: false, user: user);
      // TODO: Save token in Step 10
    } else {
      state = state.copyWith(isLoading: false, error: "Signup failed");
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final user = await authService.login(email, password);

    if (user != null) {
      state = state.copyWith(isLoading: false, user: user);
      // TODO: Save token in Step 10
    } else {
      state = state.copyWith(isLoading: false, error: "Login failed");
    }
  }

  void logout() {
    state = AuthState(); // resets everything
    // TODO: remove token in Step 10
  }
}
