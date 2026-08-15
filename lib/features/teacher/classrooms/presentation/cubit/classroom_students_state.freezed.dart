// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_students_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassroomStudentsState {

 CubitStatus get status; List<StudentRosterItemModel> get students; ApiErrorModel? get apiErrorModel;
/// Create a copy of ClassroomStudentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomStudentsStateCopyWith<ClassroomStudentsState> get copyWith => _$ClassroomStudentsStateCopyWithImpl<ClassroomStudentsState>(this as ClassroomStudentsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomStudentsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.students, students)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(students),apiErrorModel);

@override
String toString() {
  return 'ClassroomStudentsState(status: $status, students: $students, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $ClassroomStudentsStateCopyWith<$Res>  {
  factory $ClassroomStudentsStateCopyWith(ClassroomStudentsState value, $Res Function(ClassroomStudentsState) _then) = _$ClassroomStudentsStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<StudentRosterItemModel> students, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$ClassroomStudentsStateCopyWithImpl<$Res>
    implements $ClassroomStudentsStateCopyWith<$Res> {
  _$ClassroomStudentsStateCopyWithImpl(this._self, this._then);

  final ClassroomStudentsState _self;
  final $Res Function(ClassroomStudentsState) _then;

/// Create a copy of ClassroomStudentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? students = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,students: null == students ? _self.students : students // ignore: cast_nullable_to_non_nullable
as List<StudentRosterItemModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassroomStudentsState].
extension ClassroomStudentsStatePatterns on ClassroomStudentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomStudentsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomStudentsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomStudentsState value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomStudentsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomStudentsState value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomStudentsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<StudentRosterItemModel> students,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomStudentsState() when $default != null:
return $default(_that.status,_that.students,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<StudentRosterItemModel> students,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _ClassroomStudentsState():
return $default(_that.status,_that.students,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<StudentRosterItemModel> students,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomStudentsState() when $default != null:
return $default(_that.status,_that.students,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _ClassroomStudentsState implements ClassroomStudentsState {
  const _ClassroomStudentsState({this.status = CubitStatus.initial, final  List<StudentRosterItemModel> students = const [], this.apiErrorModel}): _students = students;
  

@override@JsonKey() final  CubitStatus status;
 final  List<StudentRosterItemModel> _students;
@override@JsonKey() List<StudentRosterItemModel> get students {
  if (_students is EqualUnmodifiableListView) return _students;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_students);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of ClassroomStudentsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomStudentsStateCopyWith<_ClassroomStudentsState> get copyWith => __$ClassroomStudentsStateCopyWithImpl<_ClassroomStudentsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomStudentsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._students, _students)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_students),apiErrorModel);

@override
String toString() {
  return 'ClassroomStudentsState(status: $status, students: $students, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$ClassroomStudentsStateCopyWith<$Res> implements $ClassroomStudentsStateCopyWith<$Res> {
  factory _$ClassroomStudentsStateCopyWith(_ClassroomStudentsState value, $Res Function(_ClassroomStudentsState) _then) = __$ClassroomStudentsStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<StudentRosterItemModel> students, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$ClassroomStudentsStateCopyWithImpl<$Res>
    implements _$ClassroomStudentsStateCopyWith<$Res> {
  __$ClassroomStudentsStateCopyWithImpl(this._self, this._then);

  final _ClassroomStudentsState _self;
  final $Res Function(_ClassroomStudentsState) _then;

/// Create a copy of ClassroomStudentsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? students = null,Object? apiErrorModel = freezed,}) {
  return _then(_ClassroomStudentsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,students: null == students ? _self._students : students // ignore: cast_nullable_to_non_nullable
as List<StudentRosterItemModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
