import 'package:accountbook/bills/bills_bloc_event.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillsBloc extends Bloc<BillsBlocEvent, BaseBlocState> {
  final BillsRepositoryIn _billsRepositoryIn;

  BillsBloc(this._billsRepositoryIn) : super(ABInitialState());

  void getFirstPageBills() {
    add(BillsLoadedEvent());
  }

  void addNewBill(Bill bill) {
    print("add new bill: ${bill.toJson()}");
    add(BillAddedEvent(bill));
  }

  @override
  Stream<BaseBlocState> mapEventToState(BillsBlocEvent event) async* {
    if (event is BillsLoadedEvent) {
      yield* _mapBillsLoadedEventToState();
    } else if (event is BillAddedEvent) {
      yield* _mapBillAddedEventToState(event);
    }
  }

  Stream<BaseBlocState> _mapBillsLoadedEventToState() async* {
    try {
      final bills = await _billsRepositoryIn.getBillsByPage(1);
      yield ABSuccessState(bills);
    } on Exception catch (e) {
      print(e);
      yield ABFailureState(e);
    }
  }

  Stream<BaseBlocState> _mapBillAddedEventToState(BillAddedEvent event) async* {
    try {
      print("state: ${state.runtimeType}");
      if (state is ABSuccessState) {
        yield ABSuccessState(state.getData<List<Bill>>()?..insert(0, event.addedBill));
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
