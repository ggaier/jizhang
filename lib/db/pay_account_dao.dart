import 'package:accountbook/vo/account_entity.dart';
import 'package:floor/floor.dart';

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
