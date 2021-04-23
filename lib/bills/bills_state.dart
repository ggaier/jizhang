import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/bill.dart';

class BillUpdatedSuccessState extends ABSuccessState<List<Bill>> {
  final Bill updatedBill;

  BillUpdatedSuccessState(this.updatedBill, [List<Bill>? bills]) :super(bills);
}
