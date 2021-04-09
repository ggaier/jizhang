import 'dart:async';
import 'dart:math';

import 'package:accountbook/vo/bill.dart';

abstract class BillsRepositoryIn {
  Future<void> getBillsByPage(int page);
}

class BillsRepositoryImpl implements BillsRepositoryIn {
  final _controller = StreamController<List<Bill>>();

  @override
  Future<void> getBillsByPage(int page) async {
    await Future.delayed(Duration(seconds: 5), () {
      final randomBills = List<Bill>.generate(
          100,
          (index) => Bill.name(
              DateTime.now().millisecond,
              "随机生成账户: ${index + 1}",
              "随机生成类别",
              Random.secure().nextInt(100),
              "¥",
              "随机生成备注"));
      _controller.add(randomBills);
    });
  }
}
