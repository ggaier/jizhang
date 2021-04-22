import 'package:accountbook/vo/bill.dart';
import 'package:floor/floor.dart';
import 'dart:async';

@dao
abstract class BillDao {

  @Query("SELECT * FROM ${Bill.TABLE_NAME} ORDER BY ${Bill.COLUMN_BILL_DATE} DESC, ${Bill.COLUMN_BILL_TIME} DESC")
  Future<List<Bill>> getAllBills();

  @Query("SELECT * FROM ${Bill.TABLE_NAME} ORDER BY ${Bill.COLUMN_BILL_DATE} DESC, ${Bill.COLUMN_BILL_TIME} DESC LIMIT :pageSize OFFSET :offset")
  Future<List<Bill>> findBillsByPage(int pageSize, int offset);

  @insert
  Future<int> insertBill(Bill bill);

  @update
  Future<int> updateBill(Bill bill);
}
