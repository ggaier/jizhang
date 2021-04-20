import 'package:accountbook/db/bill_category_dao.dart';
import 'package:accountbook/vo/bill_category.dart';

abstract class BillCategoriesRepoIn {
  Future<List<BillCategory>> getAllBillCategory();
}

class BillCategoriesRepoImpl extends BillCategoriesRepoIn {
  final BillCategoryDao _categoryDao;

  BillCategoriesRepoImpl(this._categoryDao);

  List<BillCategory> _builtInCategories() {
    return [
      BillCategory(0, "食品"),
      BillCategory(1, "交通"),
      BillCategory(2, "休闲娱乐"),
      BillCategory(3, "日常用品"),
      BillCategory(4, "人情往来"),
    ];
  }

  @override
  Future<List<BillCategory>> getAllBillCategory() async {
    final categories = await _categoryDao.getAllBillCategories();
    print("categories: $categories");
    if (categories.isEmpty) {
      return await _insertBuiltInCategories();
    }
    return categories;
  }

  Future<List<BillCategory>> _insertBuiltInCategories() async {
    final builtInCategories = _builtInCategories()
      ..forEach((element) {
        _categoryDao.insertBillCategory(element);
      });
    return builtInCategories;
  }
}
