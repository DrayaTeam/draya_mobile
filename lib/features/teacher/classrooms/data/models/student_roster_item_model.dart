import 'package:draya_mobile/features/teacher/classrooms/domain/entity/student_roster_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_roster_item_model.g.dart';

@JsonSerializable()
class StudentRosterItemModel {
  final String studentId;
  final String fullName;
  final DateTime enrolledAt;
  final String status;

  const StudentRosterItemModel({
    required this.studentId,
    required this.fullName,
    required this.enrolledAt,
    required this.status,
  });

  factory StudentRosterItemModel.fromJson(Map<String, dynamic> json) =>
      _$StudentRosterItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentRosterItemModelToJson(this);
}

extension StudentRosterItemModelExtension on StudentRosterItemModel {
  StudentRosterItem toEntity() => StudentRosterItem(
    studentId: studentId,
    fullName: fullName,
    enrolledAt: enrolledAt,
    status: status,
  );
}
