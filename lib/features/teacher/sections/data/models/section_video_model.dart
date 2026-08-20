import "package:json_annotation/json_annotation.dart";

part "section_video_model.g.dart";

@JsonSerializable()
class SectionVideoModel {
  final String id;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final String? videoUrl;
  final int videoDurationInSeconds;

  const SectionVideoModel({
    required this.id,
    required this.title,
    required this.materialType,
    required this.createdAt,
    required this.videoUrl,
    required this.videoDurationInSeconds,
  });

  factory SectionVideoModel.fromJson(Map<String, dynamic> json) =>
      _$SectionVideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionVideoModelToJson(this);
}
