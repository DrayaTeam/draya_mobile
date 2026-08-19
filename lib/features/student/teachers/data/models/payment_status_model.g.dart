// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatusModel _$PaymentStatusModelFromJson(Map<String, dynamic> json) =>
    PaymentStatusModel(
      paymentTransactionId: json['paymentTransactionId'] as String,
      status: json['status'] as String,
      grossAmount: (json['grossAmount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      classroomId: json['classroomId'] as String?,
      isEnrolled: json['isEnrolled'] as bool,
    );

Map<String, dynamic> _$PaymentStatusModelToJson(PaymentStatusModel instance) =>
    <String, dynamic>{
      'paymentTransactionId': instance.paymentTransactionId,
      'status': instance.status,
      'grossAmount': instance.grossAmount,
      'purpose': instance.purpose,
      'classroomId': instance.classroomId,
      'isEnrolled': instance.isEnrolled,
    };
