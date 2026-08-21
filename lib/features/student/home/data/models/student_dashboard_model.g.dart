// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDashboardModel _$StudentDashboardModelFromJson(
  Map<String, dynamic> json,
) => StudentDashboardModel(
  overallAverage: (json['overallAverage'] as num?)?.toDouble() ?? 0.0,
  completedLessonsCount: (json['completedLessonsCount'] as num?)?.toInt() ?? 0,
  subscribedPackagesCount:
      (json['subscribedPackagesCount'] as num?)?.toInt() ?? 0,
  urgentAlerts:
      (json['urgentAlerts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  dailyLessons:
      (json['dailyLessons'] as List<dynamic>?)
          ?.map((e) => DailyLessonModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  upcomingExams:
      (json['upcomingExams'] as List<dynamic>?)
          ?.map((e) => UpcomingExamModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  pointsNeedingFocus:
      (json['pointsNeedingFocus'] as List<dynamic>?)
          ?.map(
            (e) => PointNeedingFocusModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  lastActivityDate: json['lastActivityDate'] == null
      ? null
      : DateTime.parse(json['lastActivityDate'] as String),
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StudentDashboardModelToJson(
  StudentDashboardModel instance,
) => <String, dynamic>{
  'overallAverage': instance.overallAverage,
  'completedLessonsCount': instance.completedLessonsCount,
  'subscribedPackagesCount': instance.subscribedPackagesCount,
  'urgentAlerts': instance.urgentAlerts,
  'dailyLessons': instance.dailyLessons,
  'upcomingExams': instance.upcomingExams,
  'pointsNeedingFocus': instance.pointsNeedingFocus,
  'lastActivityDate': instance.lastActivityDate?.toIso8601String(),
  'currentStreak': instance.currentStreak,
};
