import 'package:accountbook/vo/bill_category.dart';
import 'package:floor/floor.dart';

@dao
abstract class BillCategoryDao {

  @Query('SELECT * FROM BillCategory')
  Future<List<BillCategory>> getAllBillCategories();

  @Query("SELECT * FROM ${BillCategory.TABLE_NAME} WHERE id = :id")
  Future<BillCategory?> findBillCategory(int id);

  @update
  Future<int> updateBillCategory(BillCategory category);

  @insert
  Future<int> insertBillCategory(BillCategory category);

  @delete
  Future<int> deleteBillCategory(BillCategory category);
}
