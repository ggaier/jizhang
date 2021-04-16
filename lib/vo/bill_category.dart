
import 'package:json_annotation/json_annotation.dart';

part 'bill_category.g.dart';

@JsonSerializable()
class BillCategory {
  final String name;
  BillCategory(this.name);

  factory BillCategory.fromJson(Map<String, dynamic> json) => _$BillCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$BillCategoryToJson(this);

}
