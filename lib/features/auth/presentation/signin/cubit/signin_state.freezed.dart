// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SigninState {

 CubitStatus get status; bool get rememberMe; AuthEntity? get authEntity; ApiErrorModel? get apiErrorModel;
/// Create a copy of SigninState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SigninStateCopyWith<SigninState> get copyWith => _$SigninStateCopyWithImpl<SigninState>(this as SigninState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SigninState&&(identical(other.status, status) || other.status == status)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.authEntity, authEntity) || other.authEntity == authEntity)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,rememberMe,authEntity,apiErrorModel);

@override
String toString() {
  return 'SigninState(status: $status, rememberMe: $rememberMe, authEntity: $authEntity, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $SigninStateCopyWith<$Res>  {
  factory $SigninStateCopyWith(SigninState value, $Res Function(SigninState) _then) = _$SigninStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, bool rememberMe, AuthEntity? authEntity, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$SigninStateCopyWithImpl<$Res>
    implements $SigninStateCopyWith<$Res> {
  _$SigninStateCopyWithImpl(this._self, this._then);

  final SigninState _self;
  final $Res Function(SigninState) _then;

/// Create a copy of SigninState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? rememberMe = null,Object? authEntity = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,authEntity: freezed == authEntity ? _self.authEntity : authEntity // ignore: cast_nullable_to_non_nullable
as AuthEntity?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [SigninState].
extension SigninStatePatterns on SigninState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SigninState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SigninState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SigninState value)  $default,){
final _that = this;
switch (_that) {
case _SigninState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SigninState value)?  $default,){
final _that = this;
switch (_that) {
case _SigninState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  bool rememberMe,  AuthEntity? authEntity,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SigninState() when $default != null:
return $default(_that.status,_that.rememberMe,_that.authEntity,_that.apiErrorModel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  bool rememberMe,  AuthEntity? authEntity,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _SigninState():
return $default(_that.status,_that.rememberMe,_that.authEntity,_that.apiErrorModel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  bool rememberMe,  AuthEntity? authEntity,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _SigninState() when $default != null:
return $default(_that.status,_that.rememberMe,_that.authEntity,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _SigninState implements SigninState {
  const _SigninState({this.status = CubitStatus.initial, this.rememberMe = false, this.authEntity, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override@JsonKey() final  bool rememberMe;
@override final  AuthEntity? authEntity;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of SigninState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SigninStateCopyWith<_SigninState> get copyWith => __$SigninStateCopyWithImpl<_SigninState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SigninState&&(identical(other.status, status) || other.status == status)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.authEntity, authEntity) || other.authEntity == authEntity)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,rememberMe,authEntity,apiErrorModel);

@override
String toString() {
  return 'SigninState(status: $status, rememberMe: $rememberMe, authEntity: $authEntity, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$SigninStateCopyWith<$Res> implements $SigninStateCopyWith<$Res> {
  factory _$SigninStateCopyWith(_SigninState value, $Res Function(_SigninState) _then) = __$SigninStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, bool rememberMe, AuthEntity? authEntity, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$SigninStateCopyWithImpl<$Res>
    implements _$SigninStateCopyWith<$Res> {
  __$SigninStateCopyWithImpl(this._self, this._then);

  final _SigninState _self;
  final $Res Function(_SigninState) _then;

/// Create a copy of SigninState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? rememberMe = null,Object? authEntity = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_SigninState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,authEntity: freezed == authEntity ? _self.authEntity : authEntity // ignore: cast_nullable_to_non_nullable
as AuthEntity?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
