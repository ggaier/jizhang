import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill_category.g.dart';

@Entity(tableName: BillCategory.TABLE_NAME)
@JsonSerializable()
class BillCategory {
  static const TABLE_NAME = "BillCategory";

  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;

  BillCategory(this.name);

  factory BillCategory.fromJson(Map<String, dynamic> json) => _$BillCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$BillCategoryToJson(this);
}
