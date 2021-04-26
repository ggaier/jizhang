import 'dart:async';

import 'package:accountbook/db/bill_category_dao.dart';
import 'package:accountbook/db/bill_dao.dart';
import 'package:accountbook/db/pay_account_dao.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:tuple/tuple.dart';

abstract class BillsRepositoryIn {
  Future<List<Bill>> getBillsByPage(int page, int pageSize);

  /// 按照时间段来查询其间的所有账单.
  /// 其中[startDate] 是开始时间(包含), [endDate] 是结束时间(不包含).
  /// 时间单位都是ms.
  Future<List<Bill>> getBillsByDateRange(int startDate, int endDate);

  Future<int> saveBill(Bill bill);

  Future<int> deleteBill(Bill bill);
}

class BillsRepositoryImpl implements BillsRepositoryIn {
  final BillDao _billDao;
  final BillCategoryDao _billCategoryDao;
  final AccountDao _payAccountDao;

  BillsRepositoryImpl(this._billDao, this._billCategoryDao, this._payAccountDao);

  @override
  Future<List<Bill>> getBillsByPage(int page, int pageSize) async {
    final revisedPage = page <= 0 ? 1 : page;
    final offset = (revisedPage - 1) * pageSize;
    final bills = await _billDao.findBillsByPage(pageSize, offset);
    print("revised page: $revisedPage, offset: $offset, bills length: ${bills.length}");
    await processBills(bills);
    return bills;
  }

  Future processBills(List<Bill> bills) async {
    final compositionBills = Map<String, Tuple2<int, CompositionBill>>();
    for (Bill bill in bills) {
      final categoryId = bill.categoryId;
      final category = await _billCategoryDao.findBillCategory(categoryId);
      bill.category = category;
      final payAccountId = bill.accountId;
      final payAccount = await _payAccountDao.findAccount(payAccountId);
      bill.account = payAccount;
      final billDay = bill.yyyyMMdd;
      final index = bills.indexOf(bill);
      compositionBills.putIfAbsent(billDay, () => Tuple2(index, CompositionBill([]))).item2.addBill(ofTheDay: bill);
    }
    var insertOffset = 0;
    compositionBills.values.forEach((element) {
      bills.insert(element.item1 + insertOffset, element.item2);
      insertOffset++;
    });
  }

  @override
  Future<int> saveBill(Bill bill) async {
    var billId = bill.id;
    int row = 0;
    if (billId != null) {
      final foundBill = await _billDao.findBillById(billId);
      if (foundBill != null) {
        row = await _billDao.updateBill(bill);
        print("update bill: $row");
      }
    } else {
      row = await _billDao.insertBill(bill);
    }
    return row;
  }

  @override
  Future<List<Bill>> getBillsByDateRange(int startDate, int endDate) async {
    final bills = await _billDao.findBillsByMonthRange(startDate, endDate);
    print("month range $startDate, $endDate, bills size: ${bills.length}");
    await processBills(bills);
    return bills;
  }

  @override
  Future<int> deleteBill(Bill bill) {
    return _billDao.deleteBill(bill);
  }
}
