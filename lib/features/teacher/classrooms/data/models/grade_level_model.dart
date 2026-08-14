import 'package:json_annotation/json_annotation.dart';

part "grade_level_model.g.dart";

@JsonSerializable()
class GradeLevelModel {
  final String id;
  final String name;
  final String description;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;

  const GradeLevelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
  });

  factory GradeLevelModel.fromJson(Map<String, dynamic> json) =>
      _$GradeLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$GradeLevelModelToJson(this);
}
