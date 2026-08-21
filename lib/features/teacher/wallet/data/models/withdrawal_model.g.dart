// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawalModel _$WithdrawalModelFromJson(Map<String, dynamic> json) =>
    WithdrawalModel(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String?,
      amount: (json['amount'] as num).toDouble(),
      status: (json['status'] as num).toInt(),
      requestedAt: json['requestedAt'] as String,
      processedAt: json['processedAt'] as String?,
      adminNote: json['adminNote'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$WithdrawalModelToJson(WithdrawalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherId': instance.teacherId,
      'amount': instance.amount,
      'status': instance.status,
      'requestedAt': instance.requestedAt,
      'processedAt': instance.processedAt,
      'adminNote': instance.adminNote,
      'rejectionReason': instance.rejectionReason,
    };
