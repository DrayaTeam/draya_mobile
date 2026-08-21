import "package:json_annotation/json_annotation.dart";

part "needs_attention_list_item_model.g.dart";

@JsonSerializable()
class NeedsAttentionListItemModel {
  final String studentId;
  final String studentName;
  final double overallAverage;

  const NeedsAttentionListItemModel({
    required this.studentId,
    required this.studentName,
    required this.overallAverage,
  });

  factory NeedsAttentionListItemModel.fromJson(Map<String, dynamic> json) =>
      _$NeedsAttentionListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$NeedsAttentionListItemModelToJson(this);
}
