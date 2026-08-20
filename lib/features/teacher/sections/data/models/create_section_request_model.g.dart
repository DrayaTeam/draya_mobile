// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_section_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSectionRequestModel _$CreateSectionRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateSectionRequestModel(
  title: json['title'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$CreateSectionRequestModelToJson(
  CreateSectionRequestModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
};
