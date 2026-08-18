// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'materials_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MaterialsState {

 CubitStatus get getMaterialsStatus; CubitStatus get uploadMaterialsStatus; TeacherMaterialPagedResultModel? get teacherMaterialPagedResultModel; ApiErrorModel? get apiErrorModel;
/// Create a copy of MaterialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialsStateCopyWith<MaterialsState> get copyWith => _$MaterialsStateCopyWithImpl<MaterialsState>(this as MaterialsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialsState&&(identical(other.getMaterialsStatus, getMaterialsStatus) || other.getMaterialsStatus == getMaterialsStatus)&&(identical(other.uploadMaterialsStatus, uploadMaterialsStatus) || other.uploadMaterialsStatus == uploadMaterialsStatus)&&(identical(other.teacherMaterialPagedResultModel, teacherMaterialPagedResultModel) || other.teacherMaterialPagedResultModel == teacherMaterialPagedResultModel)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,getMaterialsStatus,uploadMaterialsStatus,teacherMaterialPagedResultModel,apiErrorModel);

@override
String toString() {
  return 'MaterialsState(getMaterialsStatus: $getMaterialsStatus, uploadMaterialsStatus: $uploadMaterialsStatus, teacherMaterialPagedResultModel: $teacherMaterialPagedResultModel, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $MaterialsStateCopyWith<$Res>  {
  factory $MaterialsStateCopyWith(MaterialsState value, $Res Function(MaterialsState) _then) = _$MaterialsStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus getMaterialsStatus, CubitStatus uploadMaterialsStatus, TeacherMaterialPagedResultModel? teacherMaterialPagedResultModel, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$MaterialsStateCopyWithImpl<$Res>
    implements $MaterialsStateCopyWith<$Res> {
  _$MaterialsStateCopyWithImpl(this._self, this._then);

  final MaterialsState _self;
  final $Res Function(MaterialsState) _then;

/// Create a copy of MaterialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? getMaterialsStatus = null,Object? uploadMaterialsStatus = null,Object? teacherMaterialPagedResultModel = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
getMaterialsStatus: null == getMaterialsStatus ? _self.getMaterialsStatus : getMaterialsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,uploadMaterialsStatus: null == uploadMaterialsStatus ? _self.uploadMaterialsStatus : uploadMaterialsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,teacherMaterialPagedResultModel: freezed == teacherMaterialPagedResultModel ? _self.teacherMaterialPagedResultModel : teacherMaterialPagedResultModel // ignore: cast_nullable_to_non_nullable
as TeacherMaterialPagedResultModel?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaterialsState].
extension MaterialsStatePatterns on MaterialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialsState value)  $default,){
final _that = this;
switch (_that) {
case _MaterialsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialsState value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus getMaterialsStatus,  CubitStatus uploadMaterialsStatus,  TeacherMaterialPagedResultModel? teacherMaterialPagedResultModel,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialsState() when $default != null:
return $default(_that.getMaterialsStatus,_that.uploadMaterialsStatus,_that.teacherMaterialPagedResultModel,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus getMaterialsStatus,  CubitStatus uploadMaterialsStatus,  TeacherMaterialPagedResultModel? teacherMaterialPagedResultModel,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _MaterialsState():
return $default(_that.getMaterialsStatus,_that.uploadMaterialsStatus,_that.teacherMaterialPagedResultModel,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus getMaterialsStatus,  CubitStatus uploadMaterialsStatus,  TeacherMaterialPagedResultModel? teacherMaterialPagedResultModel,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _MaterialsState() when $default != null:
return $default(_that.getMaterialsStatus,_that.uploadMaterialsStatus,_that.teacherMaterialPagedResultModel,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _MaterialsState implements MaterialsState {
  const _MaterialsState({this.getMaterialsStatus = CubitStatus.initial, this.uploadMaterialsStatus = CubitStatus.initial, this.teacherMaterialPagedResultModel, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus getMaterialsStatus;
@override@JsonKey() final  CubitStatus uploadMaterialsStatus;
@override final  TeacherMaterialPagedResultModel? teacherMaterialPagedResultModel;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of MaterialsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialsStateCopyWith<_MaterialsState> get copyWith => __$MaterialsStateCopyWithImpl<_MaterialsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialsState&&(identical(other.getMaterialsStatus, getMaterialsStatus) || other.getMaterialsStatus == getMaterialsStatus)&&(identical(other.uploadMaterialsStatus, uploadMaterialsStatus) || other.uploadMaterialsStatus == uploadMaterialsStatus)&&(identical(other.teacherMaterialPagedResultModel, teacherMaterialPagedResultModel) || other.teacherMaterialPagedResultModel == teacherMaterialPagedResultModel)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,getMaterialsStatus,uploadMaterialsStatus,teacherMaterialPagedResultModel,apiErrorModel);

@override
String toString() {
  return 'MaterialsState(getMaterialsStatus: $getMaterialsStatus, uploadMaterialsStatus: $uploadMaterialsStatus, teacherMaterialPagedResultModel: $teacherMaterialPagedResultModel, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$MaterialsStateCopyWith<$Res> implements $MaterialsStateCopyWith<$Res> {
  factory _$MaterialsStateCopyWith(_MaterialsState value, $Res Function(_MaterialsState) _then) = __$MaterialsStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus getMaterialsStatus, CubitStatus uploadMaterialsStatus, TeacherMaterialPagedResultModel? teacherMaterialPagedResultModel, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$MaterialsStateCopyWithImpl<$Res>
    implements _$MaterialsStateCopyWith<$Res> {
  __$MaterialsStateCopyWithImpl(this._self, this._then);

  final _MaterialsState _self;
  final $Res Function(_MaterialsState) _then;

/// Create a copy of MaterialsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? getMaterialsStatus = null,Object? uploadMaterialsStatus = null,Object? teacherMaterialPagedResultModel = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_MaterialsState(
getMaterialsStatus: null == getMaterialsStatus ? _self.getMaterialsStatus : getMaterialsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,uploadMaterialsStatus: null == uploadMaterialsStatus ? _self.uploadMaterialsStatus : uploadMaterialsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,teacherMaterialPagedResultModel: freezed == teacherMaterialPagedResultModel ? _self.teacherMaterialPagedResultModel : teacherMaterialPagedResultModel // ignore: cast_nullable_to_non_nullable
as TeacherMaterialPagedResultModel?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
