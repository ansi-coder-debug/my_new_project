import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/user/user.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.29.29:5000/api/auth/',

      headers: {'Content-Type': 'application/json'},
      connectTimeout: Duration(seconds: 30),
    ),
  );

  Future<User?> register(String name, String password) async {
    try {
      final response = await _dio.post(
        // '/signup',
        '/register',
        data: {'username': name, /*'email': email,*/ 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // return User.fromJson(response.data);
        final data = response.data;
        print('📥 Backend SignUp  Response: $data'); // 👈 ADD THIS LINE

        return User.fromJson({
          ...data['user'], // unpack user object
          'token': data['token'], // include token explicitly
        });
      } else {
        print('Register failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // adding login
  Future<User?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        // return User.fromJson(response.data);

        final data = response.data;
        print('📥 Backend Login Response: $data'); // 👈 ADD THIS LINE

        return User.fromJson({...data['user'], 'token': data['token']});
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Load saved user from Hive
  Future<User?> loadUserFromHive() async {
    final box = await Hive.openBox('authBox');
    final user = box.get('user');

    if (user != null && user is User) {
      return user;
    }
    return null;
  }
}
