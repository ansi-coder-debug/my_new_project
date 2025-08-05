
import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/presentation/main_page/widgets/screen_main_page.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'value is Empty';
                    } else {
                      return null;
                    }
                  },
                ),

                KHeight20,

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'value is Empty';
                    } else {
                      return null;
                    }
                    // if (value == null || value.isEmpty) {
                    //   return 'Please enter a password';
                    // }
                    // return null; // input is valid
                  },
                ),
                KHeight20,

                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      checkLogin(context);
                    } else {
                      print('Data empty');
                    }
                  },
                  icon: Icon(Icons.check),
                  label: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkLogin(BuildContext ctx) async {
    final _username = _usernameController.text;
    final _password = _passwordController.text;
    if (_username == _password) {
      print('Username pass match');

      // ScreenMainPage(); go to home

    //   final _sharedPrefs = await SharedPreferences.getInstance();
    //  await _sharedPrefs.setBool(SAVE_KEY_NAME, true);

     
      Navigator.of(
        ctx,
      ).pushReplacement(MaterialPageRoute(builder: (ctx1) => ScreenMainPage()));
    } else {
      print('Username pass doesnot match');
    }
  }
}
