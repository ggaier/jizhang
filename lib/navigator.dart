import 'package:accountbook/add_bill/add_bill_view.dart';
import 'package:accountbook/app_route_path.dart';
import 'package:flutter/material.dart';

import 'bills/bills_view.dart';

class ABRouteDelegate extends RouterDelegate<ABRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ABRoutePath> {
  ABRoutePath? _currentRoutePath;

  @override
  ABRoutePath? get currentConfiguration => _currentRoutePath ?? ABRoutePath.home();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
            child: BillsView(
              title: "",
              onTapped: _handleOnAddBillClicked,
            ),
            key: ValueKey("BillsView")),
        if (_currentRoutePath?.isUnknown == true)
          MaterialPage(key: ValueKey("UnknownPage"), child: Center(child: Text("404 not found")))
        else if (_currentRoutePath?.isAddBill == true)
          MaterialPage(child: AddBillView(), key: ValueKey("AddBill"))
      ],
      onPopPage: (route, result) {
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

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
