import 'package:accountbook/bill_accounts/bill_accounts_view.dart';
import 'package:accountbook/bill_category/bill_categories_view.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/utils/date_utils.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import 'add_bill_bloc.dart';

class AddBillView extends StatefulWidget {
  final ValueChanged<Tuple2<Bill, bool>> onAddBill;
  final Bill? initBill;

  bool get isUpdate {
    return initBill != null;
  }

  AddBillView({required this.onAddBill, Bill? updatingBill}) : this.initBill = updatingBill;

  @override
  State<StatefulWidget> createState() {
    return _AddBillViewState();
  }
}

class _AddBillViewState extends State<AddBillView> {
  static const _BTN_PADDING = 36.0;
  static const _BTN_RADIUS = 18.0;
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _billDateTEC = TextEditingController();
  final TextEditingController _billTimeTEC = TextEditingController();
  final TextEditingController _billCategoryTEC = TextEditingController();
  final TextEditingController _billAccountTEC = TextEditingController();

  AddBillBloc get _addBillBloc => context.read();

  TextStyle? get _billLabelStyle {
    return Theme.of(context).textTheme.caption;
  }

  @override
  void dispose() {
    super.dispose();
    _billDateTEC.dispose();
    _billTimeTEC.dispose();
    _billCategoryTEC.dispose();
    _billAccountTEC.dispose();
  }

  @override
  void initState() {
    super.initState();
    var initBill = widget.initBill;
    if (initBill != null) {
      _addBillBloc.setInitBill(initBill);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBillBloc, BaseBlocState>(
      builder: (context, state) {
        if (state is ABCompleteState) {
          return Container();
        }
        var bill = _addBillBloc.stateBill;
        print("init bill: ${bill.toJson()}");
        return Scaffold(
          appBar: AppBar(
            title: Text("${widget.isUpdate ? "编辑" : ""}${_billTypeToTitle(bill.billType)}"),
          ),
          body: _buildAddBillBody(bill),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formState,
        child: Column(
          children: [
            _billDateFormField(bill),
            _datePayAccountField(bill),
            _dateCategoryFormField(bill),
            _billAmountView(bill),
            _billRemarkFormField(bill),
            _saveBillBtn()
          ],
        ),
      ),
    );
  }

  Widget _saveBillBtn() {
    return Center(
      child: ElevatedButton(
          child: const Text("保存"),
          onPressed: () {
            if (_formState.currentState?.validate() == true) {
              _formState.currentState?.save();
              widget.onAddBill(Tuple2(_addBillBloc.stateBill, widget.isUpdate));
              _addBillBloc.saveBill();
              Navigator.maybePop(context, "");
            }
          }),
    );
  }

  Row _billRemarkFormField(Bill bill) {
    return Row(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text("备注", style: _billLabelStyle)),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(hintText: "添加账单备注"),
            initialValue: bill.remark.isEmpty ? null : bill.remark,
            onChanged: (value) {
              context.read<AddBillBloc>().setBillRemark(value);
            },
          ),
        )
      ],
    );
  }

  Row _billAmountView(Bill bill) {
    return Row(
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text("金额", style: _billLabelStyle)),
        Expanded(
          child: TextFormField(
            validator: (value) => value == null || value.isEmpty ? "输入付款金额" : null,
            decoration: const InputDecoration(hintText: "输入付款金额"),
            initialValue: bill.amount > 0 ? bill.readableAmount : null,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            keyboardType: TextInputType.number,
            onChanged: (value) {
              context.read<AddBillBloc>().setBillAmount(double.parse(value));
            },
          ),
        )
      ],
    );
  }

  Row _billDateFormField(Bill bill) {
    _billTimeTEC.text = bill.billTimeOfTheDay.format(context);
    _billDateTEC.text = bill.billDateDateTime.fmtDateForAddBill();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "日期",
            style: _billLabelStyle,
          ),
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
    if (value == null) return;
    context.read<AddBillBloc>().setBillType(value);
  }

  void _showDatePicker(BuildContext context) async {
    var nowTime = DateTime.now();
    final dateTime = await showDatePicker(
        context: context, initialDate: nowTime, firstDate: DateTime.fromMillisecondsSinceEpoch(0), lastDate: nowTime);
    if (dateTime == null) return;
    BlocProvider.of<AddBillBloc>(context).setBillDate(dateTime.millisecondsSinceEpoch);
  }

  _showTimePicker(BuildContext context) async {
    final timeOfDay = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (timeOfDay == null) return;
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

  Widget _dateCategoryFormField(Bill bill) {
    var billGenre = bill.category?.name;
    if (billGenre != null) {
      _billCategoryTEC.text = billGenre;
    }
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "分类",
              style: _billLabelStyle,
            )),
        Expanded(
          child: TextFormField(
            validator: (value) => value == null || value.isEmpty ? "请选择账单类别" : null,
            decoration: const InputDecoration(hintText: "请选择账单类别"),
            readOnly: true,
            controller: _billCategoryTEC,
            onTap: () => _addBillBloc.showBillCategoryDialog(context),
          ),
        )
      ],
    );
  }

  Widget _datePayAccountField(Bill bill) {
    var accountName = bill.account?.name;
    if (accountName != null) {
      _billAccountTEC.text = accountName;
    }
    return Row(
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text("账户", style: _billLabelStyle)),
        Expanded(
          child: TextFormField(
            validator: (value) => value == null || value.isEmpty ? "请选择您的付款账户" : null,
            decoration: const InputDecoration(hintText: "请选择您的付款账户"),
            readOnly: true,
            controller: _billAccountTEC,
            onTap: () => _addBillBloc.showAccountsDialog(context),
          ),
        )
      ],
    );
  }
}
