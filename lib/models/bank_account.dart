class BankAccount {
  late String accountNumber;

  bool _isAccountNumberInitialized = false;

  final String holderName;
  double balance;
  final String? bankBranch;

  BankAccount({
    required this.holderName,
    this.balance = 0.0,
    this.bankBranch,
  });

  void initializeAccount(String number) {
    accountNumber = number;
    _isAccountNumberInitialized = true;
  }

  bool isAccountNumberSet() {
    return _isAccountNumberInitialized;
  }

  String getDisplayAccountNumber() {
    if (_isAccountNumberInitialized) {
      return accountNumber;
    }

    return 'Account number not initialized';
  }
}

