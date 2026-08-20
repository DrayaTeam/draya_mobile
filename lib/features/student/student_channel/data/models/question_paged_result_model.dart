import "package:json_annotation/json_annotation.dart";
import "package:draya_mobile/features/student/student_channel/data/models/question_model.dart";

part "question_paged_result_model.g.dart";

@JsonSerializable()
class QuestionPagedResultModel {
  final List<QuestionModel> items;
  @JsonKey(name: "pageNumber")
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const QuestionPagedResultModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory QuestionPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionPagedResultModelToJson(this);
}
