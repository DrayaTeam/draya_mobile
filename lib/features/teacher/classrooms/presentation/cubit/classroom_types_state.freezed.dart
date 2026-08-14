// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_types_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassroomTypesState {

 CubitStatus get status; List<ClassroomTypeModel> get classroomTypes; ApiErrorModel? get apiErrorModel;
/// Create a copy of ClassroomTypesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomTypesStateCopyWith<ClassroomTypesState> get copyWith => _$ClassroomTypesStateCopyWithImpl<ClassroomTypesState>(this as ClassroomTypesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomTypesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.classroomTypes, classroomTypes)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(classroomTypes),apiErrorModel);

@override
String toString() {
  return 'ClassroomTypesState(status: $status, classroomTypes: $classroomTypes, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $ClassroomTypesStateCopyWith<$Res>  {
  factory $ClassroomTypesStateCopyWith(ClassroomTypesState value, $Res Function(ClassroomTypesState) _then) = _$ClassroomTypesStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<ClassroomTypeModel> classroomTypes, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$ClassroomTypesStateCopyWithImpl<$Res>
    implements $ClassroomTypesStateCopyWith<$Res> {
  _$ClassroomTypesStateCopyWithImpl(this._self, this._then);

  final ClassroomTypesState _self;
  final $Res Function(ClassroomTypesState) _then;

/// Create a copy of ClassroomTypesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? classroomTypes = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,classroomTypes: null == classroomTypes ? _self.classroomTypes : classroomTypes // ignore: cast_nullable_to_non_nullable
as List<ClassroomTypeModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassroomTypesState].
extension ClassroomTypesStatePatterns on ClassroomTypesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomTypesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomTypesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomTypesState value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomTypesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomTypesState value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomTypesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<ClassroomTypeModel> classroomTypes,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomTypesState() when $default != null:
return $default(_that.status,_that.classroomTypes,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<ClassroomTypeModel> classroomTypes,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _ClassroomTypesState():
return $default(_that.status,_that.classroomTypes,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<ClassroomTypeModel> classroomTypes,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomTypesState() when $default != null:
return $default(_that.status,_that.classroomTypes,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _ClassroomTypesState implements ClassroomTypesState {
  const _ClassroomTypesState({this.status = CubitStatus.initial, final  List<ClassroomTypeModel> classroomTypes = const [], this.apiErrorModel}): _classroomTypes = classroomTypes;
  

@override@JsonKey() final  CubitStatus status;
 final  List<ClassroomTypeModel> _classroomTypes;
@override@JsonKey() List<ClassroomTypeModel> get classroomTypes {
  if (_classroomTypes is EqualUnmodifiableListView) return _classroomTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classroomTypes);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of ClassroomTypesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomTypesStateCopyWith<_ClassroomTypesState> get copyWith => __$ClassroomTypesStateCopyWithImpl<_ClassroomTypesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomTypesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._classroomTypes, _classroomTypes)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_classroomTypes),apiErrorModel);

@override
String toString() {
  return 'ClassroomTypesState(status: $status, classroomTypes: $classroomTypes, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$ClassroomTypesStateCopyWith<$Res> implements $ClassroomTypesStateCopyWith<$Res> {
  factory _$ClassroomTypesStateCopyWith(_ClassroomTypesState value, $Res Function(_ClassroomTypesState) _then) = __$ClassroomTypesStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<ClassroomTypeModel> classroomTypes, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$ClassroomTypesStateCopyWithImpl<$Res>
    implements _$ClassroomTypesStateCopyWith<$Res> {
  __$ClassroomTypesStateCopyWithImpl(this._self, this._then);

  final _ClassroomTypesState _self;
  final $Res Function(_ClassroomTypesState) _then;

/// Create a copy of ClassroomTypesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? classroomTypes = null,Object? apiErrorModel = freezed,}) {
  return _then(_ClassroomTypesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,classroomTypes: null == classroomTypes ? _self._classroomTypes : classroomTypes // ignore: cast_nullable_to_non_nullable
as List<ClassroomTypeModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
