import 'package:json_annotation/json_annotation.dart';

part 'create_classroom_request_model.g.dart';

@JsonSerializable()
class CreateClassroomRequestModel {
  final String subjectId;
  final String name;
  final String classroomTypeId;
  final String gradeLevelId;
  final DateTime startDate;
  final DateTime endDate;
  final double price;

  const CreateClassroomRequestModel({
    required this.subjectId,
    required this.name,
    required this.classroomTypeId,
    required this.gradeLevelId,
    required this.startDate,
    required this.endDate,
    required this.price,
  });

  factory CreateClassroomRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateClassroomRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateClassroomRequestModelToJson(this);
}
