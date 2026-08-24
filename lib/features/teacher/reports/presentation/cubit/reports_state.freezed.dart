// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reports_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportsState {

 Map<String, PerformanceReportModel> get reportsByStudentId; Set<String> get loadingStudentIds; Map<String, ApiErrorModel> get errorsByStudentId; CubitStatus get approveReportStatus; ApiErrorModel? get apiErrorModel;
/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportsStateCopyWith<ReportsState> get copyWith => _$ReportsStateCopyWithImpl<ReportsState>(this as ReportsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsState&&const DeepCollectionEquality().equals(other.reportsByStudentId, reportsByStudentId)&&const DeepCollectionEquality().equals(other.loadingStudentIds, loadingStudentIds)&&const DeepCollectionEquality().equals(other.errorsByStudentId, errorsByStudentId)&&(identical(other.approveReportStatus, approveReportStatus) || other.approveReportStatus == approveReportStatus)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(reportsByStudentId),const DeepCollectionEquality().hash(loadingStudentIds),const DeepCollectionEquality().hash(errorsByStudentId),approveReportStatus,apiErrorModel);

@override
String toString() {
  return 'ReportsState(reportsByStudentId: $reportsByStudentId, loadingStudentIds: $loadingStudentIds, errorsByStudentId: $errorsByStudentId, approveReportStatus: $approveReportStatus, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $ReportsStateCopyWith<$Res>  {
  factory $ReportsStateCopyWith(ReportsState value, $Res Function(ReportsState) _then) = _$ReportsStateCopyWithImpl;
@useResult
$Res call({
 Map<String, PerformanceReportModel> reportsByStudentId, Set<String> loadingStudentIds, Map<String, ApiErrorModel> errorsByStudentId, CubitStatus approveReportStatus, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$ReportsStateCopyWithImpl<$Res>
    implements $ReportsStateCopyWith<$Res> {
  _$ReportsStateCopyWithImpl(this._self, this._then);

  final ReportsState _self;
  final $Res Function(ReportsState) _then;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportsByStudentId = null,Object? loadingStudentIds = null,Object? errorsByStudentId = null,Object? approveReportStatus = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
reportsByStudentId: null == reportsByStudentId ? _self.reportsByStudentId : reportsByStudentId // ignore: cast_nullable_to_non_nullable
as Map<String, PerformanceReportModel>,loadingStudentIds: null == loadingStudentIds ? _self.loadingStudentIds : loadingStudentIds // ignore: cast_nullable_to_non_nullable
as Set<String>,errorsByStudentId: null == errorsByStudentId ? _self.errorsByStudentId : errorsByStudentId // ignore: cast_nullable_to_non_nullable
as Map<String, ApiErrorModel>,approveReportStatus: null == approveReportStatus ? _self.approveReportStatus : approveReportStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportsState].
extension ReportsStatePatterns on ReportsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportsState value)  $default,){
final _that = this;
switch (_that) {
case _ReportsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportsState value)?  $default,){
final _that = this;
switch (_that) {
case _ReportsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, PerformanceReportModel> reportsByStudentId,  Set<String> loadingStudentIds,  Map<String, ApiErrorModel> errorsByStudentId,  CubitStatus approveReportStatus,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportsState() when $default != null:
return $default(_that.reportsByStudentId,_that.loadingStudentIds,_that.errorsByStudentId,_that.approveReportStatus,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, PerformanceReportModel> reportsByStudentId,  Set<String> loadingStudentIds,  Map<String, ApiErrorModel> errorsByStudentId,  CubitStatus approveReportStatus,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _ReportsState():
return $default(_that.reportsByStudentId,_that.loadingStudentIds,_that.errorsByStudentId,_that.approveReportStatus,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, PerformanceReportModel> reportsByStudentId,  Set<String> loadingStudentIds,  Map<String, ApiErrorModel> errorsByStudentId,  CubitStatus approveReportStatus,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _ReportsState() when $default != null:
return $default(_that.reportsByStudentId,_that.loadingStudentIds,_that.errorsByStudentId,_that.approveReportStatus,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _ReportsState implements ReportsState {
  const _ReportsState({final  Map<String, PerformanceReportModel> reportsByStudentId = const {}, final  Set<String> loadingStudentIds = const {}, final  Map<String, ApiErrorModel> errorsByStudentId = const {}, this.approveReportStatus = CubitStatus.initial, this.apiErrorModel}): _reportsByStudentId = reportsByStudentId,_loadingStudentIds = loadingStudentIds,_errorsByStudentId = errorsByStudentId;
  

 final  Map<String, PerformanceReportModel> _reportsByStudentId;
@override@JsonKey() Map<String, PerformanceReportModel> get reportsByStudentId {
  if (_reportsByStudentId is EqualUnmodifiableMapView) return _reportsByStudentId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reportsByStudentId);
}

 final  Set<String> _loadingStudentIds;
@override@JsonKey() Set<String> get loadingStudentIds {
  if (_loadingStudentIds is EqualUnmodifiableSetView) return _loadingStudentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_loadingStudentIds);
}

 final  Map<String, ApiErrorModel> _errorsByStudentId;
@override@JsonKey() Map<String, ApiErrorModel> get errorsByStudentId {
  if (_errorsByStudentId is EqualUnmodifiableMapView) return _errorsByStudentId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errorsByStudentId);
}

@override@JsonKey() final  CubitStatus approveReportStatus;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportsStateCopyWith<_ReportsState> get copyWith => __$ReportsStateCopyWithImpl<_ReportsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportsState&&const DeepCollectionEquality().equals(other._reportsByStudentId, _reportsByStudentId)&&const DeepCollectionEquality().equals(other._loadingStudentIds, _loadingStudentIds)&&const DeepCollectionEquality().equals(other._errorsByStudentId, _errorsByStudentId)&&(identical(other.approveReportStatus, approveReportStatus) || other.approveReportStatus == approveReportStatus)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reportsByStudentId),const DeepCollectionEquality().hash(_loadingStudentIds),const DeepCollectionEquality().hash(_errorsByStudentId),approveReportStatus,apiErrorModel);

@override
String toString() {
  return 'ReportsState(reportsByStudentId: $reportsByStudentId, loadingStudentIds: $loadingStudentIds, errorsByStudentId: $errorsByStudentId, approveReportStatus: $approveReportStatus, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$ReportsStateCopyWith<$Res> implements $ReportsStateCopyWith<$Res> {
  factory _$ReportsStateCopyWith(_ReportsState value, $Res Function(_ReportsState) _then) = __$ReportsStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, PerformanceReportModel> reportsByStudentId, Set<String> loadingStudentIds, Map<String, ApiErrorModel> errorsByStudentId, CubitStatus approveReportStatus, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$ReportsStateCopyWithImpl<$Res>
    implements _$ReportsStateCopyWith<$Res> {
  __$ReportsStateCopyWithImpl(this._self, this._then);

  final _ReportsState _self;
  final $Res Function(_ReportsState) _then;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportsByStudentId = null,Object? loadingStudentIds = null,Object? errorsByStudentId = null,Object? approveReportStatus = null,Object? apiErrorModel = freezed,}) {
  return _then(_ReportsState(
reportsByStudentId: null == reportsByStudentId ? _self._reportsByStudentId : reportsByStudentId // ignore: cast_nullable_to_non_nullable
as Map<String, PerformanceReportModel>,loadingStudentIds: null == loadingStudentIds ? _self._loadingStudentIds : loadingStudentIds // ignore: cast_nullable_to_non_nullable
as Set<String>,errorsByStudentId: null == errorsByStudentId ? _self._errorsByStudentId : errorsByStudentId // ignore: cast_nullable_to_non_nullable
as Map<String, ApiErrorModel>,approveReportStatus: null == approveReportStatus ? _self.approveReportStatus : approveReportStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
