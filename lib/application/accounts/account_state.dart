import 'package:my_new_project/core/models/account.dart';

class AccountState {
  final List<Account> accounts;
  final bool isLoading;
  final String? error;
  final Account? selectedAccount;

  AccountState({
    required this.accounts,
    this.isLoading = false,
    this.error,
    this.selectedAccount,
  });

  AccountState copyWith({
    List<Account>? accounts,
    bool? isLoading,
    String? error,
    Account? selectedAccount,
    bool clearSelected = false,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedAccount: clearSelected ? null : (selectedAccount ?? this.selectedAccount),
    );
  }
}
