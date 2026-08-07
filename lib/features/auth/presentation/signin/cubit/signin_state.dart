import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/auth/domain/entity/auth_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "signin_state.freezed.dart";

@freezed
abstract class SigninState with _$SigninState {
  const factory SigninState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default(false) bool rememberMe,
    AuthEntity? authEntity,
    ApiErrorModel? apiErrorModel,
  }) = _SigninState;
}
