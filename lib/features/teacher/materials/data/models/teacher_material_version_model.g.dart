// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_material_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherMaterialVersionModel _$TeacherMaterialVersionModelFromJson(
  Map<String, dynamic> json,
) => TeacherMaterialVersionModel(
  versionId: json['versionId'] as String,
  versionNumber: (json['versionNumber'] as num).toInt(),
  fileUrl: json['fileUrl'] as String?,
  parseStatus: json['parseStatus'] as String,
  uploadedAt: DateTime.parse(json['uploadedAt'] as String),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$TeacherMaterialVersionModelToJson(
  TeacherMaterialVersionModel instance,
) => <String, dynamic>{
  'versionId': instance.versionId,
  'versionNumber': instance.versionNumber,
  'fileUrl': instance.fileUrl,
  'parseStatus': instance.parseStatus,
  'uploadedAt': instance.uploadedAt.toIso8601String(),
  'errorMessage': instance.errorMessage,
};
