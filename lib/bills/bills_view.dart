import 'dart:ffi';

import 'package:accountbook/bills/bills_bloc.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class BillsView extends StatefulWidget {
  final String _title;
  final DateTime? _date = DateTime.now().toLocal();
  final VoidCallback _onTapped;

  BillsView({required String title, required VoidCallback onTapped})
      : _title = title,
        _onTapped = onTapped;

  @override
  State<StatefulWidget> createState() {
    return _BillsViewState();
  }
}

class _BillsViewState extends State<BillsView> {
  static const _pageSize = 20;
  final PagingController<int, Bill> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      final bloc = context.read<BillsBloc>();
      bloc.getPagedBills(pageKey);
    });
    super.initState();
  }

  String _formattedDate(BuildContext context) {
    final df = DateFormat.yMMM(languageCode(context));
    return df.format(widget._date ?? DateTime.now());
  }

  String languageCode(BuildContext context) => Localizations.localeOf(context).languageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBillsView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: widget._onTapped,
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
      title: Text(widget._title),
    );
  }

  Widget _buildBillsView(BuildContext context) {
    return BlocListener<BillsBloc, BaseBlocState>(
      listener: (context, state) {
        final bills = state.getData<List<Bill>>();
        if (bills == null) return;
        if (bills.length < _pageSize) {
          _pagingController.appendLastPage(bills);
        } else {
          final nextPage = ((_pagingController.value.itemList?.length ?? 0 + bills.length) ~/ _pageSize) + 1;
          _pagingController.appendPage(bills, nextPage);
        }
      },
      child: PagedListView.separated(
        pagingController: _pagingController,
        separatorBuilder: (context, index) => _separatedItem(context, index),
        builderDelegate: PagedChildBuilderDelegate<Bill>(
          itemBuilder: (context, item, index) => _billItem(item, context, index),
        ),
      ),
    );
  }

  Widget _billItem(Bill bill, BuildContext context, int index) {
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

  Widget _separatedItem(BuildContext context, int index) {
    final bill = _pagingController.value.itemList?.elementAt(index);
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
