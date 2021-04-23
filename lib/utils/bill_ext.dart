import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';

extension BillExt on Bill {

  Color get billAmountColor {
    final billType = this.billType;
    Color color;
    switch (billType) {
      case BillType.earning:
        color = Colors.red[300]!;
        break;
      case BillType.expense:
        color = Colors.green[300]!;
        break;
      case BillType.summary:
        color = Colors.black54;
        break;
      case BillType.transfer:
        color = Colors.black54;
        break;
    }
    return color;
  }
}
