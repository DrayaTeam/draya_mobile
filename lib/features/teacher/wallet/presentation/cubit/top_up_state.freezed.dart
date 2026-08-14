// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'top_up_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TopUpState {

 CubitStatus get status; TopUpResponseModel? get topUpResponseModel; ApiErrorModel? get apiErrorModel;
/// Create a copy of TopUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopUpStateCopyWith<TopUpState> get copyWith => _$TopUpStateCopyWithImpl<TopUpState>(this as TopUpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopUpState&&(identical(other.status, status) || other.status == status)&&(identical(other.topUpResponseModel, topUpResponseModel) || other.topUpResponseModel == topUpResponseModel)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,topUpResponseModel,apiErrorModel);

@override
String toString() {
  return 'TopUpState(status: $status, topUpResponseModel: $topUpResponseModel, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $TopUpStateCopyWith<$Res>  {
  factory $TopUpStateCopyWith(TopUpState value, $Res Function(TopUpState) _then) = _$TopUpStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, TopUpResponseModel? topUpResponseModel, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$TopUpStateCopyWithImpl<$Res>
    implements $TopUpStateCopyWith<$Res> {
  _$TopUpStateCopyWithImpl(this._self, this._then);

  final TopUpState _self;
  final $Res Function(TopUpState) _then;

/// Create a copy of TopUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? topUpResponseModel = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,topUpResponseModel: freezed == topUpResponseModel ? _self.topUpResponseModel : topUpResponseModel // ignore: cast_nullable_to_non_nullable
as TopUpResponseModel?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [TopUpState].
extension TopUpStatePatterns on TopUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopUpState value)  $default,){
final _that = this;
switch (_that) {
case _TopUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopUpState value)?  $default,){
final _that = this;
switch (_that) {
case _TopUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  TopUpResponseModel? topUpResponseModel,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopUpState() when $default != null:
return $default(_that.status,_that.topUpResponseModel,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  TopUpResponseModel? topUpResponseModel,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _TopUpState():
return $default(_that.status,_that.topUpResponseModel,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  TopUpResponseModel? topUpResponseModel,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _TopUpState() when $default != null:
return $default(_that.status,_that.topUpResponseModel,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _TopUpState implements TopUpState {
  const _TopUpState({this.status = CubitStatus.initial, this.topUpResponseModel, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override final  TopUpResponseModel? topUpResponseModel;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of TopUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopUpStateCopyWith<_TopUpState> get copyWith => __$TopUpStateCopyWithImpl<_TopUpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopUpState&&(identical(other.status, status) || other.status == status)&&(identical(other.topUpResponseModel, topUpResponseModel) || other.topUpResponseModel == topUpResponseModel)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,topUpResponseModel,apiErrorModel);

@override
String toString() {
  return 'TopUpState(status: $status, topUpResponseModel: $topUpResponseModel, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$TopUpStateCopyWith<$Res> implements $TopUpStateCopyWith<$Res> {
  factory _$TopUpStateCopyWith(_TopUpState value, $Res Function(_TopUpState) _then) = __$TopUpStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, TopUpResponseModel? topUpResponseModel, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$TopUpStateCopyWithImpl<$Res>
    implements _$TopUpStateCopyWith<$Res> {
  __$TopUpStateCopyWithImpl(this._self, this._then);

  final _TopUpState _self;
  final $Res Function(_TopUpState) _then;

/// Create a copy of TopUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? topUpResponseModel = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_TopUpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,topUpResponseModel: freezed == topUpResponseModel ? _self.topUpResponseModel : topUpResponseModel // ignore: cast_nullable_to_non_nullable
as TopUpResponseModel?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
