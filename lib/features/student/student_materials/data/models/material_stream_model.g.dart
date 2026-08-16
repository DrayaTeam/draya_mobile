// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_stream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterialStreamModel _$MaterialStreamModelFromJson(Map<String, dynamic> json) =>
    MaterialStreamModel(
      provider: json['provider'] as String,
      videoId: json['videoId'] as String,
      streamUrl: json['streamUrl'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$MaterialStreamModelToJson(
  MaterialStreamModel instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'videoId': instance.videoId,
  'streamUrl': instance.streamUrl,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
