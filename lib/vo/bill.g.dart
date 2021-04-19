// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) {
  return Bill(
    json['id'] as int,
    json['billDate'] as int,
    json['billTime'] as int,
    json['account'] == null
        ? null
        : PayAccount.fromJson(json['account'] as Map<String, dynamic>),
    json['genre'] == null
        ? null
        : BillCategory.fromJson(json['genre'] as Map<String, dynamic>),
    json['amount'] as int,
    json['currencySymbol'] as String,
    json['remark'] as String,
    _$enumDecode(_$BillTypeEnumMap, json['billType']),
  );
}

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'id': instance.id,
      'billDate': instance.billDate,
      'billTime': instance.billTime,
      'account': instance.account,
      'genre': instance.genre,
      'amount': instance.amount,
      'currencySymbol': instance.currencySymbol,
      'remark': instance.remark,
      'billType': _$BillTypeEnumMap[instance.billType],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$BillTypeEnumMap = {
  BillType.earning: 'earning',
  BillType.expense: 'expense',
  BillType.summary: 'summary',
  BillType.transfer: 'transfer',
};
