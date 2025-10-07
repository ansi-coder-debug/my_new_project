// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/core/models/partner.dart';
// import 'package:my_new_project/application/auth/auth_provider.dart';

// final partnerServiceProvider = Provider<PartnerService>((ref) {
//   final dio = Dio();
//   return PartnerService(dio, ref);
// });

// class PartnerService {
//   final Dio _dio;
//   final Ref _ref;

//   PartnerService(this._dio, this._ref);

//   Future<List<Partner>> getPartners() async {
//     final auth = _ref.read(authNotifierProvider);
//     final token = auth.user?.accessToken;

//     if (token == null) throw Exception('User not authenticated');

//     final response = await _dio.get(
//       '$HbaseUrl/partners',
//       options: Options(headers: {
//         'Authorization': 'Bearer $token',
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = response.data as List;
//       return data.map((e) => Partner.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to fetch partners');
//     }
//   }

//   Future<Partner> createPartner(Partner partner) async {
//     final auth = _ref.read(authNotifierProvider);
//     final token = auth.user?.accessToken;

//     if (token == null) throw Exception('User not authenticated');

//     final response = await _dio.post(
//       '$HbaseUrl/partners',
//       data: partner.toJson(),
//       options: Options(headers: {
//         'Authorization': 'Bearer $token',
//       }),
//     );

//     if (response.statusCode == 201 || response.statusCode == 200) {
//       return Partner.fromJson(response.data);
//     } else {
//       throw Exception('Failed to create partner');
//     }
//   }
// }





import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final partnerServiceProvider = Provider<PartnerService>((ref) {
  final dio = Dio();
  return PartnerService(dio, ref);
});

class PartnerService {
  final Dio _dio;
  final Ref _ref;

  PartnerService(this._dio, this._ref);

  String? _getToken() {
    final auth = _ref.read(authNotifierProvider);
    return auth.user?.accessToken;
  }

  Future<List<Partner>> getPartners() async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.get(
      '$HbaseUrl/partners',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((e) => Partner.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch partners');
    }
  }

  Future<Partner> createPartner(Partner partner) async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.post(
      '$HbaseUrl/partners',
      data: partner.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Partner.fromJson(response.data);
    } else {
      throw Exception('Failed to create partner');
    }
  }

  Future<Partner> updatePartner(String id, Map<String, dynamic> data) async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.put(
      '$HbaseUrl/partners/$id',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return Partner.fromJson(response.data);
    } else {
      throw Exception('Failed to update partner');
    }
  }

  Future<void> deletePartner(String id) async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.delete(
      '$HbaseUrl/partners/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete partner');
    }
  }
}
