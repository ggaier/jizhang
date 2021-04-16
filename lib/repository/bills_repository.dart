import 'dart:async';
import 'dart:math';

import 'package:accountbook/utils/date_utils.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:flutter/material.dart';

abstract class BillsRepositoryIn {
  Future<List<Bill>> getBillsByPage(int page);
  Future<void> saveBill(Bill bill);
}

class BillsRepositoryImpl implements BillsRepositoryIn {
  @override
  Future<List<Bill>> getBillsByPage(int page) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List<Bill>.generate(100, (index) {
        if (index % 3 == 0) return DayBill.name(index, DateTime.now().millisecondsSinceEpoch, 0, "¥", "", 10000, 100);
        return Bill.name(
            index,
            DateTime.now().millisecondsSinceEpoch,
            minsOfTheDay(),
            PayAccount.name(index, "随机生成账户: ${index + 1}", 0, "", ""),
            BillCategory("账单类型$index"),
            Random.secure().nextInt(100),
            "¥",
            "随机生成备注",
            BillType.expense);
      });
    });
  }

  @override
  Future<void> saveBill(Bill bill) {
    return Future.delayed(Duration(milliseconds: 50), (){
        print("save success");
    });
  }
}
