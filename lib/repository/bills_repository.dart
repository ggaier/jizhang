import 'dart:async';
import 'dart:math';

import 'package:accountbook/vo/bill.dart';

abstract class BillsRepositoryIn {
  Future<List<Bill>> getBillsByPage(int page);
}

class BillsRepositoryImpl implements BillsRepositoryIn {
  @override
  Future<List<Bill>> getBillsByPage(int page) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List<Bill>.generate(100, (index) {
        if (index % 3 == 0) return DayBill.name(index, DateTime.now().millisecondsSinceEpoch, "", "", 0, "¥", "", 10000, 100);
        return Bill.name(index, DateTime.now().millisecondsSinceEpoch, "随机生成账户: ${index + 1}", "随机生成类别",
            Random.secure().nextInt(100), "¥", "随机生成备注", BillType.expense);
      });
    });
  }
}
