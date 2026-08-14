// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_levels_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GradeLevelsState {

 CubitStatus get status; List<GradeLevelModel> get gradeLevels; ApiErrorModel? get apiErrorModel;
/// Create a copy of GradeLevelsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradeLevelsStateCopyWith<GradeLevelsState> get copyWith => _$GradeLevelsStateCopyWithImpl<GradeLevelsState>(this as GradeLevelsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradeLevelsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.gradeLevels, gradeLevels)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(gradeLevels),apiErrorModel);

@override
String toString() {
  return 'GradeLevelsState(status: $status, gradeLevels: $gradeLevels, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $GradeLevelsStateCopyWith<$Res>  {
  factory $GradeLevelsStateCopyWith(GradeLevelsState value, $Res Function(GradeLevelsState) _then) = _$GradeLevelsStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<GradeLevelModel> gradeLevels, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$GradeLevelsStateCopyWithImpl<$Res>
    implements $GradeLevelsStateCopyWith<$Res> {
  _$GradeLevelsStateCopyWithImpl(this._self, this._then);

  final GradeLevelsState _self;
  final $Res Function(GradeLevelsState) _then;

/// Create a copy of GradeLevelsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? gradeLevels = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,gradeLevels: null == gradeLevels ? _self.gradeLevels : gradeLevels // ignore: cast_nullable_to_non_nullable
as List<GradeLevelModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [GradeLevelsState].
extension GradeLevelsStatePatterns on GradeLevelsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradeLevelsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradeLevelsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradeLevelsState value)  $default,){
final _that = this;
switch (_that) {
case _GradeLevelsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradeLevelsState value)?  $default,){
final _that = this;
switch (_that) {
case _GradeLevelsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<GradeLevelModel> gradeLevels,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradeLevelsState() when $default != null:
return $default(_that.status,_that.gradeLevels,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<GradeLevelModel> gradeLevels,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _GradeLevelsState():
return $default(_that.status,_that.gradeLevels,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<GradeLevelModel> gradeLevels,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _GradeLevelsState() when $default != null:
return $default(_that.status,_that.gradeLevels,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _GradeLevelsState implements GradeLevelsState {
  const _GradeLevelsState({this.status = CubitStatus.initial, final  List<GradeLevelModel> gradeLevels = const [], this.apiErrorModel}): _gradeLevels = gradeLevels;
  

@override@JsonKey() final  CubitStatus status;
 final  List<GradeLevelModel> _gradeLevels;
@override@JsonKey() List<GradeLevelModel> get gradeLevels {
  if (_gradeLevels is EqualUnmodifiableListView) return _gradeLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gradeLevels);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of GradeLevelsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradeLevelsStateCopyWith<_GradeLevelsState> get copyWith => __$GradeLevelsStateCopyWithImpl<_GradeLevelsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradeLevelsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._gradeLevels, _gradeLevels)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_gradeLevels),apiErrorModel);

@override
String toString() {
  return 'GradeLevelsState(status: $status, gradeLevels: $gradeLevels, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$GradeLevelsStateCopyWith<$Res> implements $GradeLevelsStateCopyWith<$Res> {
  factory _$GradeLevelsStateCopyWith(_GradeLevelsState value, $Res Function(_GradeLevelsState) _then) = __$GradeLevelsStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<GradeLevelModel> gradeLevels, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$GradeLevelsStateCopyWithImpl<$Res>
    implements _$GradeLevelsStateCopyWith<$Res> {
  __$GradeLevelsStateCopyWithImpl(this._self, this._then);

  final _GradeLevelsState _self;
  final $Res Function(_GradeLevelsState) _then;

/// Create a copy of GradeLevelsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? gradeLevels = null,Object? apiErrorModel = freezed,}) {
  return _then(_GradeLevelsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,gradeLevels: null == gradeLevels ? _self._gradeLevels : gradeLevels // ignore: cast_nullable_to_non_nullable
as List<GradeLevelModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
