// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_classroom_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateClassroomRequestModel _$CreateClassroomRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateClassroomRequestModel(
  subjectId: json['subjectId'] as String,
  name: json['name'] as String,
  classroomTypeId: json['classroomTypeId'] as String,
  gradeLevelId: json['gradeLevelId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$CreateClassroomRequestModelToJson(
  CreateClassroomRequestModel instance,
) => <String, dynamic>{
  'subjectId': instance.subjectId,
  'name': instance.name,
  'classroomTypeId': instance.classroomTypeId,
  'gradeLevelId': instance.gradeLevelId,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'price': instance.price,
};
