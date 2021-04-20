import 'dart:async';
import 'dart:math';

import 'package:accountbook/db/bill_category_dao.dart';
import 'package:accountbook/db/bill_dao.dart';
import 'package:accountbook/db/pay_account_dao.dart';
import 'package:accountbook/utils/date_utils.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:flutter/material.dart';

abstract class BillsRepositoryIn {
  Future<List<Bill>> getBillsByPage(int page);

  Future<bool> saveBill(Bill bill);
}

class BillsRepositoryImpl implements BillsRepositoryIn {
  final BillDao _billDao;
  final BillCategoryDao _billCategoryDao;
  final AccountDao _payAccountDao;

  BillsRepositoryImpl(this._billDao, this._billCategoryDao, this._payAccountDao);

  @override
  Future<List<Bill>> getBillsByPage(int page) async {
    final bills = await _billDao.getAllBills();
    for (Bill bill in bills) {
      final categoryId = bill.categoryId;
      if (categoryId != null) {
        final category = await _billCategoryDao.findBillCategory(categoryId);
        bill.category = category;
      }
      final payAccountId = bill.accountId;
      if (payAccountId != null) {
        final payAccount = await _payAccountDao.findAccount(payAccountId);
        bill.account = payAccount;
      }
    }
    return bills;
  }

  @override
  Future<bool> saveBill(Bill bill) async {
    await _billDao.insertBill(bill);
    return true;
  }
}
