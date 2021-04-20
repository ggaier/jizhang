import 'package:accountbook/vo/bill.dart';
import 'package:floor/floor.dart';

class BillTypeConvert extends TypeConverter<BillType, int> {
  @override
  BillType decode(int databaseValue) {
    BillType? billType;
    if (databaseValue == BillType.expense.index) {
      billType = BillType.expense;
    } else if (databaseValue == BillType.earning.index) {
      billType = BillType.earning;
    } else if (databaseValue == BillType.transfer.index) {
      billType = BillType.transfer;
    } else if (databaseValue == BillType.summary.index) {
      billType = BillType.summary;
    }
    return billType ?? BillType.expense;
  }

  @override
  int encode(BillType value) {
    return value.index;
  }
}
