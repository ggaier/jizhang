import 'dart:async';
import 'package:accountbook/add_bill/add_bill_bloc.dart';
import 'package:accountbook/bill_category/bill_categories_repo.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bill_category_event.dart';

class BillCategoryBloc extends Bloc<BillCategoryEvent, BaseBlocState> {
  final BillCategoriesRepoIn _billsRepositoryIn;

  BillCategoryBloc(this._billsRepositoryIn) : super(ABInitialState());

  @override
  Stream<BaseBlocState> mapEventToState(BillCategoryEvent event) async* {
    if (event is BillCategoryLoadedEvent) {
      yield* _mapBillCategoryLoadedToState();
    } else if (event is BillCategorySelectedEvent) {
      yield* _mapBillCategorySelectedToState(event);
    }
  }

  Stream<BaseBlocState> _mapBillCategoryLoadedToState() async* {
    try {
      final categories = await _billsRepositoryIn.getAllBillCategory();
      yield ABSuccessState(categories);
    } on Exception catch (e) {
      yield ABFailureState(e);
    }
  }

  Stream<BaseBlocState> _mapBillCategorySelectedToState(BillCategorySelectedEvent event) async* {
    try {
      yield ABSuccessState([event.category]);
    } on Exception catch (e) {
      yield ABFailureState(e);
    }
  }
}
