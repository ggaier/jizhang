// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayAccount _$PayAccountFromJson(Map<String, dynamic> json) {
  return PayAccount(
    json['id'] as int,
    json['name'] as String,
    json['balance'] as int,
    json['genre'] as String,
    json['remark'] as String,
  );
}

Map<String, dynamic> _$PayAccountToJson(PayAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'genre': instance.genre,
      'remark': instance.remark,
    };
