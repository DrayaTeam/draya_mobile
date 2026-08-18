// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherProfileState {

 CubitStatus get status; TeacherModel? get teacher; bool get isUploadingPicture; ApiErrorModel? get apiErrorModel;
/// Create a copy of TeacherProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherProfileStateCopyWith<TeacherProfileState> get copyWith => _$TeacherProfileStateCopyWithImpl<TeacherProfileState>(this as TeacherProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.isUploadingPicture, isUploadingPicture) || other.isUploadingPicture == isUploadingPicture)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,teacher,isUploadingPicture,apiErrorModel);

@override
String toString() {
  return 'TeacherProfileState(status: $status, teacher: $teacher, isUploadingPicture: $isUploadingPicture, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $TeacherProfileStateCopyWith<$Res>  {
  factory $TeacherProfileStateCopyWith(TeacherProfileState value, $Res Function(TeacherProfileState) _then) = _$TeacherProfileStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, TeacherModel? teacher, bool isUploadingPicture, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$TeacherProfileStateCopyWithImpl<$Res>
    implements $TeacherProfileStateCopyWith<$Res> {
  _$TeacherProfileStateCopyWithImpl(this._self, this._then);

  final TeacherProfileState _self;
  final $Res Function(TeacherProfileState) _then;

/// Create a copy of TeacherProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? teacher = freezed,Object? isUploadingPicture = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as TeacherModel?,isUploadingPicture: null == isUploadingPicture ? _self.isUploadingPicture : isUploadingPicture // ignore: cast_nullable_to_non_nullable
as bool,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherProfileState].
extension TeacherProfileStatePatterns on TeacherProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherProfileState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  TeacherModel? teacher,  bool isUploadingPicture,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherProfileState() when $default != null:
return $default(_that.status,_that.teacher,_that.isUploadingPicture,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  TeacherModel? teacher,  bool isUploadingPicture,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _TeacherProfileState():
return $default(_that.status,_that.teacher,_that.isUploadingPicture,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  TeacherModel? teacher,  bool isUploadingPicture,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _TeacherProfileState() when $default != null:
return $default(_that.status,_that.teacher,_that.isUploadingPicture,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherProfileState implements TeacherProfileState {
  const _TeacherProfileState({this.status = CubitStatus.initial, this.teacher = null, this.isUploadingPicture = false, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override@JsonKey() final  TeacherModel? teacher;
@override@JsonKey() final  bool isUploadingPicture;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of TeacherProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherProfileStateCopyWith<_TeacherProfileState> get copyWith => __$TeacherProfileStateCopyWithImpl<_TeacherProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.isUploadingPicture, isUploadingPicture) || other.isUploadingPicture == isUploadingPicture)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,teacher,isUploadingPicture,apiErrorModel);

@override
String toString() {
  return 'TeacherProfileState(status: $status, teacher: $teacher, isUploadingPicture: $isUploadingPicture, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$TeacherProfileStateCopyWith<$Res> implements $TeacherProfileStateCopyWith<$Res> {
  factory _$TeacherProfileStateCopyWith(_TeacherProfileState value, $Res Function(_TeacherProfileState) _then) = __$TeacherProfileStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, TeacherModel? teacher, bool isUploadingPicture, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$TeacherProfileStateCopyWithImpl<$Res>
    implements _$TeacherProfileStateCopyWith<$Res> {
  __$TeacherProfileStateCopyWithImpl(this._self, this._then);

  final _TeacherProfileState _self;
  final $Res Function(_TeacherProfileState) _then;

/// Create a copy of TeacherProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? teacher = freezed,Object? isUploadingPicture = null,Object? apiErrorModel = freezed,}) {
  return _then(_TeacherProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as TeacherModel?,isUploadingPicture: null == isUploadingPicture ? _self.isUploadingPicture : isUploadingPicture // ignore: cast_nullable_to_non_nullable
as bool,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
