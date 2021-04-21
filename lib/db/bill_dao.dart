import 'package:accountbook/vo/bill.dart';
import 'package:floor/floor.dart';
import 'dart:async';

@dao
abstract class BillDao {

  @Query("SELECT * FROM ${Bill.TABLE_NAME} ORDER BY ${Bill.COLUMN_BILL_DATE} DESC, ${Bill.COLUMN_BILL_TIME} DESC")
  Future<List<Bill>> getAllBills();

  @insert
  Future<int> insertBill(Bill bill);

  @update
  Future<int> updateBill(Bill bill);
}
