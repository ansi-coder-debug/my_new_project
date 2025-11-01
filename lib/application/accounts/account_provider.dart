import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_state.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/infrastructure/account/account_repositary.dart';


final accountProvider = StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return AccountNotifier(repository);
});

// class AccountNotifier extends StateNotifier<AccountState> {
//   final AccountRepository _repository;

//   AccountNotifier(this._repository) : super(AccountState(accounts: [])) {
//     loadAccounts();
//   }

//   Future<void> loadAccounts() async {
//      print("🚀 loadAccounts called");
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       final accounts = await _repository.getAccounts();
//       print('🧾 Loaded accounts count: ${accounts.length}');

//       state = state.copyWith(accounts: accounts, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> addAccount(Account account) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       print('➕ Adding account: ${account.name}');
//       await _repository.addAccount(account);
      
//       print('✅ Account added, reloading accounts');
//       await loadAccounts();
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> updateAccount(Account account) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _repository.updateAccount(account);
//       await loadAccounts();
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> deleteAccount(String id) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _repository.deleteAccount(id);
//       await loadAccounts();
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   void setSelectedAccount(Account? account) {
//     state = state.copyWith(selectedAccount: account);
//   }

//   void clearSelectedAccount() {
//     state = state.copyWith(clearSelected: true);
//   }
// }
class AccountNotifier extends StateNotifier<AccountState> {
  final AccountRepository _repository;

  AccountNotifier(this._repository) : super(AccountState(accounts: [])) {
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    print("🚀 loadAccounts called");
    try {
      state = state.copyWith(isLoading: true, error: null);
      final accounts = await _repository.getAccounts();
      print('🧾 Loaded accounts count: ${accounts.length}');
      state = state.copyWith(accounts: accounts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addAccount(Account account) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      print('➕ Adding account: ${account.name}');
      await _repository.addAccount(account);
      print('✅ Account added, reloading accounts');
      await loadAccounts();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ADD THESE NEW METHODS:

  Future<void> updateAccount(Account account) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateAccount(account);
      await loadAccounts();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteAccount(id);
      await loadAccounts();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  void setSelectedAccount(Account? account) {
    state = state.copyWith(selectedAccount: account);
  }

  void clearSelectedAccount() {
    state = state.copyWith(clearSelected: true);
  }



}