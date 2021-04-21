import 'package:accountbook/vo/bill.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BillsBlocEvent {}

class BillsLoadedEvent extends BillsBlocEvent {}

class BillAddedEvent extends BillsBlocEvent {
  final Bill addedBill;
  BillAddedEvent(this.addedBill);
}
