import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBillBloc extends Cubit<BaseBlocState> {
  AddBillBloc(this._billsRepositoryIn) : super(ABInitialState());

  final BillsRepositoryIn _billsRepositoryIn;

  Bill get stateBill {
    var bill = state.getData<Bill>();
    if (bill == null) {
      bill = Bill.empty();
      emit(ABSuccessState(bill));
    }
    return bill;
  }

  void setInitBill(Bill bill){
    emit(ABSuccessState(bill));
  }

  void setBillDate(int date) {
    if (state is ABSuccessState) {
      emit(ABSuccessState(stateBill.copyWith(billDate: date)));
    }
  }

  void setBillTime(TimeOfDay time) {
    emit(ABSuccessState(stateBill.copyWith(billTime: time.hour * 60 + time.minute)));
  }

  void setBillType(BillType billType) {
    emit(ABSuccessState(stateBill.copyWith(billType: billType)));
  }

  void setBillAmount(double amount) {
    emit(ABSuccessState(stateBill.copyWith(amount: (amount *= 100).toInt())));
  }

  void setBillAccount(PayAccount account) {
    emit(ABSuccessState(stateBill.copyWith(accountId: account.id, account: account)));
  }

  void setBillCategory(BillCategory category) {
    emit(ABSuccessState(stateBill.copyWith(categoryId: category.id, category: category)));
  }

  void setBillRemark(String remark) {
    emit(ABSuccessState(stateBill.copyWith(remark: remark)));
  }

  void saveBill() async {
    await _billsRepositoryIn.saveBill(stateBill);
    emit(ABCompleteState());
  }
}
