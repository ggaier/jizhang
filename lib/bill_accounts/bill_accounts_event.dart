part of 'bill_accounts_bloc.dart';

@immutable
abstract class BillAccountsEvent {}

class AccountsLoadedEvent extends BillAccountsEvent{}

class SetAccountEvent extends BillAccountsEvent{
  final PayAccount account;
  SetAccountEvent(this.account);
}
