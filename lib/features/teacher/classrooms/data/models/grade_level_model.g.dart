// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_level_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeLevelModel _$GradeLevelModelFromJson(Map<String, dynamic> json) =>
    GradeLevelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GradeLevelModelToJson(GradeLevelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
