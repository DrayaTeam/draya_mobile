import 'package:json_annotation/json_annotation.dart';

part "subject_model.g.dart";

@JsonSerializable()
class SubjectModel {
  final String id;
  final String name;

  const SubjectModel({required this.id, required this.name});

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);
}
