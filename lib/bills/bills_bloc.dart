import 'package:accountbook/bills/bills_bloc_event.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillsBloc extends Bloc<BillsBlocEvent, BaseBlocState> {

  final BillsRepositoryIn _billsRepositoryIn;

  BillsBloc(this._billsRepositoryIn) : super(ABInitialState());

  void getFirstPageBills() async {
    // final bills = await _billsRepositoryIn.getBillsByPage(1);
    // emit(bills);
  }

  void addNewBill(Bill bill) {
    // var newState = state..insert(0, bill);
    // emit(newState);
  }

  @override
  Stream<BaseBlocState> mapEventToState(BillsBlocEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
