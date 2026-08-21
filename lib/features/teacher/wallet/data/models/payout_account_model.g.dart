// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutAccountModel _$PayoutAccountModelFromJson(Map<String, dynamic> json) =>
    PayoutAccountModel(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String?,
      accountType: (json['accountType'] as num).toInt(),
      accountName: json['accountName'] as String,
      accountIdentifier: json['accountIdentifier'] as String,
      isDefault: json['isDefault'] as bool,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$PayoutAccountModelToJson(PayoutAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherId': instance.teacherId,
      'accountType': instance.accountType,
      'accountName': instance.accountName,
      'accountIdentifier': instance.accountIdentifier,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt,
    };
