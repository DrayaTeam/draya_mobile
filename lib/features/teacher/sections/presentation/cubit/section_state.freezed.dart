// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SectionState {

 CubitStatus get getSectionsStatus; CubitStatus get createSectionStatus; CubitStatus get deleteSectionStatus; List<SectionModel> get sections; ApiErrorModel? get apiErrorModel;
/// Create a copy of SectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionStateCopyWith<SectionState> get copyWith => _$SectionStateCopyWithImpl<SectionState>(this as SectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionState&&(identical(other.getSectionsStatus, getSectionsStatus) || other.getSectionsStatus == getSectionsStatus)&&(identical(other.createSectionStatus, createSectionStatus) || other.createSectionStatus == createSectionStatus)&&(identical(other.deleteSectionStatus, deleteSectionStatus) || other.deleteSectionStatus == deleteSectionStatus)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,getSectionsStatus,createSectionStatus,deleteSectionStatus,const DeepCollectionEquality().hash(sections),apiErrorModel);

@override
String toString() {
  return 'SectionState(getSectionsStatus: $getSectionsStatus, createSectionStatus: $createSectionStatus, deleteSectionStatus: $deleteSectionStatus, sections: $sections, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $SectionStateCopyWith<$Res>  {
  factory $SectionStateCopyWith(SectionState value, $Res Function(SectionState) _then) = _$SectionStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus getSectionsStatus, CubitStatus createSectionStatus, CubitStatus deleteSectionStatus, List<SectionModel> sections, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$SectionStateCopyWithImpl<$Res>
    implements $SectionStateCopyWith<$Res> {
  _$SectionStateCopyWithImpl(this._self, this._then);

  final SectionState _self;
  final $Res Function(SectionState) _then;

/// Create a copy of SectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? getSectionsStatus = null,Object? createSectionStatus = null,Object? deleteSectionStatus = null,Object? sections = null,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
getSectionsStatus: null == getSectionsStatus ? _self.getSectionsStatus : getSectionsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,createSectionStatus: null == createSectionStatus ? _self.createSectionStatus : createSectionStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,deleteSectionStatus: null == deleteSectionStatus ? _self.deleteSectionStatus : deleteSectionStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionState].
extension SectionStatePatterns on SectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionState value)  $default,){
final _that = this;
switch (_that) {
case _SectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionState value)?  $default,){
final _that = this;
switch (_that) {
case _SectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus getSectionsStatus,  CubitStatus createSectionStatus,  CubitStatus deleteSectionStatus,  List<SectionModel> sections,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionState() when $default != null:
return $default(_that.getSectionsStatus,_that.createSectionStatus,_that.deleteSectionStatus,_that.sections,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus getSectionsStatus,  CubitStatus createSectionStatus,  CubitStatus deleteSectionStatus,  List<SectionModel> sections,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _SectionState():
return $default(_that.getSectionsStatus,_that.createSectionStatus,_that.deleteSectionStatus,_that.sections,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus getSectionsStatus,  CubitStatus createSectionStatus,  CubitStatus deleteSectionStatus,  List<SectionModel> sections,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _SectionState() when $default != null:
return $default(_that.getSectionsStatus,_that.createSectionStatus,_that.deleteSectionStatus,_that.sections,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _SectionState implements SectionState {
  const _SectionState({this.getSectionsStatus = CubitStatus.initial, this.createSectionStatus = CubitStatus.initial, this.deleteSectionStatus = CubitStatus.initial, final  List<SectionModel> sections = const [], this.apiErrorModel}): _sections = sections;
  

@override@JsonKey() final  CubitStatus getSectionsStatus;
@override@JsonKey() final  CubitStatus createSectionStatus;
@override@JsonKey() final  CubitStatus deleteSectionStatus;
 final  List<SectionModel> _sections;
@override@JsonKey() List<SectionModel> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of SectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionStateCopyWith<_SectionState> get copyWith => __$SectionStateCopyWithImpl<_SectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionState&&(identical(other.getSectionsStatus, getSectionsStatus) || other.getSectionsStatus == getSectionsStatus)&&(identical(other.createSectionStatus, createSectionStatus) || other.createSectionStatus == createSectionStatus)&&(identical(other.deleteSectionStatus, deleteSectionStatus) || other.deleteSectionStatus == deleteSectionStatus)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,getSectionsStatus,createSectionStatus,deleteSectionStatus,const DeepCollectionEquality().hash(_sections),apiErrorModel);

@override
String toString() {
  return 'SectionState(getSectionsStatus: $getSectionsStatus, createSectionStatus: $createSectionStatus, deleteSectionStatus: $deleteSectionStatus, sections: $sections, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$SectionStateCopyWith<$Res> implements $SectionStateCopyWith<$Res> {
  factory _$SectionStateCopyWith(_SectionState value, $Res Function(_SectionState) _then) = __$SectionStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus getSectionsStatus, CubitStatus createSectionStatus, CubitStatus deleteSectionStatus, List<SectionModel> sections, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$SectionStateCopyWithImpl<$Res>
    implements _$SectionStateCopyWith<$Res> {
  __$SectionStateCopyWithImpl(this._self, this._then);

  final _SectionState _self;
  final $Res Function(_SectionState) _then;

/// Create a copy of SectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? getSectionsStatus = null,Object? createSectionStatus = null,Object? deleteSectionStatus = null,Object? sections = null,Object? apiErrorModel = freezed,}) {
  return _then(_SectionState(
getSectionsStatus: null == getSectionsStatus ? _self.getSectionsStatus : getSectionsStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,createSectionStatus: null == createSectionStatus ? _self.createSectionStatus : createSectionStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,deleteSectionStatus: null == deleteSectionStatus ? _self.deleteSectionStatus : deleteSectionStatus // ignore: cast_nullable_to_non_nullable
as CubitStatus,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionModel>,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
