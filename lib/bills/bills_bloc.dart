import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillsBloc extends Cubit<List<Bill>> {
  final BillsRepositoryIn _billsRepositoryIn;

  BillsBloc(this._billsRepositoryIn) : super(List.empty());

  void getFirstPageBills() async {
    final bills = await _billsRepositoryIn.getBillsByPage(1);
    emit(bills);
  }

  void addNewBill(Bill bill) {
    emit(state..add(bill));
  }
}
