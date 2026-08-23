// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_attempts_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamAttemptsState {

 CubitStatus get status; List<ExamAttemptModel> get attempts; int get totalCount; int get currentPage; bool get hasReachedMax; bool get isLoadingMore; ApiErrorModel? get apiErrorModel;
/// Create a copy of ExamAttemptsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamAttemptsStateCopyWith<ExamAttemptsState> get copyWith => _$ExamAttemptsStateCopyWithImpl<ExamAttemptsState>(this as ExamAttemptsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamAttemptsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.attempts, attempts)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(attempts),totalCount,currentPage,hasReachedMax,isLoadingMore,apiErrorModel);

@override
String toString() {
  return 'ExamAttemptsState(status: $status, attempts: $attempts, totalCount: $totalCount, currentPage: $currentPage, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $ExamAttemptsStateCopyWith<$Res>  {
  factory $ExamAttemptsStateCopyWith(ExamAttemptsState value, $Res Function(ExamAttemptsState) _then) = _$ExamAttemptsStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<ExamAttemptModel> attempts, int totalCount, int currentPage, bool hasReachedMax, bool isLoadingMore, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$ExamAttemptsStateCopyWithImpl<$Res>
    implements $ExamAttemptsStateCopyWith<$Res> {
  _$ExamAttemptsStateCopyWithImpl(this._self, this._then);

  final ExamAttemptsState _self;
  final $Res Function(ExamAttemptsState) _then;

/// Create a copy of ExamAttemptsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? attempts = null,Object? totalCount = null,Object? currentPage = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<ExamAttemptModel>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamAttemptsState].
extension ExamAttemptsStatePatterns on ExamAttemptsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamAttemptsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamAttemptsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamAttemptsState value)  $default,){
final _that = this;
switch (_that) {
case _ExamAttemptsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamAttemptsState value)?  $default,){
final _that = this;
switch (_that) {
case _ExamAttemptsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<ExamAttemptModel> attempts,  int totalCount,  int currentPage,  bool hasReachedMax,  bool isLoadingMore,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamAttemptsState() when $default != null:
return $default(_that.status,_that.attempts,_that.totalCount,_that.currentPage,_that.hasReachedMax,_that.isLoadingMore,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<ExamAttemptModel> attempts,  int totalCount,  int currentPage,  bool hasReachedMax,  bool isLoadingMore,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _ExamAttemptsState():
return $default(_that.status,_that.attempts,_that.totalCount,_that.currentPage,_that.hasReachedMax,_that.isLoadingMore,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<ExamAttemptModel> attempts,  int totalCount,  int currentPage,  bool hasReachedMax,  bool isLoadingMore,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _ExamAttemptsState() when $default != null:
return $default(_that.status,_that.attempts,_that.totalCount,_that.currentPage,_that.hasReachedMax,_that.isLoadingMore,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _ExamAttemptsState implements ExamAttemptsState {
  const _ExamAttemptsState({this.status = CubitStatus.initial, final  List<ExamAttemptModel> attempts = const [], this.totalCount = 0, this.currentPage = 1, this.hasReachedMax = false, this.isLoadingMore = false, this.apiErrorModel}): _attempts = attempts;
  

@override@JsonKey() final  CubitStatus status;
 final  List<ExamAttemptModel> _attempts;
@override@JsonKey() List<ExamAttemptModel> get attempts {
  if (_attempts is EqualUnmodifiableListView) return _attempts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attempts);
}

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasReachedMax;
@override@JsonKey() final  bool isLoadingMore;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of ExamAttemptsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamAttemptsStateCopyWith<_ExamAttemptsState> get copyWith => __$ExamAttemptsStateCopyWithImpl<_ExamAttemptsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamAttemptsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._attempts, _attempts)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_attempts),totalCount,currentPage,hasReachedMax,isLoadingMore,apiErrorModel);

@override
String toString() {
  return 'ExamAttemptsState(status: $status, attempts: $attempts, totalCount: $totalCount, currentPage: $currentPage, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$ExamAttemptsStateCopyWith<$Res> implements $ExamAttemptsStateCopyWith<$Res> {
  factory _$ExamAttemptsStateCopyWith(_ExamAttemptsState value, $Res Function(_ExamAttemptsState) _then) = __$ExamAttemptsStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<ExamAttemptModel> attempts, int totalCount, int currentPage, bool hasReachedMax, bool isLoadingMore, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$ExamAttemptsStateCopyWithImpl<$Res>
    implements _$ExamAttemptsStateCopyWith<$Res> {
  __$ExamAttemptsStateCopyWithImpl(this._self, this._then);

  final _ExamAttemptsState _self;
  final $Res Function(_ExamAttemptsState) _then;

/// Create a copy of ExamAttemptsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? attempts = null,Object? totalCount = null,Object? currentPage = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? apiErrorModel = freezed,}) {
  return _then(_ExamAttemptsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,attempts: null == attempts ? _self._attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<ExamAttemptModel>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
