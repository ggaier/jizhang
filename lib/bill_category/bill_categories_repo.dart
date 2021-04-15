import 'package:accountbook/vo/bill_category.dart';

abstract class BillCategoriesRepoIn {
  Future<List<BillCategory>> getAllBillCategory();
}

class BillCategoriesRepoImpl extends BillCategoriesRepoIn {
  @override
  Future<List<BillCategory>> getAllBillCategory() async {
    return Future.delayed(Duration(milliseconds: 200), () {
      return List.generate(20, (index) => BillCategory("账单分类$index"));
    });
  }
}
