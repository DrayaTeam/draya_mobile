// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudentHomeState {

 CubitStatus get status; StudentDashboard? get studentDashboard; ApiErrorModel? get apiErrorModel;
/// Create a copy of StudentHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentHomeStateCopyWith<StudentHomeState> get copyWith => _$StudentHomeStateCopyWithImpl<StudentHomeState>(this as StudentHomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentHomeState&&(identical(other.status, status) || other.status == status)&&(identical(other.studentDashboard, studentDashboard) || other.studentDashboard == studentDashboard)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,studentDashboard,apiErrorModel);

@override
String toString() {
  return 'StudentHomeState(status: $status, studentDashboard: $studentDashboard, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $StudentHomeStateCopyWith<$Res>  {
  factory $StudentHomeStateCopyWith(StudentHomeState value, $Res Function(StudentHomeState) _then) = _$StudentHomeStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, StudentDashboard? studentDashboard, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$StudentHomeStateCopyWithImpl<$Res>
    implements $StudentHomeStateCopyWith<$Res> {
  _$StudentHomeStateCopyWithImpl(this._self, this._then);

  final StudentHomeState _self;
  final $Res Function(StudentHomeState) _then;

/// Create a copy of StudentHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? studentDashboard = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,studentDashboard: freezed == studentDashboard ? _self.studentDashboard : studentDashboard // ignore: cast_nullable_to_non_nullable
as StudentDashboard?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentHomeState].
extension StudentHomeStatePatterns on StudentHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentHomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentHomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentHomeState value)  $default,){
final _that = this;
switch (_that) {
case _StudentHomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentHomeState value)?  $default,){
final _that = this;
switch (_that) {
case _StudentHomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  StudentDashboard? studentDashboard,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentHomeState() when $default != null:
return $default(_that.status,_that.studentDashboard,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  StudentDashboard? studentDashboard,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _StudentHomeState():
return $default(_that.status,_that.studentDashboard,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  StudentDashboard? studentDashboard,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _StudentHomeState() when $default != null:
return $default(_that.status,_that.studentDashboard,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _StudentHomeState implements StudentHomeState {
  const _StudentHomeState({this.status = CubitStatus.initial, this.studentDashboard, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override final  StudentDashboard? studentDashboard;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of StudentHomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentHomeStateCopyWith<_StudentHomeState> get copyWith => __$StudentHomeStateCopyWithImpl<_StudentHomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentHomeState&&(identical(other.status, status) || other.status == status)&&(identical(other.studentDashboard, studentDashboard) || other.studentDashboard == studentDashboard)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,studentDashboard,apiErrorModel);

@override
String toString() {
  return 'StudentHomeState(status: $status, studentDashboard: $studentDashboard, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$StudentHomeStateCopyWith<$Res> implements $StudentHomeStateCopyWith<$Res> {
  factory _$StudentHomeStateCopyWith(_StudentHomeState value, $Res Function(_StudentHomeState) _then) = __$StudentHomeStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, StudentDashboard? studentDashboard, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$StudentHomeStateCopyWithImpl<$Res>
    implements _$StudentHomeStateCopyWith<$Res> {
  __$StudentHomeStateCopyWithImpl(this._self, this._then);

  final _StudentHomeState _self;
  final $Res Function(_StudentHomeState) _then;

/// Create a copy of StudentHomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? studentDashboard = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_StudentHomeState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,studentDashboard: freezed == studentDashboard ? _self.studentDashboard : studentDashboard // ignore: cast_nullable_to_non_nullable
as StudentDashboard?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
