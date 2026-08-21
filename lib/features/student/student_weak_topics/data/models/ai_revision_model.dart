import "package:draya_mobile/features/student/student_weak_topics/domain/entity/ai_revision.dart";
import "package:json_annotation/json_annotation.dart";

part "ai_revision_model.g.dart";

@JsonSerializable()
class AiRevisionModel {
  @JsonKey(name: "recommendation", defaultValue: "")
  final String recommendation;

  @JsonKey(name: "aiExplanation", defaultValue: "")
  final String aiExplanation;

  const AiRevisionModel({
    required this.recommendation,
    required this.aiExplanation,
  });

  factory AiRevisionModel.fromJson(Map<String, dynamic> json) =>
      _$AiRevisionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AiRevisionModelToJson(this);

  AiRevision toEntity() {
    return AiRevision(
      recommendation: recommendation,
      aiExplanation: aiExplanation,
    );
  }
}
