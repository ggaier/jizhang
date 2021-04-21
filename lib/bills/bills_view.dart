import 'dart:ffi';

import 'package:accountbook/bills/bills_bloc.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BillsView extends StatelessWidget {
  final String _title;
  final DateTime? _date = DateTime.now().toLocal();
  final VoidCallback _onTapped;

  BillsView({required String title, required VoidCallback onTapped})
      : _title = title,
        _onTapped = onTapped;

  String _formattedDate(BuildContext context) {
    final df = DateFormat.yMMM(languageCode(context));
    return df.format(_date ?? DateTime.now());
  }

  String languageCode(BuildContext context) => Localizations.localeOf(context).languageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBillsView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapped,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 96,
      leading: Center(
          child: TextButton(
              onPressed: () {}, child: Text(_formattedDate(context), style: Theme.of(context).textTheme.bodyText1))),
      title: Text(_title),
    );
  }

  Widget _buildBillsView(BuildContext context) {
    final bloc = context.read<BillsBloc>();
    print("bills bloc: ${bloc.hashCode}, ${context.hashCode}");
    if (bloc.state.isInitial) {
      bloc.getFirstPageBills();
    }
    return BlocBuilder<BillsBloc, BaseBlocState>(builder: (context, state) {
      final bills = state.getData<List<Bill>>() ?? List.empty();
      return ListView.separated(
        itemCount: bills.length,
        itemBuilder: (context, index) => _billItem(bills, context, index),
        separatorBuilder: (context, index) => _separatedItem(bills, context, index),
      );
    });
  }

  Widget _billItem(List<Bill> bills, BuildContext context, int index) {
    final bill = bills[index];
    var themeData = Theme.of(context);
    if (bill is CompositionBill) {
      return _buildDayBillView(bill, context);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.category?.name ?? "", style: themeData.textTheme.subtitle1),
                Text(bill.account?.name ?? "", style: themeData.textTheme.caption)
              ],
            ),
          ),
          SizedBox(width: 24),
          Text(bill.remark, style: themeData.textTheme.caption),
          Spacer(),
          Text(
            "${bill.readableAmount}",
            style: themeData.textTheme.bodyText1?.copyWith(color: Colors.red[300]),
          )
        ],
      ),
    );
  }

  Widget _separatedItem(List<Bill> bills, BuildContext context, int index) {
    final bill = bills[index];
    if (bill is CompositionBill) {
      return const Divider(indent: 16);
    }
    return Container();
  }

  bool _isNotSameDay(Bill bill, Bill preBill) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(bill.billDate);
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;
    final preDateTime = DateTime.fromMillisecondsSinceEpoch(preBill.billDate);
    final preYear = preDateTime.year;
    final preMonth = preDateTime.month;
    final preDay = preDateTime.day;
    if (year != preYear) return true;
    if (month != preMonth) return true;
    if (day != preDay) return true;
    return false;
  }

  Widget _buildDayBillView(CompositionBill bill, BuildContext context) {
    var themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(text: bill.getDay() + "日\n", style: themeData.textTheme.headline6, children: <TextSpan>[
            TextSpan(text: bill.getFmtDate(languageCode(context)), style: themeData.textTheme.bodyText1)
          ])),
          Text(
            "总支出：${bill.expenseAmount / 100.0}",
            style: themeData.textTheme.bodyText1?.copyWith(color: Colors.green[300]),
          ),
          Text(
            "总收入：${bill.earningAmount / 100.0}",
            style: themeData.textTheme.bodyText1?.copyWith(color: Colors.red[300]),
          )
        ],
      ),
    );
  }
}
