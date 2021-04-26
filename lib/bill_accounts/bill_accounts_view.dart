import 'package:accountbook/add_bill/add_bill_bloc.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bill_accounts_bloc.dart';
import 'bill_accounts_repo.dart';

extension BillAccountsView on AddBillBloc {
  void showAccountsDialog(BuildContext context) async {
    final selectedAccount = await showModalBottomSheet<PayAccount>(
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
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
              final accounts = state.getData<List<PayAccount>>();
              if (accounts == null || accounts.isEmpty) {
                Navigator.pop(context);
                return Container();
              }
              return Column(
                children: [
                  AppBar(automaticallyImplyLeading: false, title: Text("账户")),
                  Flexible(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var account = accounts[index];
                        return TextButton(
                          onPressed: () => Navigator.pop(context, account),
                          child: Text(account.name, style: Theme.of(context).textTheme.bodyText1),
                        );
                      },
                      itemCount: accounts.length,
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
    if (selectedAccount != null) {
      this.setBillAccount(selectedAccount);
    }
  }
}
