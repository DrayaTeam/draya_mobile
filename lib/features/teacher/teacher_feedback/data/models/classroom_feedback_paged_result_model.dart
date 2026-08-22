import "package:draya_mobile/features/teacher/teacher_feedback/data/models/feedback_item_model.dart";
import "package:json_annotation/json_annotation.dart";

part "classroom_feedback_paged_result_model.g.dart";

@JsonSerializable()
class ClassroomFeedbackPagedResultModel {
  @JsonKey(defaultValue: 0)
  final double averageRating;
  @JsonKey(defaultValue: 0)
  final int totalCount;
  @JsonKey(defaultValue: [])
  final List<FeedbackItemModel> items;
  @JsonKey(defaultValue: 1)
  final int pageNumber;
  @JsonKey(defaultValue: 10)
  final int pageSize;
  @JsonKey(defaultValue: 0)
  final int totalPages;
  @JsonKey(defaultValue: false)
  final bool hasNextPage;
  @JsonKey(defaultValue: false)
  final bool hasPreviousPage;

  const ClassroomFeedbackPagedResultModel({
    required this.averageRating,
    required this.totalCount,
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ClassroomFeedbackPagedResultModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ClassroomFeedbackPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClassroomFeedbackPagedResultModelToJson(this);
}
