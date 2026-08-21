// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherDashboardModel _$TeacherDashboardModelFromJson(
  Map<String, dynamic> json,
) => TeacherDashboardModel(
  examsAwaitingReview: (json['examsAwaitingReview'] as num).toInt(),
  classAverage: (json['classAverage'] as num).toDouble(),
  activeStudents: (json['activeStudents'] as num).toInt(),
  reportsReadyForReview: (json['reportsReadyForReview'] as num).toInt(),
  newMessagesCount: (json['newMessagesCount'] as num).toInt(),
  weeklySubmissionsActivity:
      (json['weeklySubmissionsActivity'] as List<dynamic>)
          .map(
            (e) => WeeklySubmissionsActivityItemModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
  needsAttentionList: (json['needsAttentionList'] as List<dynamic>)
      .map(
        (e) => NeedsAttentionListItemModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  recentSubmissions: (json['recentSubmissions'] as List<dynamic>)
      .map(
        (e) => RecentSubmissionsItemModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$TeacherDashboardModelToJson(
  TeacherDashboardModel instance,
) => <String, dynamic>{
  'examsAwaitingReview': instance.examsAwaitingReview,
  'classAverage': instance.classAverage,
  'activeStudents': instance.activeStudents,
  'reportsReadyForReview': instance.reportsReadyForReview,
  'newMessagesCount': instance.newMessagesCount,
  'weeklySubmissionsActivity': instance.weeklySubmissionsActivity,
  'needsAttentionList': instance.needsAttentionList,
  'recentSubmissions': instance.recentSubmissions,
};
