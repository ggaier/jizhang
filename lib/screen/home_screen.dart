import 'package:accountbook/bills/bills_view.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  static const ACTION_PAY_ACCOUNT = 0;
  static const ACTION_BILL_CATEGORY = 1;
  final DateTime? _date = DateTime.now().toLocal();
  final ValueChanged<Bill?> _onTapped;
  final ValueChanged<int> _onActionBtnClicked;

  HomeScreen({required ValueChanged<Bill?> onTapped, required ValueChanged<int> onActionBtnClick})
      : this._onTapped = onTapped,
        this._onActionBtnClicked = onActionBtnClick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BillsView(onTapped: _onTapped),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onTapped(null),
        tooltip: '添加账单',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      leadingWidth: 96,
      leading: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(_formattedDate(context), style: Theme.of(context).textTheme.bodyText1),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.account_balance),
          splashRadius: 24,
          tooltip: "支付账户",
          onPressed: () => _onActionBtnClicked(ACTION_PAY_ACCOUNT),
        ),
        IconButton(
          icon: Icon(Icons.category),
          splashRadius: 24,
          tooltip: "账单类别",
          onPressed: () => _onActionBtnClicked(ACTION_BILL_CATEGORY),
        ),
      ],
    );
  }

  String _formattedDate(BuildContext context) {
    var languageCode2 = languageCode(context);
    print("languageCode2: $languageCode2");
    final df = DateFormat.yMMM(languageCode2);
    return df.format(_date ?? DateTime.now());
  }

  String languageCode(BuildContext context) => Localizations.localeOf(context).languageCode;
}
