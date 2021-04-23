import 'dart:async';

import 'package:accountbook/db/bill_category_dao.dart';
import 'package:accountbook/db/bill_dao.dart';
import 'package:accountbook/db/pay_account_dao.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:tuple/tuple.dart';

abstract class BillsRepositoryIn {
  Future<List<Bill>> getBillsByPage(int page, int pageSize);

  Future<bool> saveBill(Bill bill);
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
    final compositionBills = Map<int, Tuple2<int, CompositionBill>>();
    for (Bill bill in bills) {
      final categoryId = bill.categoryId;
      final category = await _billCategoryDao.findBillCategory(categoryId);
      bill.category = category;
      final payAccountId = bill.accountId;
      final payAccount = await _payAccountDao.findAccount(payAccountId);
      bill.account = payAccount;
      final billDay = bill.billDate ~/ (1000 * 60 * 60 * 24);
      final index = bills.indexOf(bill);
      compositionBills
          .putIfAbsent(billDay, () => Tuple2(index, CompositionBill([], billDay)))
          .item2
          .addBill(ofTheDay: bill);
    }
    compositionBills.values.forEach((element) {
      bills.insert(element.item1, element.item2);
    });
    return bills;
  }

  @override
  Future<bool> saveBill(Bill bill) async {
    var billId = bill.id;
    int row = 0;
    if (billId != null) {
      final foundBill = await _billDao.findBillById(billId);
      if (foundBill != null) {
        row = await _billDao.updateBill(bill);
      }
    } else {
      row = await _billDao.insertBill(bill);
    }
    return row == 1;
  }
}
