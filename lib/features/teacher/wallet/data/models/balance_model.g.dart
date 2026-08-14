// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceModel _$BalanceModelFromJson(Map<String, dynamic> json) => BalanceModel(
  earnedBalance: (json['earnedBalance'] as num).toDouble(),
  purchasedBalance: (json['purchasedBalance'] as num).toDouble(),
  availableEarnedBalance: (json['availableEarnedBalance'] as num).toDouble(),
);

Map<String, dynamic> _$BalanceModelToJson(BalanceModel instance) =>
    <String, dynamic>{
      'earnedBalance': instance.earnedBalance,
      'purchasedBalance': instance.purchasedBalance,
      'availableEarnedBalance': instance.availableEarnedBalance,
    };
