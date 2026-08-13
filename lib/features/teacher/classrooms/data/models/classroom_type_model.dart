import 'package:json_annotation/json_annotation.dart';

part "classroom_type_model.g.dart";

@JsonSerializable()
class ClassroomTypeModel {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  const ClassroomTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory ClassroomTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomTypeModelToJson(this);
}
