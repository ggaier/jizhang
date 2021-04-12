import 'package:intl/intl.dart';

enum BillType { earning, expense, summary }

class Bill {
  int id;
  int billTime;
  String account;
  String genre;
  int amount;
  String currencySymbol;
  String remark;
  BillType billType;

  Bill.name(
      this.id, this.billTime, this.account, this.genre, this.amount, this.currencySymbol, this.remark, this.billType);
}

class DayBill extends Bill {
  int earningAmount;
  int expenseAmount;

  DayBill.name(int id, int billTime, String account, String genre, int amount, String currencySymbol, String remark,
      int earningAmount, int expenseAmount)
      : this.earningAmount = earningAmount,
        this.expenseAmount = expenseAmount,
        super.name(id, billTime, account, genre, amount, currencySymbol, remark, BillType.summary);

  String getFmtDate(String languageCode) {
    final df = DateFormat.yMMM(languageCode);
    return df.format(DateTime.fromMillisecondsSinceEpoch(billTime));
  }

  String getDay(){
    return DateTime.fromMillisecondsSinceEpoch(billTime).day.toString();
  }
}
