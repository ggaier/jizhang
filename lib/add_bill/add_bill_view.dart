import 'package:accountbook/add_bill/add_bill_bloc.dart';
import 'package:accountbook/bill_accounts/bill_accounts_bloc.dart';
import 'package:accountbook/bill_accounts/bill_accounts_view.dart';
import 'package:accountbook/bill_category/bill_categories_view.dart';
import 'package:accountbook/utils/date_utils.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBillView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddBillViewState();
  }
}

class _AddBillViewState extends State {
  static const _BTN_PADDING = 36.0;
  static const _BTN_RADIUS = 18.0;
  final TextEditingController _billDateTEC = TextEditingController();
  final TextEditingController _billTimeTEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _billDateTEC.dispose();
    _billTimeTEC.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBillBloc, Bill>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_billTypeToTitle(state.billType)),
          ),
          body: _buildAddBillBody(state),
        );
      },
    );
  }

  Widget _buildAddBillBody(Bill state) {
    final billType = state.billType;
    final expenseColor = (billType == BillType.expense ? Colors.green[300] : Colors.grey[400])!;
    final earningColor = (billType == BillType.earning ? Colors.red[300] : Colors.grey[400])!;
    return ListView(
      children: [_billTypeView(expenseColor, earningColor), _billForm(state)],
    );
  }

  Widget _billForm(Bill bill) {
    final bloc = context.read<BillAccountsBloc>();
    print("bill account bloc: $bloc");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          children: [
            _dateFormField(bill),
            BillAccountSelectorView(),
            BillCategorySelectorView(),
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

  Row _dateFormField(Bill bill) {
    _billTimeTEC.text = bill.billTimeOfTheDay.format(context);
    _billDateTEC.text = bill.billDateDateTime.fmtDateForAddBill();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("日期"),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () => _showDatePicker(context),
                  controller: _billDateTEC,
                  readOnly: true,
                ),
              ),
              Expanded(
                child: TextFormField(
                  onTap: () => _showTimePicker(context),
                  readOnly: true,
                  controller: _billTimeTEC,
                ),
              ),
            ],
          ),
        )
      ],
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
    print("bill type: $value");
    if (value == null) return;
    context.read<AddBillBloc>().setBillType(value);
  }

  void _showDatePicker(BuildContext context) async {
    var nowTime = DateTime.now();
    final dateTime = await showDatePicker(
        context: context, initialDate: nowTime, firstDate: DateTime.fromMillisecondsSinceEpoch(0), lastDate: nowTime);
    if (dateTime == null) return;
    print("selected date time: ${dateTime.fmtDateForAddBill()}");
    BlocProvider.of<AddBillBloc>(context).setBillDate(dateTime.millisecondsSinceEpoch);
  }

  _showTimePicker(BuildContext context) async {
    final timeOfDay = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (timeOfDay == null) return;
    print("time of day: ${timeOfDay.format(context)}");
    context.read<AddBillBloc>().setBillTime(timeOfDay);
  }

  String _billTypeToTitle(BillType billType) {
    var title = "";
    switch (billType) {
      case BillType.expense:
        title = "支出";
        break;
      case BillType.earning:
        title = "收入";
        break;
      case BillType.summary:
        title = "汇总";
        break;
      case BillType.transfer:
        title = "转账";
        break;
    }
    return title;
  }
}
