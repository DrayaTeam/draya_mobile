// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudentProfileState {

 CubitStatus get status; StudentProfileModel? get studentProfile; ApiErrorModel? get apiErrorModel;
/// Create a copy of StudentProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProfileStateCopyWith<StudentProfileState> get copyWith => _$StudentProfileStateCopyWithImpl<StudentProfileState>(this as StudentProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.studentProfile, studentProfile) || other.studentProfile == studentProfile)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,studentProfile,apiErrorModel);

@override
String toString() {
  return 'StudentProfileState(status: $status, studentProfile: $studentProfile, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $StudentProfileStateCopyWith<$Res>  {
  factory $StudentProfileStateCopyWith(StudentProfileState value, $Res Function(StudentProfileState) _then) = _$StudentProfileStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, StudentProfileModel? studentProfile, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$StudentProfileStateCopyWithImpl<$Res>
    implements $StudentProfileStateCopyWith<$Res> {
  _$StudentProfileStateCopyWithImpl(this._self, this._then);

  final StudentProfileState _self;
  final $Res Function(StudentProfileState) _then;

/// Create a copy of StudentProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? studentProfile = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,studentProfile: freezed == studentProfile ? _self.studentProfile : studentProfile // ignore: cast_nullable_to_non_nullable
as StudentProfileModel?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentProfileState].
extension StudentProfileStatePatterns on StudentProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentProfileState value)  $default,){
final _that = this;
switch (_that) {
case _StudentProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _StudentProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  StudentProfileModel? studentProfile,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProfileState() when $default != null:
return $default(_that.status,_that.studentProfile,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  StudentProfileModel? studentProfile,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _StudentProfileState():
return $default(_that.status,_that.studentProfile,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  StudentProfileModel? studentProfile,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _StudentProfileState() when $default != null:
return $default(_that.status,_that.studentProfile,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _StudentProfileState implements StudentProfileState {
  const _StudentProfileState({this.status = CubitStatus.initial, this.studentProfile = null, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override@JsonKey() final  StudentProfileModel? studentProfile;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of StudentProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentProfileStateCopyWith<_StudentProfileState> get copyWith => __$StudentProfileStateCopyWithImpl<_StudentProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.studentProfile, studentProfile) || other.studentProfile == studentProfile)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,studentProfile,apiErrorModel);

@override
String toString() {
  return 'StudentProfileState(status: $status, studentProfile: $studentProfile, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$StudentProfileStateCopyWith<$Res> implements $StudentProfileStateCopyWith<$Res> {
  factory _$StudentProfileStateCopyWith(_StudentProfileState value, $Res Function(_StudentProfileState) _then) = __$StudentProfileStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, StudentProfileModel? studentProfile, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$StudentProfileStateCopyWithImpl<$Res>
    implements _$StudentProfileStateCopyWith<$Res> {
  __$StudentProfileStateCopyWithImpl(this._self, this._then);

  final _StudentProfileState _self;
  final $Res Function(_StudentProfileState) _then;

/// Create a copy of StudentProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? studentProfile = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_StudentProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,studentProfile: freezed == studentProfile ? _self.studentProfile : studentProfile // ignore: cast_nullable_to_non_nullable
as StudentProfileModel?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
