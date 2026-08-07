// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherSignupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSignupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherSignupState()';
}


}

/// @nodoc
class $TeacherSignupStateCopyWith<$Res>  {
$TeacherSignupStateCopyWith(TeacherSignupState _, $Res Function(TeacherSignupState) __);
}


/// Adds pattern-matching-related methods to [TeacherSignupState].
extension TeacherSignupStatePatterns on TeacherSignupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TeacherSignupInitial value)?  initial,TResult Function( TeacherSignupLoading value)?  loading,TResult Function( TeacherSignupSuccess value)?  success,TResult Function( TeacherSignupFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TeacherSignupInitial() when initial != null:
return initial(_that);case TeacherSignupLoading() when loading != null:
return loading(_that);case TeacherSignupSuccess() when success != null:
return success(_that);case TeacherSignupFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TeacherSignupInitial value)  initial,required TResult Function( TeacherSignupLoading value)  loading,required TResult Function( TeacherSignupSuccess value)  success,required TResult Function( TeacherSignupFailure value)  failure,}){
final _that = this;
switch (_that) {
case TeacherSignupInitial():
return initial(_that);case TeacherSignupLoading():
return loading(_that);case TeacherSignupSuccess():
return success(_that);case TeacherSignupFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TeacherSignupInitial value)?  initial,TResult? Function( TeacherSignupLoading value)?  loading,TResult? Function( TeacherSignupSuccess value)?  success,TResult? Function( TeacherSignupFailure value)?  failure,}){
final _that = this;
switch (_that) {
case TeacherSignupInitial() when initial != null:
return initial(_that);case TeacherSignupLoading() when loading != null:
return loading(_that);case TeacherSignupSuccess() when success != null:
return success(_that);case TeacherSignupFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AuthEntity authEntity)?  success,TResult Function( ApiErrorModel apiErrorModel)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TeacherSignupInitial() when initial != null:
return initial();case TeacherSignupLoading() when loading != null:
return loading();case TeacherSignupSuccess() when success != null:
return success(_that.authEntity);case TeacherSignupFailure() when failure != null:
return failure(_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AuthEntity authEntity)  success,required TResult Function( ApiErrorModel apiErrorModel)  failure,}) {final _that = this;
switch (_that) {
case TeacherSignupInitial():
return initial();case TeacherSignupLoading():
return loading();case TeacherSignupSuccess():
return success(_that.authEntity);case TeacherSignupFailure():
return failure(_that.apiErrorModel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AuthEntity authEntity)?  success,TResult? Function( ApiErrorModel apiErrorModel)?  failure,}) {final _that = this;
switch (_that) {
case TeacherSignupInitial() when initial != null:
return initial();case TeacherSignupLoading() when loading != null:
return loading();case TeacherSignupSuccess() when success != null:
return success(_that.authEntity);case TeacherSignupFailure() when failure != null:
return failure(_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class TeacherSignupInitial implements TeacherSignupState {
  const TeacherSignupInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSignupInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherSignupState.initial()';
}


}




/// @nodoc


class TeacherSignupLoading implements TeacherSignupState {
  const TeacherSignupLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSignupLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherSignupState.loading()';
}


}




/// @nodoc


class TeacherSignupSuccess implements TeacherSignupState {
  const TeacherSignupSuccess({required this.authEntity});
  

 final  AuthEntity authEntity;

/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherSignupSuccessCopyWith<TeacherSignupSuccess> get copyWith => _$TeacherSignupSuccessCopyWithImpl<TeacherSignupSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSignupSuccess&&(identical(other.authEntity, authEntity) || other.authEntity == authEntity));
}


@override
int get hashCode => Object.hash(runtimeType,authEntity);

@override
String toString() {
  return 'TeacherSignupState.success(authEntity: $authEntity)';
}


}

/// @nodoc
abstract mixin class $TeacherSignupSuccessCopyWith<$Res> implements $TeacherSignupStateCopyWith<$Res> {
  factory $TeacherSignupSuccessCopyWith(TeacherSignupSuccess value, $Res Function(TeacherSignupSuccess) _then) = _$TeacherSignupSuccessCopyWithImpl;
@useResult
$Res call({
 AuthEntity authEntity
});




}
/// @nodoc
class _$TeacherSignupSuccessCopyWithImpl<$Res>
    implements $TeacherSignupSuccessCopyWith<$Res> {
  _$TeacherSignupSuccessCopyWithImpl(this._self, this._then);

  final TeacherSignupSuccess _self;
  final $Res Function(TeacherSignupSuccess) _then;

/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? authEntity = null,}) {
  return _then(TeacherSignupSuccess(
authEntity: null == authEntity ? _self.authEntity : authEntity // ignore: cast_nullable_to_non_nullable
as AuthEntity,
  ));
}


}

/// @nodoc


class TeacherSignupFailure implements TeacherSignupState {
  const TeacherSignupFailure({required this.apiErrorModel});
  

 final  ApiErrorModel apiErrorModel;

/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherSignupFailureCopyWith<TeacherSignupFailure> get copyWith => _$TeacherSignupFailureCopyWithImpl<TeacherSignupFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSignupFailure&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,apiErrorModel);

@override
String toString() {
  return 'TeacherSignupState.failure(apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $TeacherSignupFailureCopyWith<$Res> implements $TeacherSignupStateCopyWith<$Res> {
  factory $TeacherSignupFailureCopyWith(TeacherSignupFailure value, $Res Function(TeacherSignupFailure) _then) = _$TeacherSignupFailureCopyWithImpl;
@useResult
$Res call({
 ApiErrorModel apiErrorModel
});




}
/// @nodoc
class _$TeacherSignupFailureCopyWithImpl<$Res>
    implements $TeacherSignupFailureCopyWith<$Res> {
  _$TeacherSignupFailureCopyWithImpl(this._self, this._then);

  final TeacherSignupFailure _self;
  final $Res Function(TeacherSignupFailure) _then;

/// Create a copy of TeacherSignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? apiErrorModel = null,}) {
  return _then(TeacherSignupFailure(
apiErrorModel: null == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel,
  ));
}


}

// dart format on
