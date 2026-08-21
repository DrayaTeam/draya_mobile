// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudentSignupState {

 CubitStatus get status; AuthEntity? get authEntity; ApiErrorModel? get apiErrorModel;
/// Create a copy of StudentSignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentSignupStateCopyWith<StudentSignupState> get copyWith => _$StudentSignupStateCopyWithImpl<StudentSignupState>(this as StudentSignupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentSignupState&&(identical(other.status, status) || other.status == status)&&(identical(other.authEntity, authEntity) || other.authEntity == authEntity)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,authEntity,apiErrorModel);

@override
String toString() {
  return 'StudentSignupState(status: $status, authEntity: $authEntity, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $StudentSignupStateCopyWith<$Res>  {
  factory $StudentSignupStateCopyWith(StudentSignupState value, $Res Function(StudentSignupState) _then) = _$StudentSignupStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, AuthEntity? authEntity, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$StudentSignupStateCopyWithImpl<$Res>
    implements $StudentSignupStateCopyWith<$Res> {
  _$StudentSignupStateCopyWithImpl(this._self, this._then);

  final StudentSignupState _self;
  final $Res Function(StudentSignupState) _then;

/// Create a copy of StudentSignupState
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


/// Adds pattern-matching-related methods to [StudentSignupState].
extension StudentSignupStatePatterns on StudentSignupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentSignupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentSignupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentSignupState value)  $default,){
final _that = this;
switch (_that) {
case _StudentSignupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentSignupState value)?  $default,){
final _that = this;
switch (_that) {
case _StudentSignupState() when $default != null:
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
case _StudentSignupState() when $default != null:
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
case _StudentSignupState():
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
case _StudentSignupState() when $default != null:
return $default(_that.status,_that.authEntity,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _StudentSignupState implements StudentSignupState {
  const _StudentSignupState({this.status = CubitStatus.initial, this.authEntity, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override final  AuthEntity? authEntity;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of StudentSignupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentSignupStateCopyWith<_StudentSignupState> get copyWith => __$StudentSignupStateCopyWithImpl<_StudentSignupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentSignupState&&(identical(other.status, status) || other.status == status)&&(identical(other.authEntity, authEntity) || other.authEntity == authEntity)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,authEntity,apiErrorModel);

@override
String toString() {
  return 'StudentSignupState(status: $status, authEntity: $authEntity, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$StudentSignupStateCopyWith<$Res> implements $StudentSignupStateCopyWith<$Res> {
  factory _$StudentSignupStateCopyWith(_StudentSignupState value, $Res Function(_StudentSignupState) _then) = __$StudentSignupStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, AuthEntity? authEntity, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$StudentSignupStateCopyWithImpl<$Res>
    implements _$StudentSignupStateCopyWith<$Res> {
  __$StudentSignupStateCopyWithImpl(this._self, this._then);

  final _StudentSignupState _self;
  final $Res Function(_StudentSignupState) _then;

/// Create a copy of StudentSignupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? authEntity = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_StudentSignupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,authEntity: freezed == authEntity ? _self.authEntity : authEntity // ignore: cast_nullable_to_non_nullable
as AuthEntity?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
