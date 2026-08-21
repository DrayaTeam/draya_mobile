// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_account_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutAccountRequestModel _$PayoutAccountRequestModelFromJson(
  Map<String, dynamic> json,
) => PayoutAccountRequestModel(
  accountType: (json['accountType'] as num).toInt(),
  accountName: json['accountName'] as String,
  accountIdentifier: json['accountIdentifier'] as String,
  isDefault: json['isDefault'] as bool,
);

Map<String, dynamic> _$PayoutAccountRequestModelToJson(
  PayoutAccountRequestModel instance,
) => <String, dynamic>{
  'accountType': instance.accountType,
  'accountName': instance.accountName,
  'accountIdentifier': instance.accountIdentifier,
  'isDefault': instance.isDefault,
};
