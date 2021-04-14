import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';

class AddBillView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddBillState();
  }
}

class _AddBillState extends State {
  static const _BTN_PADDING = 36.0;
  static const _BTN_RADIUS = 18.0;
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
    return ListView(
      children: [_billTypeView(expenseColor, earningColor), _billForm()],
    );
  }

  Widget _billForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("日期"),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: "当前时间",
                    onTap: () {
                      //弹出时间选择弹框
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("账户"),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "请选择您的付款账户"),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("分类"),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "请选择账单类别"),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("金额"),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "输入付款金额"),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("备注"),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "添加账单备注"),
                  ),
                )
              ],
            ),
            Center(
              child: ElevatedButton(child: const Text("保存"), onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }

  Widget _billTypeView(Color expenseColor, Color earningColor) {
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
                padding: const EdgeInsets.symmetric(horizontal: _BTN_PADDING),
                side: BorderSide(color: expenseColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_BTN_RADIUS), side: BorderSide(color: expenseColor)))),
        OutlinedButton(
            child: Text("收入", style: TextStyle(color: earningColor)),
            onPressed: () => _onBillTypeChanged(BillType.earning),
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: _BTN_PADDING),
                side: BorderSide(color: earningColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_BTN_RADIUS), side: BorderSide(color: earningColor)))),
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
