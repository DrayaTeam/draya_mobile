// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherMaterialModel _$TeacherMaterialModelFromJson(
  Map<String, dynamic> json,
) => TeacherMaterialModel(
  materialId: json['materialId'] as String,
  title: json['title'] as String,
  materialType: json['materialType'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  currentVersion: TeacherMaterialVersionModel.fromJson(
    json['currentVersion'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$TeacherMaterialModelToJson(
  TeacherMaterialModel instance,
) => <String, dynamic>{
  'materialId': instance.materialId,
  'title': instance.title,
  'materialType': instance.materialType,
  'createdAt': instance.createdAt.toIso8601String(),
  'currentVersion': instance.currentVersion,
};
