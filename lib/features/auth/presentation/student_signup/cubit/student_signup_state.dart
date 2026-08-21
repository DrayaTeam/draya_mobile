import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/auth/domain/entity/auth_entity.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "student_signup_state.freezed.dart";

@freezed
abstract class StudentSignupState with _$StudentSignupState {
  const factory StudentSignupState({
    @Default(CubitStatus.initial) CubitStatus status,
    AuthEntity? authEntity,
    ApiErrorModel? apiErrorModel,
  }) = _StudentSignupState;
}
