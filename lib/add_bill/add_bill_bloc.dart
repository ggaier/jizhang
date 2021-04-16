import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBillBloc extends Cubit<Bill> {
  AddBillBloc(this._billsRepositoryIn) : super(Bill.empty());

  final BillsRepositoryIn _billsRepositoryIn;

  void setBillDate(int date) {
    emit(state.copyWith(billDate: date));
  }

  void setBillTime(TimeOfDay time) {
    emit(state.copyWith(billTime: time.hour * 60 + time.minute));
  }

  void setBillType(BillType billType) {
    emit(state.copyWith(billType: billType));
  }

  void setBillAmount(double amount) {
    emit(state.copyWith(amount: (amount *= 100).toInt()));
  }

  void setBillAccount(PayAccount account){
    emit(state.copyWith(account: account));
  }

  void setBillCategory(BillCategory category){
    emit(state.copyWith(genre: category));
  }

  @override
  void onChange(Change<Bill> change) {
    super.onChange(change);
    print("onChange: $change");
  }
}
