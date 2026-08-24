// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_password_reset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmPasswordResetModel _$ConfirmPasswordResetModelFromJson(
  Map<String, dynamic> json,
) => ConfirmPasswordResetModel(
  token: json['token'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ConfirmPasswordResetModelToJson(
  ConfirmPasswordResetModel instance,
) => <String, dynamic>{
  'token': instance.token,
  'newPassword': instance.newPassword,
};
