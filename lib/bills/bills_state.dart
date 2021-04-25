import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/bill.dart';

/*
更新当前显示的账单列别
 */
class BillsSwapState extends ABSuccessState<List<Bill>> {
  BillsSwapState({List<Bill>? bills}) :super(bills);
}