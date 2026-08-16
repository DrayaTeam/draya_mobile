// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentMaterialModel _$StudentMaterialModelFromJson(
  Map<String, dynamic> json,
) => StudentMaterialModel(
  materialId: json['materialId'] as String,
  title: json['title'] as String,
  materialType: json['materialType'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  currentVersion: StudentMaterialVersionModel.fromJson(
    json['currentVersion'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$StudentMaterialModelToJson(
  StudentMaterialModel instance,
) => <String, dynamic>{
  'materialId': instance.materialId,
  'title': instance.title,
  'materialType': instance.materialType,
  'createdAt': instance.createdAt.toIso8601String(),
  'currentVersion': instance.currentVersion,
};
