import "package:json_annotation/json_annotation.dart";

part "subject_proficiencies_model.g.dart";

@JsonSerializable()
class SubjectProficienciesModel {
  final String subjectName;
  final double proficiencyPercent;

  SubjectProficienciesModel({
    required this.subjectName,
    required this.proficiencyPercent,
  });

  factory SubjectProficienciesModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectProficienciesModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectProficienciesModelToJson(this);
}
