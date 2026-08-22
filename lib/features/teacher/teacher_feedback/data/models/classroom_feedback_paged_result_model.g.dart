// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_feedback_paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomFeedbackPagedResultModel _$ClassroomFeedbackPagedResultModelFromJson(
  Map<String, dynamic> json,
) => ClassroomFeedbackPagedResultModel(
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => FeedbackItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
  hasNextPage: json['hasNextPage'] as bool? ?? false,
  hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
);

Map<String, dynamic> _$ClassroomFeedbackPagedResultModelToJson(
  ClassroomFeedbackPagedResultModel instance,
) => <String, dynamic>{
  'averageRating': instance.averageRating,
  'totalCount': instance.totalCount,
  'items': instance.items,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalPages': instance.totalPages,
  'hasNextPage': instance.hasNextPage,
  'hasPreviousPage': instance.hasPreviousPage,
};
