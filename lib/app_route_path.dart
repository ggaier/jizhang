class ABRoutePath {
  static const String PATH_HOME = "/accountbook";
  static const String PATH_SEPARATOR = "/";
  static const String PATH_ADD_BILL = "$PATH_HOME${PATH_SEPARATOR}add";

  final String? billId;
  final bool isUnknown;
  final String path;

  ABRoutePath.unknown()
      : billId = null,
        isUnknown = true,
        path = "";

  ABRoutePath.home()
      : billId = null,
        isUnknown = false,
        path = PATH_HOME;

  ABRoutePath.add()
      : billId = null,
        isUnknown = false,
        path = PATH_ADD_BILL;

  ABRoutePath.path(String path, {String? billId})
      : this.billId = billId,
        isUnknown = false,
        this.path = path;

  bool get isAddBill => path == PATH_ADD_BILL;

  bool get isHomePage => path == PATH_HOME;
}
