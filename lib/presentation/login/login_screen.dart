import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/presentation/main_page/widgets/screen_main_page.dart';
import 'register_screen.dart'; // Make sure the path is correct



class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

 void _submitLogin() async {
  if (_formKey.currentState!.validate()) {
    // final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();

    // Trigger login using AuthNotifier
    await ref
        .read(authNotifierProvider.notifier)
        // .login(email, password);
         .login(name, password);

    // Read current auth state
    final state = ref.read(authNotifierProvider);

    if (state.user != null) {
      // Login successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ScreenMainPage()),
      );
    } else if (state.error != null) {
      // Show login error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TextFormField(
              //      style: TextStyle(color: Colors.black),
              //   controller: _emailController,
              //   decoration: const InputDecoration(labelText: 'Email'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Enter email';
              //     }
              //     if (!value.contains('@')) {
              //       return 'Enter valid email';
              //     }
              //     return null;
              //   },
              // ),
               TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter name' : null,
                    ),
              TextFormField(
                   style: TextStyle(color: Colors.black),
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Minimum 6 characters';
                  }
                  return null;
                },
              ),

              KHeight16,
              ElevatedButton(
                onPressed: _submitLogin,
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Register',
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
