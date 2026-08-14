// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_up_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopUpResponseModel _$TopUpResponseModelFromJson(Map<String, dynamic> json) =>
    TopUpResponseModel(
      transactionId: json['transactionId'] as String,
      amount: (json['amount'] as num).toDouble(),
      checkoutUrl: json['checkoutUrl'] as String,
    );

Map<String, dynamic> _$TopUpResponseModelToJson(TopUpResponseModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'checkoutUrl': instance.checkoutUrl,
    };
