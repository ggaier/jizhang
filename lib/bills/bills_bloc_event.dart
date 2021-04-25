import 'package:accountbook/vo/bill.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BillsBlocEvent {}

class BillsLoadedEvent extends BillsBlocEvent {
  final int startDate;
  final int endDate;

  BillsLoadedEvent(this.startDate, this.endDate);
}

class BillAddedEvent extends BillsBlocEvent {
  final Bill addedBill;

  BillAddedEvent(this.addedBill);
}

class BillUpdateEvent extends BillsBlocEvent {
  final Bill updatedBill;

  BillUpdateEvent(this.updatedBill);
}
