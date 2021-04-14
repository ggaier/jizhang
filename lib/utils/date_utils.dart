import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {

  String fmtDateForAddBill({String? locale}) {
    final dateFormat = DateFormat("yyyy/MM/dd (EEE)", locale);
    return dateFormat.format(this);
  }

  String fmtTimeForAddBill({String? locale}){
    return DateFormat("HH:mm", locale).format(this);
  }
}
