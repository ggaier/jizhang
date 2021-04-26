import 'package:accountbook/vo/bill.dart';
import 'package:floor/floor.dart';
import 'dart:async';

@dao
abstract class BillDao {
  @Query("SELECT * FROM ${Bill.TABLE_NAME} ORDER BY ${Bill.COLUMN_BILL_DATE} DESC, ${Bill.COLUMN_BILL_TIME} DESC")
  Future<List<Bill>> getAllBills();

  @Query(
      "SELECT * FROM ${Bill.TABLE_NAME} ORDER BY ${Bill.COLUMN_BILL_DATE} DESC, ${Bill.COLUMN_BILL_TIME} DESC LIMIT :pageSize OFFSET :offset")
  Future<List<Bill>> findBillsByPage(int pageSize, int offset);

  @Query("SELECT * FROM ${Bill.TABLE_NAME} "
      "WHERE ${Bill.COLUMN_BILL_DATE} >= :startDate AND ${Bill.COLUMN_BILL_DATE} < :endDate "
      "ORDER BY ${Bill.COLUMN_BILL_DATE} DESC, ${Bill.COLUMN_BILL_TIME} DESC ")
  Future<List<Bill>> findBillsByMonthRange(int startDate, int endDate);

  @Query("SELECT * FROM ${Bill.TABLE_NAME} WHERE id = :id")
  Future<Bill?> findBillById(int id);

  @insert
  Future<int> insertBill(Bill bill);

  @update
  Future<int> updateBill(Bill bill);

  @delete
  Future<int> deleteBill(Bill bill);
}
