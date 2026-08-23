import "package:json_annotation/json_annotation.dart";

part "weak_topics_model.g.dart";

@JsonSerializable()
class WeakTopicsModel {
  final String topicName;
  final double proficiencyPercent;
  final String recommendation;

  WeakTopicsModel({
    required this.topicName,
    required this.proficiencyPercent,
    required this.recommendation,
  });

  factory WeakTopicsModel.fromJson(Map<String, dynamic> json) =>
      _$WeakTopicsModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeakTopicsModelToJson(this);
}
