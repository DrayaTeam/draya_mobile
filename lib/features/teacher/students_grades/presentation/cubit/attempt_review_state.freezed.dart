// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attempt_review_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttemptReviewState {

 CubitStatus get status; AttemptReviewResultsModel? get results; Map<String, double> get pendingOverrides; bool get isSubmittingOverride; ApiErrorModel? get apiErrorModel;
/// Create a copy of AttemptReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttemptReviewStateCopyWith<AttemptReviewState> get copyWith => _$AttemptReviewStateCopyWithImpl<AttemptReviewState>(this as AttemptReviewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttemptReviewState&&(identical(other.status, status) || other.status == status)&&(identical(other.results, results) || other.results == results)&&const DeepCollectionEquality().equals(other.pendingOverrides, pendingOverrides)&&(identical(other.isSubmittingOverride, isSubmittingOverride) || other.isSubmittingOverride == isSubmittingOverride)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,results,const DeepCollectionEquality().hash(pendingOverrides),isSubmittingOverride,apiErrorModel);

@override
String toString() {
  return 'AttemptReviewState(status: $status, results: $results, pendingOverrides: $pendingOverrides, isSubmittingOverride: $isSubmittingOverride, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $AttemptReviewStateCopyWith<$Res>  {
  factory $AttemptReviewStateCopyWith(AttemptReviewState value, $Res Function(AttemptReviewState) _then) = _$AttemptReviewStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, AttemptReviewResultsModel? results, Map<String, double> pendingOverrides, bool isSubmittingOverride, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$AttemptReviewStateCopyWithImpl<$Res>
    implements $AttemptReviewStateCopyWith<$Res> {
  _$AttemptReviewStateCopyWithImpl(this._self, this._then);

  final AttemptReviewState _self;
  final $Res Function(AttemptReviewState) _then;

/// Create a copy of AttemptReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? results = freezed,Object? pendingOverrides = null,Object? isSubmittingOverride = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as AttemptReviewResultsModel?,pendingOverrides: null == pendingOverrides ? _self.pendingOverrides : pendingOverrides // ignore: cast_nullable_to_non_nullable
as Map<String, double>,isSubmittingOverride: null == isSubmittingOverride ? _self.isSubmittingOverride : isSubmittingOverride // ignore: cast_nullable_to_non_nullable
as bool,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttemptReviewState].
extension AttemptReviewStatePatterns on AttemptReviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttemptReviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttemptReviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttemptReviewState value)  $default,){
final _that = this;
switch (_that) {
case _AttemptReviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttemptReviewState value)?  $default,){
final _that = this;
switch (_that) {
case _AttemptReviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  AttemptReviewResultsModel? results,  Map<String, double> pendingOverrides,  bool isSubmittingOverride,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttemptReviewState() when $default != null:
return $default(_that.status,_that.results,_that.pendingOverrides,_that.isSubmittingOverride,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  AttemptReviewResultsModel? results,  Map<String, double> pendingOverrides,  bool isSubmittingOverride,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _AttemptReviewState():
return $default(_that.status,_that.results,_that.pendingOverrides,_that.isSubmittingOverride,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  AttemptReviewResultsModel? results,  Map<String, double> pendingOverrides,  bool isSubmittingOverride,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _AttemptReviewState() when $default != null:
return $default(_that.status,_that.results,_that.pendingOverrides,_that.isSubmittingOverride,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _AttemptReviewState implements AttemptReviewState {
  const _AttemptReviewState({this.status = CubitStatus.initial, this.results, final  Map<String, double> pendingOverrides = const {}, this.isSubmittingOverride = false, this.apiErrorModel}): _pendingOverrides = pendingOverrides;
  

@override@JsonKey() final  CubitStatus status;
@override final  AttemptReviewResultsModel? results;
 final  Map<String, double> _pendingOverrides;
@override@JsonKey() Map<String, double> get pendingOverrides {
  if (_pendingOverrides is EqualUnmodifiableMapView) return _pendingOverrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pendingOverrides);
}

@override@JsonKey() final  bool isSubmittingOverride;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of AttemptReviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttemptReviewStateCopyWith<_AttemptReviewState> get copyWith => __$AttemptReviewStateCopyWithImpl<_AttemptReviewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttemptReviewState&&(identical(other.status, status) || other.status == status)&&(identical(other.results, results) || other.results == results)&&const DeepCollectionEquality().equals(other._pendingOverrides, _pendingOverrides)&&(identical(other.isSubmittingOverride, isSubmittingOverride) || other.isSubmittingOverride == isSubmittingOverride)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,results,const DeepCollectionEquality().hash(_pendingOverrides),isSubmittingOverride,apiErrorModel);

@override
String toString() {
  return 'AttemptReviewState(status: $status, results: $results, pendingOverrides: $pendingOverrides, isSubmittingOverride: $isSubmittingOverride, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$AttemptReviewStateCopyWith<$Res> implements $AttemptReviewStateCopyWith<$Res> {
  factory _$AttemptReviewStateCopyWith(_AttemptReviewState value, $Res Function(_AttemptReviewState) _then) = __$AttemptReviewStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, AttemptReviewResultsModel? results, Map<String, double> pendingOverrides, bool isSubmittingOverride, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$AttemptReviewStateCopyWithImpl<$Res>
    implements _$AttemptReviewStateCopyWith<$Res> {
  __$AttemptReviewStateCopyWithImpl(this._self, this._then);

  final _AttemptReviewState _self;
  final $Res Function(_AttemptReviewState) _then;

/// Create a copy of AttemptReviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? results = freezed,Object? pendingOverrides = null,Object? isSubmittingOverride = null,Object? apiErrorModel = freezed,}) {
  return _then(_AttemptReviewState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as AttemptReviewResultsModel?,pendingOverrides: null == pendingOverrides ? _self._pendingOverrides : pendingOverrides // ignore: cast_nullable_to_non_nullable
as Map<String, double>,isSubmittingOverride: null == isSubmittingOverride ? _self.isSubmittingOverride : isSubmittingOverride // ignore: cast_nullable_to_non_nullable
as bool,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
