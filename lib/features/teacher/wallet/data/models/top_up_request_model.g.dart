// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_up_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopUpRequestModel _$TopUpRequestModelFromJson(Map<String, dynamic> json) =>
    TopUpRequestModel(
      amount: (json['amount'] as num).toDouble(),
      redirectionUrl:
          json['redirectionUrl'] as String? ??
          "https://draya.com/payment/result",
    );

Map<String, dynamic> _$TopUpRequestModelToJson(TopUpRequestModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'redirectionUrl': instance.redirectionUrl,
    };
