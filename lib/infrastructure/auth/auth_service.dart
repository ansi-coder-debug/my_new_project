import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/user/user.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
      'http://10.0.2.2:5000/api', // Replace with your real API
      // 'http://localhost:5000/api',
      headers: {'Content-Type': 'application/json'},
        connectTimeout: Duration(seconds: 30), 
    ),
  );

  Future<User?> signup(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '/signup',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return User.fromJson(response.data);
      } else {
        print('Signup failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  // adding login
  Future<User?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
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
