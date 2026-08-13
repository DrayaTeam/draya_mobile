// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomTypeModel _$ClassroomTypeModelFromJson(Map<String, dynamic> json) =>
    ClassroomTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ClassroomTypeModelToJson(ClassroomTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
