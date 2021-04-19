import 'package:floor/floor.dart';

mixin BillEntity {
  static const String COLUMN_ACCOUNT_ID = "account_id";
  static const String COLUMN_CATEGORY_ID = "category_id";

  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: "id")
  int? primaryKey;

  @ColumnInfo(name: COLUMN_ACCOUNT_ID)
  int? accountId;

  @ColumnInfo(name: COLUMN_CATEGORY_ID)
  int? categoryId;

}
