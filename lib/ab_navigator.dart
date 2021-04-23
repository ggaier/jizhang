import 'package:accountbook/add_bill/add_bill_view.dart';
import 'package:accountbook/app_route_path.dart';
import 'package:accountbook/bill_category/bill_categories_repo.dart';
import 'package:accountbook/bill_category/bill_category_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/screen/home_screen.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import 'add_bill/add_bill_bloc.dart';
import 'bill_accounts/bill_accounts_bloc.dart';
import 'bill_accounts/bill_accounts_repo.dart';
import 'bills/bills_bloc.dart';
import 'bills/bills_view.dart';

class ABRouteDelegate extends RouterDelegate<ABRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ABRoutePath> {
  ABRoutePath _currentRoutePath = ABRoutePath.home();
  final _navigatorKey = GlobalKey<NavigatorState>();
  Bill? _onClickedBill;

  @override
  ABRoutePath? get currentConfiguration => _currentRoutePath;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        MaterialPage(
          child: HomeScreen(
            onTapped: (value) => _handleOnBillClicked(context, value),
            onActionBtnClick: (value) => _handleHomeActionClick(context, value),
          ),
          key: ValueKey('HomeScreen'),
        ),
        if (_currentRoutePath.isUnknown)
          _unknownMaterialPage()
        else if (_currentRoutePath.isAddBill)
          _addBillMaterialPage(context)
        else if (_currentRoutePath.isPayments)
          _paymentsMaterialPage()
        else if (_currentRoutePath.isCategories)
          _categoriesMaterialPage()
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _currentRoutePath = ABRoutePath.home();
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ABRoutePath configuration) async {
    //
  }

  void _handleOnBillClicked(BuildContext context, Bill? bill) {
    _onClickedBill = bill;
    _currentRoutePath = ABRoutePath.add();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  _handleHomeActionClick(BuildContext context, int value) {
    if (value == HomeScreen.ACTION_BILL_CATEGORY) {
      _currentRoutePath = ABRoutePath.categories();
    } else if (value == HomeScreen.ACTION_PAY_ACCOUNT) {
      _currentRoutePath = ABRoutePath.payments();
    }
    notifyListeners();
  }

  MaterialPage _unknownMaterialPage() =>
      MaterialPage(key: ValueKey("UnknownPage"), child: Center(child: Text("404 not found")));

  MaterialPage _addBillMaterialPage(BuildContext context) {
    return MaterialPage(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AddBillBloc(RepositoryProvider.of<BillsRepositoryImpl>(context))),
            BlocProvider(
              create: (context) => BillAccountsBloc(accountsRepoIn: RepositoryProvider.of<AccountsRepoImpl>(context)),
            ),
            BlocProvider(
              create: (context) => BillCategoryBloc(RepositoryProvider.of<BillCategoriesRepoImpl>(context)),
            )
          ],
          child: AddBillView(
              onAddBill: (billTuple) {
                final bloc = context.read<BillsBloc>();
                if (!billTuple.item2) {
                  bloc.addNewBill(billTuple.item1);
                } else {
                  bloc.updateExistBill(billTuple.item1);
                }
              },
              updatingBill: _onClickedBill),
        ),
        key: ValueKey("AddBill"));
  }

  MaterialPage _paymentsMaterialPage() {
    return MaterialPage(child: Text("查看和编辑支付账户"));
  }

  MaterialPage _categoriesMaterialPage() {
    return MaterialPage(child: Text("查看和编辑账单类型"));
  }
}
