import 'package:accountbook/db/bill_type_convert.dart';
import 'package:accountbook/utils/date_utils.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

enum BillType { earning, expense, summary, transfer }

@JsonSerializable()
@TypeConverters([BillTypeConvert])
@Entity(tableName: Bill.TABLE_NAME)
class Bill {
  static const TABLE_NAME = "Bill";
  static const String COLUMN_ACCOUNT_ID = "account_id";
  static const String COLUMN_CATEGORY_ID = "category_id";

  @ColumnInfo(name: COLUMN_ACCOUNT_ID)
  final int accountId;

  @ColumnInfo(name: COLUMN_CATEGORY_ID)
  final int categoryId;

  @PrimaryKey(autoGenerate: true)
  final int id;

  //日期 in ms
  final int billDate;

  //时间 in min
  final int billTime;
  final int amount;
  final String currencySymbol;
  final String remark;
  final BillType billType;
  @ignore
  PayAccount? account;
  @ignore
  BillCategory? category;

  Bill(this.accountId, this.categoryId, this.id, this.billDate, this.billTime, this.amount, this.currencySymbol,
      this.remark, this.billType);

  Bill copyWith(
      {int? accountId,
      int? categoryId,
      int? id,
      int? billDate,
      int? billTime,
      int? amount,
      String? currencySymbol,
      String? remark,
      BillType? billType,
      PayAccount? account,
      BillCategory? category}) {
    return Bill(
        accountId ?? this.accountId,
        categoryId ?? this.categoryId,
        id ?? this.id,
        billDate ?? this.billDate,
        billTime ?? this.billTime,
        amount ?? this.amount,
        currencySymbol ?? this.currencySymbol,
        remark ?? this.remark,
        billType ?? this.billType)
      ..account = account ?? this.account
      ..category = category ?? this.category;
  }

  Bill.empty()
      : this.id = 0,
        this.categoryId = 0,
        this.accountId = 0,
        this.billDate = DateTime.now().millisecondsSinceEpoch,
        this.billTime = minsOfTheDay(),
        this.amount = 0,
        this.currencySymbol = "",
        this.remark = "",
        this.billType = BillType.expense;

  @ignore
  TimeOfDay get billTimeOfTheDay {
    return TimeOfDay(hour: billTime ~/ 60, minute: billTime % 60);
  }

  @ignore
  DateTime get billDateDateTime {
    return DateTime.fromMillisecondsSinceEpoch(billDate);
  }

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);
}

class CompositionBill extends Bill {
  final List<Bill> billsOfTheDay;

  CompositionBill(this.billsOfTheDay) : super(0, 0, 0, 0, 0, 0, '', '', BillType.summary);

  int get earningAmount {
    var sum = 0;
    billsOfTheDay.forEach((element) {
      sum += element.billType == BillType.earning ? element.amount : 0;
    });
    return sum;
  }

  int get expenseAmount {
    var sum = 0;
    billsOfTheDay.forEach((element) {
      sum += element.billType == BillType.expense ? element.amount : 0;
    });
    return sum;
  }

  String getFmtDate(String languageCode) {
    final bill = billsOfTheDay.first;
    final billDate = bill.billDate;
    final df = DateFormat.yMMM(languageCode);
    return df.format(DateTime.fromMillisecondsSinceEpoch(billDate));
  }

  String getDay() {
    final bill = billsOfTheDay.first;
    final billDate = bill.billDate;
    return DateTime.fromMillisecondsSinceEpoch(billDate).day.toString();
  }
}
