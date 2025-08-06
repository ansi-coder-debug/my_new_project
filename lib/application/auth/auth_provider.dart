// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/auth/auth_notifier.dart';
// import 'package:my_new_project/core/models/user/user.dart';
// import 'package:my_new_project/infrastructure/auth/auth_service.dart';

// // Provides a shared AuthService instance
// final authServiceProvider = Provider<AuthService>((ref) {
//   return AuthService();
// });

// // Provides access to the AuthNotifier which manages login, signup, logout
// final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   final authService = ref.read(authServiceProvider);
//   return AuthNotifier(authService);
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_notifier.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/infrastructure/auth/auth_service.dart';
import 'package:my_new_project/infrastructure/auth/auth_repositary.dart'; // 👈 NEW import

// Lowest level: API + Hive access
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Mid-level: Handles app-wide business logic
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthRepository(authService);
});

// Top-level: Manages UI state (login/signup/logout)
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider); // 👈 now using repository
  return AuthNotifier(authRepository); // 👈 inject repository into AuthNotifier
});
