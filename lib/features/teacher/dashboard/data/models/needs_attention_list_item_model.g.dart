// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'needs_attention_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeedsAttentionListItemModel _$NeedsAttentionListItemModelFromJson(
  Map<String, dynamic> json,
) => NeedsAttentionListItemModel(
  studentId: json['studentId'] as String,
  studentName: json['studentName'] as String,
  overallAverage: (json['overallAverage'] as num).toDouble(),
);

Map<String, dynamic> _$NeedsAttentionListItemModelToJson(
  NeedsAttentionListItemModel instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'studentName': instance.studentName,
  'overallAverage': instance.overallAverage,
};
