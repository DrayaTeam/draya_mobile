import "package:draya_mobile/features/student/student_materials/domain/entity/material_stream.dart";
import "package:json_annotation/json_annotation.dart";

part "material_stream_model.g.dart";

@JsonSerializable()
class MaterialStreamModel {
  final String provider;
  final String videoId;
  final String streamUrl;
  final DateTime expiresAt;

  const MaterialStreamModel({
    required this.provider,
    required this.videoId,
    required this.streamUrl,
    required this.expiresAt,
  });

  factory MaterialStreamModel.fromJson(Map<String, dynamic> json) =>
      _$MaterialStreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialStreamModelToJson(this);
}

extension MaterialStreamModelMapper on MaterialStreamModel {
  MaterialStream toEntity() => MaterialStream(
    provider: provider,
    videoId: videoId,
    streamUrl: streamUrl,
    expiresAt: expiresAt,
  );
}
