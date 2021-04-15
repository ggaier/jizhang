import 'dart:async';

import 'package:accountbook/accounts/bill_accounts_repo.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'account_entity.dart';

part 'bill_accounts_event.dart';

class BillAccountsBloc extends Bloc<BillAccountsEvent, BaseBlocState> {
  final AccountsRepoIn accountsRepoIn;

  BillAccountsBloc({required this.accountsRepoIn}) : super(ABInitialState());

  @override
  Stream<BaseBlocState> mapEventToState(
    BillAccountsEvent event,
  ) async* {
    if (event is AccountsLoadedEvent) {
      yield* _mapLoadedEventToState();
    } else if (event is SetAccountEvent) {
      yield* _mapSetAccountToState(event);
    }
  }

  Stream<BaseBlocState> _mapLoadedEventToState() async* {
    try {
      final accounts = await accountsRepoIn.getAllAccounts();
      yield ABSuccessState(accounts);
    } catch (e) {
      yield ABFailureState();
    }
  }

  Stream<BaseBlocState> _mapSetAccountToState(SetAccountEvent event) async* {
    try {
      yield ABSuccessState([event.account]);
    } catch (e) {
      yield ABFailureState();
    }
  }
}
