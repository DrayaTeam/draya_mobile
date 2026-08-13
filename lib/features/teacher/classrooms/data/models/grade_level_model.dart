import 'package:json_annotation/json_annotation.dart';

part "grade_level_model.g.dart";

@JsonSerializable()
class GradeLevelModel {
  final String id;
  final String name;

  const GradeLevelModel({required this.id, required this.name});

  factory GradeLevelModel.fromJson(Map<String, dynamic> json) =>
      _$GradeLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$GradeLevelModelToJson(this);
}
