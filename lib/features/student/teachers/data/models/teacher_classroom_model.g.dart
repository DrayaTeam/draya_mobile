// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_classroom_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherClassroomModel _$TeacherClassroomModelFromJson(
  Map<String, dynamic> json,
) => TeacherClassroomModel(
  classroomId: json['classroomId'] as String,
  teacherId: json['teacherId'] as String,
  subjectName: json['subjectName'] as String,
  name: json['name'] as String,
  enrollmentCode: json['enrollmentCode'] as String,
  isActive: json['isActive'] as bool,
  studentCount: (json['studentCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  classroomTypeName: json['classroomTypeName'] as String,
  gradeLevelName: json['gradeLevelName'] as String,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$TeacherClassroomModelToJson(
  TeacherClassroomModel instance,
) => <String, dynamic>{
  'classroomId': instance.classroomId,
  'teacherId': instance.teacherId,
  'subjectName': instance.subjectName,
  'name': instance.name,
  'enrollmentCode': instance.enrollmentCode,
  'isActive': instance.isActive,
  'studentCount': instance.studentCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'classroomTypeName': instance.classroomTypeName,
  'gradeLevelName': instance.gradeLevelName,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'price': instance.price,
};
