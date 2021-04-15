part of 'bill_category_bloc.dart';

@immutable
abstract class BillCategoryEvent {}

class BillCategoryLoadedEvent extends BillCategoryEvent{}

class BillCategorySelectedEvent extends BillCategoryEvent{
  final BillCategory category;
  BillCategorySelectedEvent(this.category);
}
