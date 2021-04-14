import 'package:accountbook/utils/date_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum BillType { earning, expense, summary, transfer }

class Bill {
  int id;

  //日期 in ms
  int billDate;

  //时间 in min
  int billTime;
  String account;
  String genre;
  int amount;
  String currencySymbol;
  String remark;
  BillType billType;

  Bill.name(this.id, this.billDate, this.billTime, this.account, this.genre, this.amount, this.currencySymbol,
      this.remark, this.billType);

  Bill.empty()
      : this.id = 0,
        this.billDate = DateTime.now().millisecondsSinceEpoch,
        this.billTime = minsOfTheDay(),
        this.account = "",
        this.genre = "",
        this.amount = 0,
        this.currencySymbol = "",
        this.remark = "",
        this.billType = BillType.expense;

  Bill copyWith({
    int? id,
    int? billDate,
    int? billTime,
    String? account,
    String? genre,
    int? amount,
    String? currencySymbol,
    String? remark,
    BillType? billType,
  }) {
    return Bill.name(
      id ?? this.id,
      billDate ?? this.billDate,
      billTime ?? this.billTime,
      account ?? this.account,
      genre ?? this.genre,
      amount ?? this.amount,
      currencySymbol ?? this.currencySymbol,
      remark ?? this.remark,
      billType ?? this.billType,
    );
  }

  TimeOfDay get billTimeOfTheDay {
    return TimeOfDay(hour: billTime ~/ 60, minute: billTime % 60);
  }

  DateTime get billDateDateTime {
    return DateTime.fromMillisecondsSinceEpoch(billDate);
  }
}

class DayBill extends Bill {
  int earningAmount;
  int expenseAmount;

  DayBill.name(int id, int billDate, String account, String genre, int amount, String currencySymbol, String remark,
      int earningAmount, int expenseAmount)
      : this.earningAmount = earningAmount,
        this.expenseAmount = expenseAmount,
        super.name(id, billDate, 0, account, genre, amount, currencySymbol, remark, BillType.summary);

  String getFmtDate(String languageCode) {
    final df = DateFormat.yMMM(languageCode);
    return df.format(DateTime.fromMillisecondsSinceEpoch(billDate));
  }

  String getDay() {
    return DateTime.fromMillisecondsSinceEpoch(billDate).day.toString();
  }
}
