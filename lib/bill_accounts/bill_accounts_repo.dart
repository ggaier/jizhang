import '../vo/account_entity.dart';

abstract class AccountsRepoIn {
  Future<List<PayAccount>> getAllAccounts();

  Future<void> saveOrUpdateAccount(PayAccount account);
}

class AccountsRepoImpl extends AccountsRepoIn {
  @override
  Future<List<PayAccount>> getAllAccounts() async {
    return Future.delayed(Duration(milliseconds: 100), () {
      return List.generate(3, (index) => PayAccount(index, "现金$index", 100, "现金", "模拟现金账户"));
    });
  }

  @override
  Future<void> saveOrUpdateAccount(PayAccount account) {
    // TODO: implement saveOrUpdateAccount
    throw UnimplementedError();
  }
}
