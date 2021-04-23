import 'package:accountbook/bills/bills_bloc_event.dart';
import 'package:accountbook/bills/bills_state.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillsBloc extends Bloc<BillsBlocEvent, BaseBlocState> {
  static const PAGE_SIZE = 50;
  final BillsRepositoryIn _billsRepositoryIn;

  BillsBloc(this._billsRepositoryIn) : super(ABInitialState());

  void getPagedBills(int page) {
    add(BillsLoadedEvent(page));
  }

  void addNewBill(Bill bill) {
    add(BillAddedEvent(bill));
  }

  void updateExistBill(Bill bill) {
    add(BillUpdateEvent(bill));
  }

  @override
  Stream<BaseBlocState> mapEventToState(BillsBlocEvent event) async* {
    if (event is BillsLoadedEvent) {
      yield* _mapBillsLoadedEventToState(event);
    } else if (event is BillAddedEvent) {
      yield* _mapBillAddedEventToState(event);
    } else if (event is BillUpdateEvent) {
      yield* _mapBillUpdateEventToState(event);
    }
  }

  Stream<BaseBlocState> _mapBillsLoadedEventToState(BillsLoadedEvent event) async* {
    try {
      final bills = await _billsRepositoryIn.getBillsByPage(event.page, PAGE_SIZE);
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
        yield BillsSwapState(bills: state.getData<List<Bill>>()?..insert(0, event.addedBill));
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Stream<BaseBlocState> _mapBillUpdateEventToState(BillUpdateEvent event) async* {
    try {
      if (state is ABSuccessState) {
        final bills = state.getData<List<Bill>>();
        if (bills != null) {
          final index = bills.indexWhere((element) => element.id == event.updatedBill.id);
          bills.removeAt(index);
          print("update index: $index, ${event.updatedBill.toJson()}");
          bills.insert(index, event.updatedBill);
          yield BillsSwapState(updatedBill: event.updatedBill, bills: bills);
        }
      }
    } on Exception catch (e) {}
  }
}
