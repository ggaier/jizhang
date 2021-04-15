import '../vo/account_entity.dart';

abstract class AccountsRepoIn {
  Future<List<Account>> getAllAccounts();

  Future<void> saveOrUpdateAccount(Account account);
}

class AccountsRepoImpl extends AccountsRepoIn {
  @override
  Future<List<Account>> getAllAccounts() async {
    return Future.delayed(Duration(milliseconds: 100), () {
      return List.generate(3, (index) => Account(index, "现金$index", 100, "现金", "模拟现金账户"));
    });
  }

  @override
  Future<void> saveOrUpdateAccount(Account account) {
    // TODO: implement saveOrUpdateAccount
    throw UnimplementedError();
  }
}
