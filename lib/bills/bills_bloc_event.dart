import 'package:accountbook/vo/bill.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BillsBlocEvent {}

class BillsLoadedEvent extends BillsBlocEvent {
  final int page;

  BillsLoadedEvent(this.page);
}

class BillAddedEvent extends BillsBlocEvent {
  final Bill addedBill;

  BillAddedEvent(this.addedBill);
}

class BillUpdateEvent extends BillsBlocEvent {
  final Bill updatedBill;

  BillUpdateEvent(this.updatedBill);
}
