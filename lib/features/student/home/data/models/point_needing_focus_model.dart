import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:json_annotation/json_annotation.dart";

part "point_needing_focus_model.g.dart";

@JsonSerializable()
class PointNeedingFocusModel {
  @JsonKey(defaultValue: "")
  final String topicName;
  @JsonKey(defaultValue: 0.0)
  final double proficiencyPercent;

  const PointNeedingFocusModel({
    required this.topicName,
    required this.proficiencyPercent,
  });

  factory PointNeedingFocusModel.fromJson(Map<String, dynamic> json) =>
      _$PointNeedingFocusModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointNeedingFocusModelToJson(this);

  PointNeedingFocus toEntity() => PointNeedingFocus(
        topicName: topicName,
        proficiencyPercent: proficiencyPercent,
      );
}
