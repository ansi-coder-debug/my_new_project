import 'package:dio/dio.dart';
import 'package:my_new_project/core/models/user/user.dart';


class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5000/api',  // Replace with your real API
    // 'http://localhost:5000/api', gtp says this for web
   
    headers: {'Content-Type': 'application/json'},
  ));

  Future<User?> signup(String name, String email, String password) async {
    try {
      final response = await _dio.post('/signup', data: {
        'name': name,
        'email': email,
        'password': password,
      });

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
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });

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

}
