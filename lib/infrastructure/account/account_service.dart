import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  final dio = Dio();
  return AccountService(dio, ref);
});

class AccountService {
  final Dio _dio;
  final Ref _ref;

  AccountService(this._dio, this._ref);

  Future<List<Account>> getAccounts() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    print("🔑 Access token: $token");
    final response = await _dio.get(
      '$HbaseUrl/account',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print("🌐 Raw Response: ${response.data}");

    final data = response.data as List;
    return data.map((json) => Account.fromJson(json)).toList();
//     final List<Account> accounts = [];

// for (final json in data) {
//   try {
//     final account = Account.fromJson(json);
//     accounts.add(account);
//   } catch (e) {
//     print("❌ Error parsing account: $e\nProblem JSON: $json");
//   }
// }

// return accounts;

  }

  Future<Account> addAccount(Account account) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      '$HbaseUrl/account',
      data: account.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Account.fromJson(response.data);
  }

  Future<Account> updateAccount(Account account) async {
    if (account.id == null) {
      throw Exception('Account ID is required for update');
    }
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      '$HbaseUrl/account/${account.id}',
      data: account.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Account.fromJson(response.data);
  }

  Future<void> deleteAccount(String id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      '$HbaseUrl/account/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
