// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_proficiencies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectProficienciesModel _$SubjectProficienciesModelFromJson(
  Map<String, dynamic> json,
) => SubjectProficienciesModel(
  subjectName: json['subjectName'] as String,
  proficiencyPercent: (json['proficiencyPercent'] as num).toDouble(),
);

Map<String, dynamic> _$SubjectProficienciesModelToJson(
  SubjectProficienciesModel instance,
) => <String, dynamic>{
  'subjectName': instance.subjectName,
  'proficiencyPercent': instance.proficiencyPercent,
};
