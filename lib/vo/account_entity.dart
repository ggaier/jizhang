import 'package:json_annotation/json_annotation.dart';

part 'account_entity.g.dart';

@JsonSerializable()
class PayAccount {
  final int id;
  final String name;
  final int balance;
  final String genre;
  final String remark;

  PayAccount(this.id, this.name, this.balance, this.genre, this.remark);

  PayAccount.name(this.id, this.name, this.balance, this.genre, this.remark);

  Map<String, dynamic> toJson() => _$PayAccountToJson(this);

  factory PayAccount.fromJson(Map<String, dynamic> json) => _$PayAccountFromJson(json);
}
