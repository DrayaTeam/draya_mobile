import "package:draya_mobile/features/teacher/dashboard/data/models/needs_attention_list_item_model.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/recent_submissions_item_model.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/weekly_submissions_activity_item_model.dart";
import "package:json_annotation/json_annotation.dart";

part "teacher_dashboard_model.g.dart";

@JsonSerializable()
class TeacherDashboardModel {
  final int examsAwaitingReview;
  final double classAverage;
  final int activeStudents;
  final int reportsReadyForReview;
  final int newMessagesCount;
  final List<WeeklySubmissionsActivityItemModel> weeklySubmissionsActivity;
  final List<NeedsAttentionListItemModel> needsAttentionList;
  final List<RecentSubmissionsItemModel> recentSubmissions;

  TeacherDashboardModel({
    required this.examsAwaitingReview,
    required this.classAverage,
    required this.activeStudents,
    required this.reportsReadyForReview,
    required this.newMessagesCount,
    required this.weeklySubmissionsActivity,
    required this.needsAttentionList,
    required this.recentSubmissions,
  });

  factory TeacherDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherDashboardModelToJson(this);
}
