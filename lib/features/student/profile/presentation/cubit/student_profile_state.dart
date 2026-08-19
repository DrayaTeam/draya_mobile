import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/student/profile/data/models/student_profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_profile_state.freezed.dart';

@freezed
abstract class StudentProfileState with _$StudentProfileState {
  const factory StudentProfileState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default(null) StudentProfileModel? studentProfile,
    @Default(false) bool isUploadingPicture,
    ApiErrorModel? apiErrorModel,
  }) = _StudentProfileState;
}
