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
      return List<Bill>.generate(
          100,
          (index) => Bill.name(
              DateTime.now().millisecond,
              "随机生成账户: ${index + 1}",
              "随机生成类别",
              Random.secure().nextInt(100),
              "¥",
              "随机生成备注"));
    });
  }
}
