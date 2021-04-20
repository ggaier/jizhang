import 'package:accountbook/vo/bill.dart';
import 'package:floor/floor.dart';

@dao
abstract class BillDao {

  @Query("SELECT * FROM ${Bill.TABLE_NAME}")
  Future<List<Bill>> getAllBills();

  @insert
  Future<int> insertBill(Bill bill);

  @update
  Future<int> updateBill(Bill bill);
}
