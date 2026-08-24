// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confirm_password_reset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConfirmPasswordResetState {

 CubitStatus get status; ApiErrorModel? get apiErrorModel;
/// Create a copy of ConfirmPasswordResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmPasswordResetStateCopyWith<ConfirmPasswordResetState> get copyWith => _$ConfirmPasswordResetStateCopyWithImpl<ConfirmPasswordResetState>(this as ConfirmPasswordResetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmPasswordResetState&&(identical(other.status, status) || other.status == status)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,apiErrorModel);

@override
String toString() {
  return 'ConfirmPasswordResetState(status: $status, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $ConfirmPasswordResetStateCopyWith<$Res>  {
  factory $ConfirmPasswordResetStateCopyWith(ConfirmPasswordResetState value, $Res Function(ConfirmPasswordResetState) _then) = _$ConfirmPasswordResetStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$ConfirmPasswordResetStateCopyWithImpl<$Res>
    implements $ConfirmPasswordResetStateCopyWith<$Res> {
  _$ConfirmPasswordResetStateCopyWithImpl(this._self, this._then);

  final ConfirmPasswordResetState _self;
  final $Res Function(ConfirmPasswordResetState) _then;

/// Create a copy of ConfirmPasswordResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfirmPasswordResetState].
extension ConfirmPasswordResetStatePatterns on ConfirmPasswordResetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfirmPasswordResetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfirmPasswordResetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfirmPasswordResetState value)  $default,){
final _that = this;
switch (_that) {
case _ConfirmPasswordResetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfirmPasswordResetState value)?  $default,){
final _that = this;
switch (_that) {
case _ConfirmPasswordResetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfirmPasswordResetState() when $default != null:
return $default(_that.status,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _ConfirmPasswordResetState():
return $default(_that.status,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _ConfirmPasswordResetState() when $default != null:
return $default(_that.status,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _ConfirmPasswordResetState implements ConfirmPasswordResetState {
  const _ConfirmPasswordResetState({this.status = CubitStatus.initial, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of ConfirmPasswordResetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmPasswordResetStateCopyWith<_ConfirmPasswordResetState> get copyWith => __$ConfirmPasswordResetStateCopyWithImpl<_ConfirmPasswordResetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmPasswordResetState&&(identical(other.status, status) || other.status == status)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,apiErrorModel);

@override
String toString() {
  return 'ConfirmPasswordResetState(status: $status, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$ConfirmPasswordResetStateCopyWith<$Res> implements $ConfirmPasswordResetStateCopyWith<$Res> {
  factory _$ConfirmPasswordResetStateCopyWith(_ConfirmPasswordResetState value, $Res Function(_ConfirmPasswordResetState) _then) = __$ConfirmPasswordResetStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$ConfirmPasswordResetStateCopyWithImpl<$Res>
    implements _$ConfirmPasswordResetStateCopyWith<$Res> {
  __$ConfirmPasswordResetStateCopyWithImpl(this._self, this._then);

  final _ConfirmPasswordResetState _self;
  final $Res Function(_ConfirmPasswordResetState) _then;

/// Create a copy of ConfirmPasswordResetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? apiErrorModel = freezed,}) {
  return _then(_ConfirmPasswordResetState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
