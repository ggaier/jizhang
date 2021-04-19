import 'package:floor/floor.dart';

import '../vo/account_entity.dart';

abstract class AccountsRepoIn {
  Future<List<PayAccount>> getAllAccounts();

  Future<bool> saveOrUpdateAccount(PayAccount account);
}

@dao
abstract class AccountDao {
  @Query('SELECT * FROM PayAccount')
  Future<List<PayAccount>> getAllPayAccounts();

  @Query("SELECT * FROM PayAccount WHERE id = :id")
  Future<PayAccount?> findAccount(int id);

  @insert
  Future<int> insertAccount(PayAccount account);

  @update
  Future<int> updateAccount(PayAccount account);

  @delete
  Future<int> deleteAccount(PayAccount account);
}

class AccountsRepoImpl extends AccountsRepoIn {
  final AccountDao _accountDao;

  AccountsRepoImpl(this._accountDao);

  List<PayAccount> _builtInAccounts() {
    return [
      PayAccount(0, "现金", 0, "现金", ""),
      PayAccount(1, "借记卡", 0, "银行账户", ""),
      PayAccount(2, "信用卡", 0, "信用卡", ""),
    ];
  }

  @override
  Future<List<PayAccount>> getAllAccounts() async {
    return Future(() async {
      final accounts = await _accountDao.getAllPayAccounts();
      if (accounts.isEmpty) {
        final builtInAccounts = _builtInAccounts()
          ..forEach((element) {
            _accountDao.insertAccount(element);
          });
        return builtInAccounts;
      }
      return accounts;
    });
  }

  @override
  Future<bool> saveOrUpdateAccount(PayAccount account) {
    return Future(() async {
      final foundAccount = await _accountDao.findAccount(account.id);
      var effectRow = 0;
      if (foundAccount != null) {
        effectRow = await _accountDao.updateAccount(account);
      } else {
        effectRow = await _accountDao.insertAccount(account);
      }
      return effectRow == 1;
    });
  }
}
