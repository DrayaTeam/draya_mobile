// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawalRequestModel _$WithdrawalRequestModelFromJson(
  Map<String, dynamic> json,
) => WithdrawalRequestModel(
  amount: (json['amount'] as num).toDouble(),
  payoutAccountId: json['payoutAccountId'] as String,
);

Map<String, dynamic> _$WithdrawalRequestModelToJson(
  WithdrawalRequestModel instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'payoutAccountId': instance.payoutAccountId,
};
