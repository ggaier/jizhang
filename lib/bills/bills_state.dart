import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/bill.dart';

/*
更新当前显示的账单列别
 */
class BillsSwapState extends ABSuccessState<List<Bill>> {
  final Bill? updatedBill;

  BillsSwapState({this.updatedBill, List<Bill>? bills}) :super(bills);
}