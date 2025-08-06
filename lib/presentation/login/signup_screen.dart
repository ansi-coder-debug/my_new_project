import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/presentation/login/login_screen.dart';

// UI → Provider → Repository → Service (API).
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  void _submitForm(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final notifier = ref.read(
        authNotifierProvider.notifier,
      ); // 👈 Get notifier

      await notifier.signup(name, email, password); // 👈 Call signup()

      final state = ref.read(authNotifierProvider); // 👈 Read latest state

      if (state.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Signup successful')));

        // ✅ Navigate to main screen
        Future.delayed(const Duration(microseconds: 500), () {
          Navigator.of(context).pushReplacementNamed('/main');
        });

      } else if (state.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ ${state.error}')));
      }
    } else {
      debugPrint('🔴 Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator()) //show spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter name' : null,
                    ),

                    TextFormField(
                         style: TextStyle(color: Colors.black),
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter email';
                        }
                        if (!value.contains('@')) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                         style: TextStyle(color: Colors.black),
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) => value == null || value.length < 6
                          ? 'Minimum 6 characters'
                          : null,
                    ),

                    TextFormField(
                         style: TextStyle(color: Colors.black),
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    KHeight20,
                    ElevatedButton(
                      onPressed: () => _submitForm(ref),
                      child: const Text('Signup'),
                    ),
                    KHeight16,
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
