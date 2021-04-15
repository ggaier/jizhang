import 'package:accountbook/accounts/bill_accounts_bloc.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_entity.dart';

class BillAccountSelectorView extends StatelessWidget {
  final TextEditingController _billAccountTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<BillAccountsBloc>();
    print("init state: ${bloc.state}");
    if (bloc.state.isInitial) {
      bloc.add(AccountsLoadedEvent());
    }
    return BlocBuilder<BillAccountsBloc, BaseBlocState>(
      builder: (context, state) {
        print("state: $state");
        if (!state.isSuccess) {
          return Container();
        }
        final accounts = state.getData<List<Account>>();
        final selectedAccount = accounts?.first;
        _billAccountTEC.text = selectedAccount?.name ?? "";
        return Row(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text("账户")),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(hintText: "请选择您的付款账户"),
                readOnly: true,
                controller: _billAccountTEC,
                onTap: () => _showAccountsDialog(context, accounts),
              ),
            )
          ],
        );
      },
    );
  }

  _showAccountsDialog(BuildContext context, List<Account>? accounts) async {
    print("showAccountsDialog: ${accounts?.length}");
    if (accounts == null || accounts.isEmpty) return;
    final bloc = context.read<BillAccountsBloc>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            AppBar(automaticallyImplyLeading: true, title: Text("账户")),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var account = accounts[index];
                return TextButton(
                    onPressed: () {
                      bloc.add(SetAccountEvent(account));
                      Navigator.pop(context);
                    },
                    child: Text(account.name));
              },
              itemCount: accounts.length,
            )
          ],
        );
      },
    );
  }
}
