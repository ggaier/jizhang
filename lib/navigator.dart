import 'package:accountbook/accounts/bill_accounts_bloc.dart';
import 'package:accountbook/accounts/bill_accounts_repo.dart';
import 'package:accountbook/add_bill/add_bill_view.dart';
import 'package:accountbook/app_route_path.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_bill/add_bill_bloc.dart';
import 'bills/bills_view.dart';

class ABRouteDelegate extends RouterDelegate<ABRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ABRoutePath> {
  ABRoutePath? _currentRoutePath;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  ABRoutePath? get currentConfiguration => _currentRoutePath ?? ABRoutePath.home();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        MaterialPage(child: BillsView(title: "", onTapped: _handleOnAddBillClicked), key: ValueKey("BillsView")),
        if (_currentRoutePath?.isUnknown == true)
          MaterialPage(key: ValueKey("UnknownPage"), child: Center(child: Text("404 not found")))
        else if (_currentRoutePath?.isAddBill == true)
          MaterialPage(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => AddBillBloc(RepositoryProvider.of<BillsRepositoryImpl>(context))),
                  BlocProvider(
                    create: (context) =>
                        BillAccountsBloc(accountsRepoIn: RepositoryProvider.of<AccountsRepoImpl>(context)),
                  ),
                ],
                child: AddBillView(),
              ),
              key: ValueKey("AddBill"))
      ],
      onPopPage: (route, result) {
        print("onPopPage: $route, result: $result");
        if (!route.didPop(result)) {
          return false;
        }
        _currentRoutePath = null;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ABRoutePath configuration) async {
    //
  }

  void _handleOnAddBillClicked() {
    _currentRoutePath = ABRoutePath.add();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
