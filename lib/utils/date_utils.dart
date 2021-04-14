import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  String fmtDateForAddBill({String? locale}) {
    final dateFormat = DateFormat("yyyy/MM/dd (EEE)", locale);
    return dateFormat.format(this);
  }

  String fmtTimeForAddBill({String? locale}) {
    return DateFormat("HH:mm", locale).format(this);
  }
}

int minsOfTheDay() {
  var timeOfDay = TimeOfDay.now();
  return timeOfDay.hour * 60 + timeOfDay.minute;
}

