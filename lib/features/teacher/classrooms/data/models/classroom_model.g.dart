// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomModel _$ClassroomModelFromJson(Map<String, dynamic> json) =>
    ClassroomModel(
      classroomId: json['classroomId'] as String,
      teacherId: json['teacherId'] as String,
      subjectName: json['subjectName'] as String,
      name: json['name'] as String,
      enrollmentCode: json['enrollmentCode'] as String,
      isActive: json['isActive'] as bool,
      studentCount: (json['studentCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ClassroomModelToJson(ClassroomModel instance) =>
    <String, dynamic>{
      'classroomId': instance.classroomId,
      'teacherId': instance.teacherId,
      'subjectName': instance.subjectName,
      'name': instance.name,
      'enrollmentCode': instance.enrollmentCode,
      'isActive': instance.isActive,
      'studentCount': instance.studentCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
