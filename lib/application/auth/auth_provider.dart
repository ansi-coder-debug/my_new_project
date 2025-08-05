import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/infrastructure/auth/auth_service.dart';


// This provides an instance of your AuthService class
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// This is a class to hold signup form data (name, email, password)
class SignupParams {
  final String name;
  final String email;
  final String password;

  SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

// This provider allows you to trigger signup from the UI with those inputs
final signupProvider = FutureProvider.family<User?, SignupParams>((ref, params) async {
  final authService = ref.read(authServiceProvider);
  return await authService.signup(params.name, params.email, params.password);
});
