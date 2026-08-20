import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/auth/domain/entity/auth_entity.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "student_signup_state.freezed.dart";

@freezed
sealed class StudentSignupState with _$StudentSignupState {
  const factory StudentSignupState.initial() = StudentSignupInitial;

  const factory StudentSignupState.loading() = StudentSignupLoading;

  const factory StudentSignupState.success({required AuthEntity authEntity}) =
      StudentSignupSuccess;

  const factory StudentSignupState.failure({required ApiErrorModel apiErrorModel}) =
      StudentSignupFailure;
}
