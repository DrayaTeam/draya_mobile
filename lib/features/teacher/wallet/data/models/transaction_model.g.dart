// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      type: (json['type'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      balanceType: (json['balanceType'] as num).toInt(),
      referenceId: json['referenceId'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'balanceType': instance.balanceType,
      'referenceId': instance.referenceId,
      'description': instance.description,
      'createdAt': instance.createdAt,
    };
