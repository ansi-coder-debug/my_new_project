import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/advance.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final advanceServiceProvider = Provider<AdvanceService>((ref) {
  final dio = Dio();
  return AdvanceService(dio, ref);
});

class AdvanceService {
  final Dio _dio;
  final Ref _ref;

  AdvanceService(this._dio, this._ref);

  Future<List<Advance>> getAdvances() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      'http://192.168.29.29:5000/api/advances',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data as List;
    return data.map((json) => Advance.fromJson(json)).toList();
  }

  Future<Advance> addAdvance(Advance advance) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      'http://192.168.29.29:5000/api/advances',
      data: advance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Advance.fromJson(response.data);
  }

  Future<Advance> updateAdvance(Advance advance) async {
    if (advance.id == null) throw Exception('Advance ID is required for update');

    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      'http://192.168.29.29:5000/api/advances/${advance.id}',
      data: advance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Advance.fromJson(response.data);
  }

  Future<void> deleteAdvance(int id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      'http://192.168.29.29:5000/api/advances/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}

/*Sure! Here’s a clear and concise explanation you can use to explain your project and the current problem to someone else:

---

**Project Overview:**

I’m working on a Flutter app for managing vehicle-related data, including details about vehicles, sales, purchases, partnerships, and financial advances related to the vehicles. The app communicates with a backend server (hosted locally at `192.168.29.29:5000`) to fetch and send data.

One key feature is allowing users to select a vehicle from a dropdown that shows detailed information (make, model, registration ID). Another important part is the "Advance" feature, where users can add financial advance data related to vehicles.

---

**Current Problem:**

* When trying to add a new advance from the Flutter app, the data does not get saved on the backend.
* The backend responds with a **400 Bad Request** error, meaning it receives the request but rejects it because the data is invalid or not in the expected format.
* Additionally, I saw some **404 Not Found** errors for the advance API, indicating the endpoint URLs might be incorrect or missing on the backend.
* There’s also a UI overflow issue in the vehicle dropdown because the vehicle details (make, model, registration ID) are too long to fit in the space provided.

---

**Summary:**

I need to:

* Fix the API endpoint URLs to make sure the app talks to the correct backend routes.
* Ensure the data sent to the backend matches exactly what it expects — all required fields are included, formatted properly, and the headers (like `Content-Type`) are set correctly.
* Adjust the UI to prevent overflow when displaying vehicle information.

---

If you want, I can show you the Flutter code for the dropdown and the advance POST request, as well as the backend API specs, to help pinpoint the fixes.

---

Would you like me to help you prepare a more technical explanation or a simpler one?
*/