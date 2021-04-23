class ABRoutePath {
  static const String PATH_HOME = "/accountbook";
  static const String PATH_SEPARATOR = "/";
  static const String PATH_ADD_BILL = "$PATH_HOME${PATH_SEPARATOR}add";
  static const String PATH_PAYMENTS = "$PATH_HOME${PATH_SEPARATOR}payments";
  static const String PATH_CATEGORIES = "$PATH_HOME${PATH_SEPARATOR}categories";

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

  factory ABRoutePath.payments() => ABRoutePath.path(PATH_PAYMENTS);
  factory ABRoutePath.categories() => ABRoutePath.path(PATH_CATEGORIES);

  bool get isAddBill => path == PATH_ADD_BILL;
  bool get isHomePage => path == PATH_HOME;
  bool get isPayments => path == PATH_PAYMENTS;
  bool get isCategories => path == PATH_CATEGORIES;

}
