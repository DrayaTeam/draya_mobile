// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exams_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamsHistoryState {

 CubitStatus get status; List<StudentExamWithAttempts> get exams; List<StudentEnrolledClassroom> get classrooms; int get totalCount; int get currentPage; bool get hasReachedMax; bool get isLoadingMore; String? get selectedClassroomId; ApiErrorModel? get apiErrorModel;
/// Create a copy of ExamsHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamsHistoryStateCopyWith<ExamsHistoryState> get copyWith => _$ExamsHistoryStateCopyWithImpl<ExamsHistoryState>(this as ExamsHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamsHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.exams, exams)&&const DeepCollectionEquality().equals(other.classrooms, classrooms)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.selectedClassroomId, selectedClassroomId) || other.selectedClassroomId == selectedClassroomId)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(exams),const DeepCollectionEquality().hash(classrooms),totalCount,currentPage,hasReachedMax,isLoadingMore,selectedClassroomId,apiErrorModel);

@override
String toString() {
  return 'ExamsHistoryState(status: $status, exams: $exams, classrooms: $classrooms, totalCount: $totalCount, currentPage: $currentPage, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, selectedClassroomId: $selectedClassroomId, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $ExamsHistoryStateCopyWith<$Res>  {
  factory $ExamsHistoryStateCopyWith(ExamsHistoryState value, $Res Function(ExamsHistoryState) _then) = _$ExamsHistoryStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<StudentExamWithAttempts> exams, List<StudentEnrolledClassroom> classrooms, int totalCount, int currentPage, bool hasReachedMax, bool isLoadingMore, String? selectedClassroomId, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$ExamsHistoryStateCopyWithImpl<$Res>
    implements $ExamsHistoryStateCopyWith<$Res> {
  _$ExamsHistoryStateCopyWithImpl(this._self, this._then);

  final ExamsHistoryState _self;
  final $Res Function(ExamsHistoryState) _then;

/// Create a copy of ExamsHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? exams = null,Object? classrooms = null,Object? totalCount = null,Object? currentPage = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? selectedClassroomId = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,exams: null == exams ? _self.exams : exams // ignore: cast_nullable_to_non_nullable
as List<StudentExamWithAttempts>,classrooms: null == classrooms ? _self.classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<StudentEnrolledClassroom>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,selectedClassroomId: freezed == selectedClassroomId ? _self.selectedClassroomId : selectedClassroomId // ignore: cast_nullable_to_non_nullable
as String?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamsHistoryState].
extension ExamsHistoryStatePatterns on ExamsHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamsHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamsHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamsHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _ExamsHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamsHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _ExamsHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<StudentExamWithAttempts> exams,  List<StudentEnrolledClassroom> classrooms,  int totalCount,  int currentPage,  bool hasReachedMax,  bool isLoadingMore,  String? selectedClassroomId,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamsHistoryState() when $default != null:
return $default(_that.status,_that.exams,_that.classrooms,_that.totalCount,_that.currentPage,_that.hasReachedMax,_that.isLoadingMore,_that.selectedClassroomId,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<StudentExamWithAttempts> exams,  List<StudentEnrolledClassroom> classrooms,  int totalCount,  int currentPage,  bool hasReachedMax,  bool isLoadingMore,  String? selectedClassroomId,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _ExamsHistoryState():
return $default(_that.status,_that.exams,_that.classrooms,_that.totalCount,_that.currentPage,_that.hasReachedMax,_that.isLoadingMore,_that.selectedClassroomId,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<StudentExamWithAttempts> exams,  List<StudentEnrolledClassroom> classrooms,  int totalCount,  int currentPage,  bool hasReachedMax,  bool isLoadingMore,  String? selectedClassroomId,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _ExamsHistoryState() when $default != null:
return $default(_that.status,_that.exams,_that.classrooms,_that.totalCount,_that.currentPage,_that.hasReachedMax,_that.isLoadingMore,_that.selectedClassroomId,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _ExamsHistoryState implements ExamsHistoryState {
  const _ExamsHistoryState({this.status = CubitStatus.initial, final  List<StudentExamWithAttempts> exams = const [], final  List<StudentEnrolledClassroom> classrooms = const [], this.totalCount = 0, this.currentPage = 1, this.hasReachedMax = false, this.isLoadingMore = false, this.selectedClassroomId, this.apiErrorModel}): _exams = exams,_classrooms = classrooms;
  

@override@JsonKey() final  CubitStatus status;
 final  List<StudentExamWithAttempts> _exams;
@override@JsonKey() List<StudentExamWithAttempts> get exams {
  if (_exams is EqualUnmodifiableListView) return _exams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exams);
}

 final  List<StudentEnrolledClassroom> _classrooms;
@override@JsonKey() List<StudentEnrolledClassroom> get classrooms {
  if (_classrooms is EqualUnmodifiableListView) return _classrooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classrooms);
}

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasReachedMax;
@override@JsonKey() final  bool isLoadingMore;
@override final  String? selectedClassroomId;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of ExamsHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamsHistoryStateCopyWith<_ExamsHistoryState> get copyWith => __$ExamsHistoryStateCopyWithImpl<_ExamsHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamsHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._exams, _exams)&&const DeepCollectionEquality().equals(other._classrooms, _classrooms)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.selectedClassroomId, selectedClassroomId) || other.selectedClassroomId == selectedClassroomId)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_exams),const DeepCollectionEquality().hash(_classrooms),totalCount,currentPage,hasReachedMax,isLoadingMore,selectedClassroomId,apiErrorModel);

@override
String toString() {
  return 'ExamsHistoryState(status: $status, exams: $exams, classrooms: $classrooms, totalCount: $totalCount, currentPage: $currentPage, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, selectedClassroomId: $selectedClassroomId, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$ExamsHistoryStateCopyWith<$Res> implements $ExamsHistoryStateCopyWith<$Res> {
  factory _$ExamsHistoryStateCopyWith(_ExamsHistoryState value, $Res Function(_ExamsHistoryState) _then) = __$ExamsHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<StudentExamWithAttempts> exams, List<StudentEnrolledClassroom> classrooms, int totalCount, int currentPage, bool hasReachedMax, bool isLoadingMore, String? selectedClassroomId, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$ExamsHistoryStateCopyWithImpl<$Res>
    implements _$ExamsHistoryStateCopyWith<$Res> {
  __$ExamsHistoryStateCopyWithImpl(this._self, this._then);

  final _ExamsHistoryState _self;
  final $Res Function(_ExamsHistoryState) _then;

/// Create a copy of ExamsHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? exams = null,Object? classrooms = null,Object? totalCount = null,Object? currentPage = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? selectedClassroomId = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_ExamsHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,exams: null == exams ? _self._exams : exams // ignore: cast_nullable_to_non_nullable
as List<StudentExamWithAttempts>,classrooms: null == classrooms ? _self._classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<StudentEnrolledClassroom>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,selectedClassroomId: freezed == selectedClassroomId ? _self.selectedClassroomId : selectedClassroomId // ignore: cast_nullable_to_non_nullable
as String?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
