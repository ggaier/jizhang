import 'package:accountbook/bills/bills_bloc.dart';
import 'package:accountbook/bills/bills_state.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:accountbook/utils/bill_ext.dart';

class BillsView extends StatefulWidget {
  final ValueChanged<Bill?> _onTapped;

  BillsView({required ValueChanged<Bill?> onTapped}) : _onTapped = onTapped;

  @override
  State<StatefulWidget> createState() {
    return _BillsViewState();
  }
}

class _BillsViewState extends State<BillsView> {
  static const _pageSize = BillsBloc.PAGE_SIZE;
  final PagingController<int, Bill> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      print("page key: $pageKey");
      final bloc = context.read<BillsBloc>();
      bloc.getPagedBills(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBillsView(context);
  }

  Widget _buildBillsView(BuildContext context) {
    return BlocListener<BillsBloc, BaseBlocState>(
      listener: (context, state) {
        final bills = state.getData<List<Bill>>();
        if (state is BillUpdatedSuccessState) {
          final compositionBill = bills
              ?.where((element) => element is CompositionBill)
              .firstWhere((element) => element is CompositionBill && element.contains(state.updatedBill), orElse: null);
          if (compositionBill is CompositionBill) {
            var billsOfTheDay = compositionBill.billsOfTheDay;
            final index = billsOfTheDay.indexWhere((element) => element.id == state.updatedBill.id);
            billsOfTheDay
              ..removeAt(index)
              ..insert(index, state.updatedBill);
          }
          _pagingController.itemList = bills;
        } else {
          if (bills == null) return;
          if (bills.length < _pageSize) {
            _pagingController.appendLastPage(bills);
          } else {
            final currentLength = _pagingController.value.itemList?.length ?? 0;
            final newLength = bills.length;
            final nextPage = ((currentLength + newLength) ~/ _pageSize) + 1;
            _pagingController.appendPage(bills, nextPage);
          }
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
    return InkWell(
      onTap: () => widget._onTapped(bill),
      child: Padding(
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
              style: themeData.textTheme.bodyText1?.copyWith(color: bill.billAmountColor),
            )
          ],
        ),
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

  String languageCode(BuildContext context) => Localizations.localeOf(context).languageCode;

  Widget _buildDayBillView(CompositionBill bill, BuildContext context) {
    print("bill total expense: ${bill.expenseAmount / 100}, ${bill.earningAmount / 100}");
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
