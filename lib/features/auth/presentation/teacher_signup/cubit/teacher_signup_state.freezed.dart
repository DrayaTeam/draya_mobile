// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherSignupState {

 CubitStatus get status; AuthEntity? get authEntity; ApiErrorModel? get apiErrorModel;
/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherSignupStateCopyWith<TeacherSignupState> get copyWith => _$TeacherSignupStateCopyWithImpl<TeacherSignupState>(this as TeacherSignupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSignupState&&(identical(other.status, status) || other.status == status)&&(identical(other.authEntity, authEntity) || other.authEntity == authEntity)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,authEntity,apiErrorModel);

@override
String toString() {
  return 'TeacherSignupState(status: $status, authEntity: $authEntity, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $TeacherSignupStateCopyWith<$Res>  {
  factory $TeacherSignupStateCopyWith(TeacherSignupState value, $Res Function(TeacherSignupState) _then) = _$TeacherSignupStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, AuthEntity? authEntity, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$TeacherSignupStateCopyWithImpl<$Res>
    implements $TeacherSignupStateCopyWith<$Res> {
  _$TeacherSignupStateCopyWithImpl(this._self, this._then);

  final TeacherSignupState _self;
  final $Res Function(TeacherSignupState) _then;

/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? authEntity = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,authEntity: freezed == authEntity ? _self.authEntity : authEntity // ignore: cast_nullable_to_non_nullable
as AuthEntity?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherSignupState].
extension TeacherSignupStatePatterns on TeacherSignupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherSignupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherSignupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherSignupState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherSignupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherSignupState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherSignupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  AuthEntity? authEntity,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherSignupState() when $default != null:
return $default(_that.status,_that.authEntity,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  AuthEntity? authEntity,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _TeacherSignupState():
return $default(_that.status,_that.authEntity,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  AuthEntity? authEntity,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _TeacherSignupState() when $default != null:
return $default(_that.status,_that.authEntity,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherSignupState implements TeacherSignupState {
  const _TeacherSignupState({this.status = CubitStatus.initial, this.authEntity, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override final  AuthEntity? authEntity;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherSignupStateCopyWith<_TeacherSignupState> get copyWith => __$TeacherSignupStateCopyWithImpl<_TeacherSignupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherSignupState&&(identical(other.status, status) || other.status == status)&&(identical(other.authEntity, authEntity) || other.authEntity == authEntity)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,authEntity,apiErrorModel);

@override
String toString() {
  return 'TeacherSignupState(status: $status, authEntity: $authEntity, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$TeacherSignupStateCopyWith<$Res> implements $TeacherSignupStateCopyWith<$Res> {
  factory _$TeacherSignupStateCopyWith(_TeacherSignupState value, $Res Function(_TeacherSignupState) _then) = __$TeacherSignupStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, AuthEntity? authEntity, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$TeacherSignupStateCopyWithImpl<$Res>
    implements _$TeacherSignupStateCopyWith<$Res> {
  __$TeacherSignupStateCopyWithImpl(this._self, this._then);

  final _TeacherSignupState _self;
  final $Res Function(_TeacherSignupState) _then;

/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? authEntity = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_TeacherSignupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,authEntity: freezed == authEntity ? _self.authEntity : authEntity // ignore: cast_nullable_to_non_nullable
as AuthEntity?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
