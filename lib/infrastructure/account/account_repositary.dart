import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/infrastructure/account/account_service.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final service = ref.watch(accountServiceProvider);
  return AccountRepository(service);
});

class AccountRepository {
  final AccountService _service;

  AccountRepository(this._service);

  Future<List<Account>> getAccounts() => _service.getAccounts();

  Future<Account> addAccount(Account account) => _service.addAccount(account);

  Future<Account> updateAccount(Account account) {
    if (account.id == null) {
      throw Exception('Account ID cannot be null for update');
    }
    return _service.updateAccount(account);
  }

  Future<void> deleteAccount(String id) => _service.deleteAccount(id);
}
