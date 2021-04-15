import 'package:accountbook/accounts/bill_accounts_bloc.dart';
import 'package:accountbook/accounts/bill_accounts_repo.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_entity.dart';

class BillAccountSelectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BillAccountState();
  }
}

class _BillAccountState extends State {
  final TextEditingController _billAccountTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<BillAccountsBloc>();
    print("init state: ${bloc.state}");
    return BlocBuilder<BillAccountsBloc, BaseBlocState>(
      builder: (context, state) {
        print("state: $state");
        final accounts = state.getData<List<Account>>();
        final selectedAccount = accounts?.first;
        var accountName = selectedAccount?.name;
        if (accountName != null) {
          _billAccountTEC.text = accountName;
        }
        print("name: $accountName");
        return Row(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text("账户")),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(hintText: "请选择您的付款账户"),
                readOnly: true,
                controller: _billAccountTEC ,
                onTap: () => _showAccountsDialog(context),
              ),
            )
          ],
        );
      },
    );
  }

  _showAccountsDialog(BuildContext context) async {
    final accountBloc = context.read<BillAccountsBloc>();
    final selectedAccount = await showModalBottomSheet<Account>(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => BillAccountsBloc(accountsRepoIn: RepositoryProvider.of<AccountsRepoImpl>(context)),
          child: BlocBuilder<BillAccountsBloc, BaseBlocState>(
            builder: (context, state) {
              final bloc = context.read<BillAccountsBloc>();
              if (bloc.state.isInitial) {
                bloc.add(AccountsLoadedEvent());
                return Container();
              }
              final accounts = state.getData<List<Account>>();
              if (accounts == null || accounts.isEmpty) {
                Navigator.pop(context);
                return Container();
              }
              return Column(
                children: [
                  AppBar(automaticallyImplyLeading: true, title: Text("账户")),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var account = accounts[index];
                      return TextButton(onPressed: () => Navigator.pop(context, account), child: Text(account.name));
                    },
                    itemCount: accounts.length,
                  )
                ],
              );
            },
          ),
        );
      },
    );
    if (selectedAccount != null) {
      accountBloc.add(SetAccountEvent(selectedAccount));
    }
  }
}
