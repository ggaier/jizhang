import 'package:accountbook/bills/bills_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BillsView extends StatelessWidget {
  final String _title;
  final DateTime? _date = DateTime.now().toLocal();

  BillsView({required String title}) : _title = title;

  String _formattedDate(BuildContext context) {
    final df = DateFormat.yMMM(Localizations.localeOf(context).languageCode);
    return df.format(_date ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = BillsBloc(RepositoryProvider.of<BillsRepositoryImpl>(context));
        bloc.getFirstPageBills();
        return bloc;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBillsView(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leadingWidth: 96,
      leading: Center(
          child: TextButton(
              onPressed: () {}, child: Text(_formattedDate(context), style: Theme.of(context).textTheme.bodyText1))),
      title: Text(_title),
    );
  }

  Widget _buildBillsView(BuildContext context) {
    return BlocBuilder<BillsBloc, List<Bill>>(builder: (context, state) {
      final bills = state;
      return ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  bill.account,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "${bill.amount.toString()}${bill.currencySymbol}",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.red),
                ),
                Text(bill.genre, style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black38))
              ],
            ),
          );
        },
      );
    });
  }
}
