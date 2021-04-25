import 'package:accountbook/bills/bills_bloc_event.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:accountbook/vo/bill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillsBloc extends Bloc<BillsBlocEvent, BaseBlocState> {
  final BillsRepositoryIn _billsRepositoryIn;
  int _startDate = 0;
  int _endDate = 0;

  BillsBloc(this._billsRepositoryIn) : super(ABInitialState());

  void addNewBill(Bill bill) {
    print("addNewBill: ${bill.toJson()}");
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
      _startDate = event.startDate;
      _endDate = event.endDate;
      final bills = await _billsRepositoryIn.getBillsByDateRange(event.startDate, event.endDate);
      yield ABSuccessState(bills);
    } on Exception catch (e) {
      print(e);
      yield ABFailureState(e);
    }
  }

  Stream<BaseBlocState> _mapBillAddedEventToState(BillAddedEvent event) async* {
    try {
      print("mapAddBillEventToState");
      if (state is ABSuccessState) {
        var data = state.getData<List<Bill>>() ?? List.empty(growable: true);
        if (data.isEmpty || data.first.yyyyMMdd != event.addedBill.yyyyMMdd) {
          data.insert(0, CompositionBill([event.addedBill]));
          yield ABSuccessState(data..insert(1, event.addedBill));
        } else {
          if (data.first is CompositionBill) {
            (data.first as CompositionBill).addBill(ofTheDay: event.addedBill);
            yield ABSuccessState(data..insert(1, event.addedBill));
          }
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Stream<BaseBlocState> _mapBillUpdateEventToState(BillUpdateEvent event) async* {
    try {
      if (state is ABSuccessState) {
        final bills = state.getData<List<Bill>>();
        if (bills == null) return;
        print("updated bill: ${event.updatedBill.toJson()}");
        final index = bills.indexWhere((element) => element.id == event.updatedBill.id);
        if (index >= 0) {
          bills
            ..removeAt(index)
            ..insert(index, event.updatedBill);
        }
        final updatedBill = event.updatedBill;
        final compositionBill = bills
            .where((element) => element is CompositionBill)
            .firstWhere((element) => element is CompositionBill && element.contains(updatedBill), orElse: null);
        print("compositionBill: $compositionBill");
        if (compositionBill is CompositionBill) {
          var billsOfTheDay = compositionBill.billsOfTheDay;
          final index = billsOfTheDay.indexWhere((element) => element.id == updatedBill.id);
          if (index >= 0) {
            final modifiedBill = billsOfTheDay[index];
            print("modifiedBill: ${modifiedBill.yyyyMMdd}, ${updatedBill.yyyyMMdd}");
            if (modifiedBill.yyyyMMdd == updatedBill.yyyyMMdd) {
              billsOfTheDay
                ..removeAt(index)
                ..insert(index, updatedBill);
              print("modifiedBillTime: ${modifiedBill.billTime}, ${updatedBill.billTime}");
              if (modifiedBill.billTime != updatedBill.billTime) {
                compositionBill.sortByBillTime();
              }
              yield ABSuccessState(bills);
            } else {
              final reloadBills = await _billsRepositoryIn.getBillsByDateRange(_startDate, _endDate);
              yield ABSuccessState(reloadBills);
            }
          }
        }
      }
    } on Exception catch (e) {}
  }
}
