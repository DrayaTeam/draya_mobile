// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grades_exams_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamGradesItem {

 SectionExamModel get exam; String get sectionTitle;
/// Create a copy of ExamGradesItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamGradesItemCopyWith<ExamGradesItem> get copyWith => _$ExamGradesItemCopyWithImpl<ExamGradesItem>(this as ExamGradesItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamGradesItem&&(identical(other.exam, exam) || other.exam == exam)&&(identical(other.sectionTitle, sectionTitle) || other.sectionTitle == sectionTitle));
}


@override
int get hashCode => Object.hash(runtimeType,exam,sectionTitle);

@override
String toString() {
  return 'ExamGradesItem(exam: $exam, sectionTitle: $sectionTitle)';
}


}

/// @nodoc
abstract mixin class $ExamGradesItemCopyWith<$Res>  {
  factory $ExamGradesItemCopyWith(ExamGradesItem value, $Res Function(ExamGradesItem) _then) = _$ExamGradesItemCopyWithImpl;
@useResult
$Res call({
 SectionExamModel exam, String sectionTitle
});




}
/// @nodoc
class _$ExamGradesItemCopyWithImpl<$Res>
    implements $ExamGradesItemCopyWith<$Res> {
  _$ExamGradesItemCopyWithImpl(this._self, this._then);

  final ExamGradesItem _self;
  final $Res Function(ExamGradesItem) _then;

/// Create a copy of ExamGradesItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exam = null,Object? sectionTitle = null,}) {
  return _then(_self.copyWith(
exam: null == exam ? _self.exam : exam // ignore: cast_nullable_to_non_nullable
as SectionExamModel,sectionTitle: null == sectionTitle ? _self.sectionTitle : sectionTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamGradesItem].
extension ExamGradesItemPatterns on ExamGradesItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamGradesItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamGradesItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamGradesItem value)  $default,){
final _that = this;
switch (_that) {
case _ExamGradesItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamGradesItem value)?  $default,){
final _that = this;
switch (_that) {
case _ExamGradesItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SectionExamModel exam,  String sectionTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamGradesItem() when $default != null:
return $default(_that.exam,_that.sectionTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SectionExamModel exam,  String sectionTitle)  $default,) {final _that = this;
switch (_that) {
case _ExamGradesItem():
return $default(_that.exam,_that.sectionTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SectionExamModel exam,  String sectionTitle)?  $default,) {final _that = this;
switch (_that) {
case _ExamGradesItem() when $default != null:
return $default(_that.exam,_that.sectionTitle);case _:
  return null;

}
}

}

/// @nodoc


class _ExamGradesItem implements ExamGradesItem {
  const _ExamGradesItem({required this.exam, required this.sectionTitle});
  

@override final  SectionExamModel exam;
@override final  String sectionTitle;

/// Create a copy of ExamGradesItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamGradesItemCopyWith<_ExamGradesItem> get copyWith => __$ExamGradesItemCopyWithImpl<_ExamGradesItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamGradesItem&&(identical(other.exam, exam) || other.exam == exam)&&(identical(other.sectionTitle, sectionTitle) || other.sectionTitle == sectionTitle));
}


@override
int get hashCode => Object.hash(runtimeType,exam,sectionTitle);

@override
String toString() {
  return 'ExamGradesItem(exam: $exam, sectionTitle: $sectionTitle)';
}


}

/// @nodoc
abstract mixin class _$ExamGradesItemCopyWith<$Res> implements $ExamGradesItemCopyWith<$Res> {
  factory _$ExamGradesItemCopyWith(_ExamGradesItem value, $Res Function(_ExamGradesItem) _then) = __$ExamGradesItemCopyWithImpl;
@override @useResult
$Res call({
 SectionExamModel exam, String sectionTitle
});




}
/// @nodoc
class __$ExamGradesItemCopyWithImpl<$Res>
    implements _$ExamGradesItemCopyWith<$Res> {
  __$ExamGradesItemCopyWithImpl(this._self, this._then);

  final _ExamGradesItem _self;
  final $Res Function(_ExamGradesItem) _then;

/// Create a copy of ExamGradesItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exam = null,Object? sectionTitle = null,}) {
  return _then(_ExamGradesItem(
exam: null == exam ? _self.exam : exam // ignore: cast_nullable_to_non_nullable
as SectionExamModel,sectionTitle: null == sectionTitle ? _self.sectionTitle : sectionTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$GradesExamsState {

 CubitStatus get status; List<ExamGradesItem> get exams; ApiErrorModel? get apiErrorModel;
/// Create a copy of GradesExamsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradesExamsStateCopyWith<GradesExamsState> get copyWith => _$GradesExamsStateCopyWithImpl<GradesExamsState>(this as GradesExamsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradesExamsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.exams, exams)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(exams),apiErrorModel);

@override
String toString() {
  return 'GradesExamsState(status: $status, exams: $exams, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $GradesExamsStateCopyWith<$Res>  {
  factory $GradesExamsStateCopyWith(GradesExamsState value, $Res Function(GradesExamsState) _then) = _$GradesExamsStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<ExamGradesItem> exams, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$GradesExamsStateCopyWithImpl<$Res>
    implements $GradesExamsStateCopyWith<$Res> {
  _$GradesExamsStateCopyWithImpl(this._self, this._then);

  final GradesExamsState _self;
  final $Res Function(GradesExamsState) _then;

/// Create a copy of GradesExamsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? exams = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,exams: null == exams ? _self.exams : exams // ignore: cast_nullable_to_non_nullable
as List<ExamGradesItem>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [GradesExamsState].
extension GradesExamsStatePatterns on GradesExamsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradesExamsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradesExamsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradesExamsState value)  $default,){
final _that = this;
switch (_that) {
case _GradesExamsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradesExamsState value)?  $default,){
final _that = this;
switch (_that) {
case _GradesExamsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<ExamGradesItem> exams,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradesExamsState() when $default != null:
return $default(_that.status,_that.exams,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<ExamGradesItem> exams,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _GradesExamsState():
return $default(_that.status,_that.exams,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<ExamGradesItem> exams,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _GradesExamsState() when $default != null:
return $default(_that.status,_that.exams,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _GradesExamsState implements GradesExamsState {
  const _GradesExamsState({this.status = CubitStatus.initial, final  List<ExamGradesItem> exams = const [], this.apiErrorModel}): _exams = exams;
  

@override@JsonKey() final  CubitStatus status;
 final  List<ExamGradesItem> _exams;
@override@JsonKey() List<ExamGradesItem> get exams {
  if (_exams is EqualUnmodifiableListView) return _exams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exams);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of GradesExamsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradesExamsStateCopyWith<_GradesExamsState> get copyWith => __$GradesExamsStateCopyWithImpl<_GradesExamsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradesExamsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._exams, _exams)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_exams),apiErrorModel);

@override
String toString() {
  return 'GradesExamsState(status: $status, exams: $exams, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$GradesExamsStateCopyWith<$Res> implements $GradesExamsStateCopyWith<$Res> {
  factory _$GradesExamsStateCopyWith(_GradesExamsState value, $Res Function(_GradesExamsState) _then) = __$GradesExamsStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<ExamGradesItem> exams, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$GradesExamsStateCopyWithImpl<$Res>
    implements _$GradesExamsStateCopyWith<$Res> {
  __$GradesExamsStateCopyWithImpl(this._self, this._then);

  final _GradesExamsState _self;
  final $Res Function(_GradesExamsState) _then;

/// Create a copy of GradesExamsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? exams = null,Object? apiErrorModel = freezed,}) {
  return _then(_GradesExamsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,exams: null == exams ? _self._exams : exams // ignore: cast_nullable_to_non_nullable
as List<ExamGradesItem>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
