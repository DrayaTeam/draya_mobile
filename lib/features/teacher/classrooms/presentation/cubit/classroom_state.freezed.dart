// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassroomState {

 CubitStatus get status; List<ClassroomModel> get classrooms; ApiErrorModel? get apiErrorModel;
/// Create a copy of ClassroomState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomStateCopyWith<ClassroomState> get copyWith => _$ClassroomStateCopyWithImpl<ClassroomState>(this as ClassroomState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.classrooms, classrooms)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(classrooms),apiErrorModel);

@override
String toString() {
  return 'ClassroomState(status: $status, classrooms: $classrooms, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $ClassroomStateCopyWith<$Res>  {
  factory $ClassroomStateCopyWith(ClassroomState value, $Res Function(ClassroomState) _then) = _$ClassroomStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<ClassroomModel> classrooms, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$ClassroomStateCopyWithImpl<$Res>
    implements $ClassroomStateCopyWith<$Res> {
  _$ClassroomStateCopyWithImpl(this._self, this._then);

  final ClassroomState _self;
  final $Res Function(ClassroomState) _then;

/// Create a copy of ClassroomState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? classrooms = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,classrooms: null == classrooms ? _self.classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<ClassroomModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassroomState].
extension ClassroomStatePatterns on ClassroomState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomState value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomState value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<ClassroomModel> classrooms,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomState() when $default != null:
return $default(_that.status,_that.classrooms,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<ClassroomModel> classrooms,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _ClassroomState():
return $default(_that.status,_that.classrooms,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<ClassroomModel> classrooms,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomState() when $default != null:
return $default(_that.status,_that.classrooms,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _ClassroomState implements ClassroomState {
  const _ClassroomState({this.status = CubitStatus.initial, final  List<ClassroomModel> classrooms = const [], this.apiErrorModel}): _classrooms = classrooms;
  

@override@JsonKey() final  CubitStatus status;
 final  List<ClassroomModel> _classrooms;
@override@JsonKey() List<ClassroomModel> get classrooms {
  if (_classrooms is EqualUnmodifiableListView) return _classrooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classrooms);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of ClassroomState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomStateCopyWith<_ClassroomState> get copyWith => __$ClassroomStateCopyWithImpl<_ClassroomState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._classrooms, _classrooms)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_classrooms),apiErrorModel);

@override
String toString() {
  return 'ClassroomState(status: $status, classrooms: $classrooms, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$ClassroomStateCopyWith<$Res> implements $ClassroomStateCopyWith<$Res> {
  factory _$ClassroomStateCopyWith(_ClassroomState value, $Res Function(_ClassroomState) _then) = __$ClassroomStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<ClassroomModel> classrooms, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$ClassroomStateCopyWithImpl<$Res>
    implements _$ClassroomStateCopyWith<$Res> {
  __$ClassroomStateCopyWithImpl(this._self, this._then);

  final _ClassroomState _self;
  final $Res Function(_ClassroomState) _then;

/// Create a copy of ClassroomState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? classrooms = null,Object? apiErrorModel = freezed,}) {
  return _then(_ClassroomState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,classrooms: null == classrooms ? _self._classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<ClassroomModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
