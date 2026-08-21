import "package:draya_mobile/features/student/home/data/models/daily_lesson_model.dart";
import "package:draya_mobile/features/student/home/data/models/point_needing_focus_model.dart";
import "package:draya_mobile/features/student/home/data/models/upcoming_exam_model.dart";
import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:json_annotation/json_annotation.dart";

part "student_dashboard_model.g.dart";

@JsonSerializable()
class StudentDashboardModel {
  @JsonKey(defaultValue: 0.0)
  final double overallAverage;
  @JsonKey(defaultValue: 0)
  final int completedLessonsCount;
  @JsonKey(defaultValue: 0)
  final int subscribedPackagesCount;
  @JsonKey(defaultValue: [])
  final List<String> urgentAlerts;
  @JsonKey(defaultValue: [])
  final List<DailyLessonModel> dailyLessons;
  @JsonKey(defaultValue: [])
  final List<UpcomingExamModel> upcomingExams;
  @JsonKey(defaultValue: [])
  final List<PointNeedingFocusModel> pointsNeedingFocus;
  final DateTime? lastActivityDate;
  @JsonKey(defaultValue: 0)
  final int currentStreak;

  const StudentDashboardModel({
    required this.overallAverage,
    required this.completedLessonsCount,
    required this.subscribedPackagesCount,
    this.urgentAlerts = const [],
    this.dailyLessons = const [],
    this.upcomingExams = const [],
    this.pointsNeedingFocus = const [],
    this.lastActivityDate,
    required this.currentStreak,
  });

  factory StudentDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$StudentDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDashboardModelToJson(this);

  StudentDashboard toEntity() => StudentDashboard(
        overallAverage: overallAverage,
        completedLessonsCount: completedLessonsCount,
        subscribedPackagesCount: subscribedPackagesCount,
        urgentAlerts: urgentAlerts,
        dailyLessons: dailyLessons.map((e) => e.toEntity()).toList(),
        upcomingExams: upcomingExams.map((e) => e.toEntity()).toList(),
        pointsNeedingFocus: pointsNeedingFocus.map((e) => e.toEntity()).toList(),
        lastActivityDate: lastActivityDate,
        currentStreak: currentStreak,
      );
}
