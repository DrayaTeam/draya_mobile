// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherState {

 CubitStatus get status; List<TeacherModel> get teachers; ApiErrorModel? get apiErrorModel;
/// Create a copy of TeacherState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherStateCopyWith<TeacherState> get copyWith => _$TeacherStateCopyWithImpl<TeacherState>(this as TeacherState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.teachers, teachers)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(teachers),apiErrorModel);

@override
String toString() {
  return 'TeacherState(status: $status, teachers: $teachers, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $TeacherStateCopyWith<$Res>  {
  factory $TeacherStateCopyWith(TeacherState value, $Res Function(TeacherState) _then) = _$TeacherStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<TeacherModel> teachers, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$TeacherStateCopyWithImpl<$Res>
    implements $TeacherStateCopyWith<$Res> {
  _$TeacherStateCopyWithImpl(this._self, this._then);

  final TeacherState _self;
  final $Res Function(TeacherState) _then;

/// Create a copy of TeacherState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? teachers = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,teachers: null == teachers ? _self.teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<TeacherModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherState].
extension TeacherStatePatterns on TeacherState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<TeacherModel> teachers,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherState() when $default != null:
return $default(_that.status,_that.teachers,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<TeacherModel> teachers,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _TeacherState():
return $default(_that.status,_that.teachers,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<TeacherModel> teachers,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _TeacherState() when $default != null:
return $default(_that.status,_that.teachers,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherState implements TeacherState {
  const _TeacherState({this.status = CubitStatus.initial, final  List<TeacherModel> teachers = const [], this.apiErrorModel}): _teachers = teachers;
  

@override@JsonKey() final  CubitStatus status;
 final  List<TeacherModel> _teachers;
@override@JsonKey() List<TeacherModel> get teachers {
  if (_teachers is EqualUnmodifiableListView) return _teachers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teachers);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of TeacherState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherStateCopyWith<_TeacherState> get copyWith => __$TeacherStateCopyWithImpl<_TeacherState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._teachers, _teachers)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_teachers),apiErrorModel);

@override
String toString() {
  return 'TeacherState(status: $status, teachers: $teachers, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$TeacherStateCopyWith<$Res> implements $TeacherStateCopyWith<$Res> {
  factory _$TeacherStateCopyWith(_TeacherState value, $Res Function(_TeacherState) _then) = __$TeacherStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<TeacherModel> teachers, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$TeacherStateCopyWithImpl<$Res>
    implements _$TeacherStateCopyWith<$Res> {
  __$TeacherStateCopyWithImpl(this._self, this._then);

  final _TeacherState _self;
  final $Res Function(_TeacherState) _then;

/// Create a copy of TeacherState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? teachers = null,Object? apiErrorModel = freezed,}) {
  return _then(_TeacherState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,teachers: null == teachers ? _self._teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<TeacherModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
