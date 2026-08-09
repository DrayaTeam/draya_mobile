// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_roster_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentRosterItemModel _$StudentRosterItemModelFromJson(
  Map<String, dynamic> json,
) => StudentRosterItemModel(
  studentId: json['studentId'] as String,
  fullName: json['fullName'] as String,
  enrolledAt: DateTime.parse(json['enrolledAt'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$StudentRosterItemModelToJson(
  StudentRosterItemModel instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'fullName': instance.fullName,
  'enrolledAt': instance.enrolledAt.toIso8601String(),
  'status': instance.status,
};
