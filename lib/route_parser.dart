import 'package:accountbook/app_route_path.dart';
import 'package:flutter/cupertino.dart';

class ABRouteInfoParser extends RouteInformationParser<ABRoutePath> {
  @override
  Future<ABRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final location = routeInformation.location ?? "";
    Uri? uri;
    try {
      uri = Uri.parse(location);
    } on FormatException {
      return ABRoutePath.unknown();
    }
    if (uri.pathSegments.length == 0) {
      return ABRoutePath.home();
    }
    if (uri.pathSegments.length == 3) {
      final billId = uri.pathSegments.last;
      return ABRoutePath.path(uri.path, billId: billId);
    }
    if (uri.pathSegments.length == 2) {
      return ABRoutePath.path(uri.path);
    }
    return ABRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(ABRoutePath configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(location: "/404");
    }
    if (configuration.isHomePage) {
      return RouteInformation(location: "/");
    }
    if (configuration.isAddBill) {
      return RouteInformation(location: ABRoutePath.PATH_ADD_BILL);
    }
    return super.restoreRouteInformation(configuration);
  }
}
