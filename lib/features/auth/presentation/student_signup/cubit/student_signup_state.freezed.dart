// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudentSignupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentSignupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StudentSignupState()';
}


}

/// @nodoc
class $StudentSignupStateCopyWith<$Res>  {
$StudentSignupStateCopyWith(StudentSignupState _, $Res Function(StudentSignupState) __);
}


/// Adds pattern-matching-related methods to [StudentSignupState].
extension StudentSignupStatePatterns on StudentSignupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StudentSignupInitial value)?  initial,TResult Function( StudentSignupLoading value)?  loading,TResult Function( StudentSignupSuccess value)?  success,TResult Function( StudentSignupFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StudentSignupInitial() when initial != null:
return initial(_that);case StudentSignupLoading() when loading != null:
return loading(_that);case StudentSignupSuccess() when success != null:
return success(_that);case StudentSignupFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StudentSignupInitial value)  initial,required TResult Function( StudentSignupLoading value)  loading,required TResult Function( StudentSignupSuccess value)  success,required TResult Function( StudentSignupFailure value)  failure,}){
final _that = this;
switch (_that) {
case StudentSignupInitial():
return initial(_that);case StudentSignupLoading():
return loading(_that);case StudentSignupSuccess():
return success(_that);case StudentSignupFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StudentSignupInitial value)?  initial,TResult? Function( StudentSignupLoading value)?  loading,TResult? Function( StudentSignupSuccess value)?  success,TResult? Function( StudentSignupFailure value)?  failure,}){
final _that = this;
switch (_that) {
case StudentSignupInitial() when initial != null:
return initial(_that);case StudentSignupLoading() when loading != null:
return loading(_that);case StudentSignupSuccess() when success != null:
return success(_that);case StudentSignupFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StudentSignupInitial() when initial != null:
return initial();case StudentSignupLoading() when loading != null:
return loading();case StudentSignupSuccess() when success != null:
return success();case StudentSignupFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case StudentSignupInitial():
return initial();case StudentSignupLoading():
return loading();case StudentSignupSuccess():
return success();case StudentSignupFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case StudentSignupInitial() when initial != null:
return initial();case StudentSignupLoading() when loading != null:
return loading();case StudentSignupSuccess() when success != null:
return success();case StudentSignupFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class StudentSignupInitial implements StudentSignupState {
  const StudentSignupInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentSignupInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StudentSignupState.initial()';
}


}




/// @nodoc


class StudentSignupLoading implements StudentSignupState {
  const StudentSignupLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentSignupLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StudentSignupState.loading()';
}


}




/// @nodoc


class StudentSignupSuccess implements StudentSignupState {
  const StudentSignupSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentSignupSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StudentSignupState.success()';
}


}




/// @nodoc


class StudentSignupFailure implements StudentSignupState {
  const StudentSignupFailure({required this.message});
  

 final  String message;

/// Create a copy of StudentSignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentSignupFailureCopyWith<StudentSignupFailure> get copyWith => _$StudentSignupFailureCopyWithImpl<StudentSignupFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentSignupFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'StudentSignupState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $StudentSignupFailureCopyWith<$Res> implements $StudentSignupStateCopyWith<$Res> {
  factory $StudentSignupFailureCopyWith(StudentSignupFailure value, $Res Function(StudentSignupFailure) _then) = _$StudentSignupFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$StudentSignupFailureCopyWithImpl<$Res>
    implements $StudentSignupFailureCopyWith<$Res> {
  _$StudentSignupFailureCopyWithImpl(this._self, this._then);

  final StudentSignupFailure _self;
  final $Res Function(StudentSignupFailure) _then;

/// Create a copy of StudentSignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(StudentSignupFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
