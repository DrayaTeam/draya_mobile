// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherDashboardState {

 CubitStatus get status; CubitStatus get pendingReviewsStatus; TeacherDashboardModel? get teacherDashboardModel; List<ClassroomPendingReviewsModel> get pendingReviews; ApiErrorModel? get apiErrorModel;
/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherDashboardStateCopyWith<TeacherDashboardState> get copyWith => _$TeacherDashboardStateCopyWithImpl<TeacherDashboardState>(this as TeacherDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherDashboardState&&(identical(other.status, status) || other.status == status)&&(identical(other.pendingReviewsStatus, pendingReviewsStatus) || other.pendingReviewsStatus == pendingReviewsStatus)&&(identical(other.teacherDashboardModel, teacherDashboardModel) || other.teacherDashboardModel == teacherDashboardModel)&&const DeepCollectionEquality().equals(other.pendingReviews, pendingReviews)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,pendingReviewsStatus,teacherDashboardModel,const DeepCollectionEquality().hash(pendingReviews),apiErrorModel);

@override
String toString() {
  return 'TeacherDashboardState(status: $status, pendingReviewsStatus: $pendingReviewsStatus, teacherDashboardModel: $teacherDashboardModel, pendingReviews: $pendingReviews, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $TeacherDashboardStateCopyWith<$Res>  {
  factory $TeacherDashboardStateCopyWith(TeacherDashboardState value, $Res Function(TeacherDashboardState) _then) = _$TeacherDashboardStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, CubitStatus pendingReviewsStatus, TeacherDashboardModel? teacherDashboardModel, List<ClassroomPendingReviewsModel> pendingReviews, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$TeacherDashboardStateCopyWithImpl<$Res>
    implements $TeacherDashboardStateCopyWith<$Res> {
  _$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final TeacherDashboardState _self;
  final $Res Function(TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? pendingReviewsStatus = null,Object? teacherDashboardModel = freezed,Object? pendingReviews = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,pendingReviewsStatus: null == pendingReviewsStatus ? _self.pendingReviewsStatus : pendingReviewsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,teacherDashboardModel: freezed == teacherDashboardModel ? _self.teacherDashboardModel : teacherDashboardModel // ignore: cast_nullable_to_non_nullable
as TeacherDashboardModel?,pendingReviews: null == pendingReviews ? _self.pendingReviews : pendingReviews // ignore: cast_nullable_to_non_nullable
as List<ClassroomPendingReviewsModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherDashboardState].
extension TeacherDashboardStatePatterns on TeacherDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  CubitStatus pendingReviewsStatus,  TeacherDashboardModel? teacherDashboardModel,  List<ClassroomPendingReviewsModel> pendingReviews,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.status,_that.pendingReviewsStatus,_that.teacherDashboardModel,_that.pendingReviews,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  CubitStatus pendingReviewsStatus,  TeacherDashboardModel? teacherDashboardModel,  List<ClassroomPendingReviewsModel> pendingReviews,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState():
return $default(_that.status,_that.pendingReviewsStatus,_that.teacherDashboardModel,_that.pendingReviews,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  CubitStatus pendingReviewsStatus,  TeacherDashboardModel? teacherDashboardModel,  List<ClassroomPendingReviewsModel> pendingReviews,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.status,_that.pendingReviewsStatus,_that.teacherDashboardModel,_that.pendingReviews,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherDashboardState implements TeacherDashboardState {
  const _TeacherDashboardState({this.status = CubitStatus.initial, this.pendingReviewsStatus = CubitStatus.initial, this.teacherDashboardModel, final  List<ClassroomPendingReviewsModel> pendingReviews = const [], this.apiErrorModel}): _pendingReviews = pendingReviews;
  

@override@JsonKey() final  CubitStatus status;
@override@JsonKey() final  CubitStatus pendingReviewsStatus;
@override final  TeacherDashboardModel? teacherDashboardModel;
 final  List<ClassroomPendingReviewsModel> _pendingReviews;
@override@JsonKey() List<ClassroomPendingReviewsModel> get pendingReviews {
  if (_pendingReviews is EqualUnmodifiableListView) return _pendingReviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingReviews);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherDashboardStateCopyWith<_TeacherDashboardState> get copyWith => __$TeacherDashboardStateCopyWithImpl<_TeacherDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherDashboardState&&(identical(other.status, status) || other.status == status)&&(identical(other.pendingReviewsStatus, pendingReviewsStatus) || other.pendingReviewsStatus == pendingReviewsStatus)&&(identical(other.teacherDashboardModel, teacherDashboardModel) || other.teacherDashboardModel == teacherDashboardModel)&&const DeepCollectionEquality().equals(other._pendingReviews, _pendingReviews)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,pendingReviewsStatus,teacherDashboardModel,const DeepCollectionEquality().hash(_pendingReviews),apiErrorModel);

@override
String toString() {
  return 'TeacherDashboardState(status: $status, pendingReviewsStatus: $pendingReviewsStatus, teacherDashboardModel: $teacherDashboardModel, pendingReviews: $pendingReviews, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$TeacherDashboardStateCopyWith<$Res> implements $TeacherDashboardStateCopyWith<$Res> {
  factory _$TeacherDashboardStateCopyWith(_TeacherDashboardState value, $Res Function(_TeacherDashboardState) _then) = __$TeacherDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, CubitStatus pendingReviewsStatus, TeacherDashboardModel? teacherDashboardModel, List<ClassroomPendingReviewsModel> pendingReviews, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$TeacherDashboardStateCopyWithImpl<$Res>
    implements _$TeacherDashboardStateCopyWith<$Res> {
  __$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final _TeacherDashboardState _self;
  final $Res Function(_TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? pendingReviewsStatus = null,Object? teacherDashboardModel = freezed,Object? pendingReviews = null,Object? apiErrorModel = freezed,}) {
  return _then(_TeacherDashboardState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,pendingReviewsStatus: null == pendingReviewsStatus ? _self.pendingReviewsStatus : pendingReviewsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,teacherDashboardModel: freezed == teacherDashboardModel ? _self.teacherDashboardModel : teacherDashboardModel // ignore: cast_nullable_to_non_nullable
as TeacherDashboardModel?,pendingReviews: null == pendingReviews ? _self._pendingReviews : pendingReviews // ignore: cast_nullable_to_non_nullable
as List<ClassroomPendingReviewsModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
