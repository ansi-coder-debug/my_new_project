import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_notifier.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/infrastructure/auth/auth_service.dart';

// Provides a shared AuthService instance
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provides access to the AuthNotifier which manages login, signup, logout
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});
