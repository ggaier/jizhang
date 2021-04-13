import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';

class AddBillView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddBillState();
  }
}

class _AddBillState extends State {
  BillType _billType = BillType.expense;
  String _title = "支出";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: _buildAddBillBody(context));
  }

  Widget _buildAddBillBody(BuildContext context) {
    final expenseColor = (_billType == BillType.expense ? Colors.green[300] : Colors.grey[400])!;
    final earningColor = (_billType == BillType.earning ? Colors.red[300] : Colors.grey[400])!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 45),
        OutlinedButton(
            child: Text(
              "支出",
              style: TextStyle(color: expenseColor),
            ),
            onPressed: () => _onBillTypeChanged(BillType.expense),
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                side: BorderSide(color: expenseColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: expenseColor)))),
        OutlinedButton(
            child: Text("收入", style: TextStyle(color: earningColor)),
            onPressed: () => _onBillTypeChanged(BillType.earning),
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                side: BorderSide(color: earningColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: earningColor)))),
        SizedBox(width: 45),
      ],
    );
  }

  void _onBillTypeChanged(BillType? value) {
    if (value == null) return;
    setState(() {
      _billType = value;
      switch (value) {
        case BillType.expense:
          _title = "支出";
          break;
        case BillType.earning:
          _title = "收入";
          break;
        case BillType.transfer:
          _title = "转账";
          break;
        default:
        //do nothing
      }
    });
  }
}
