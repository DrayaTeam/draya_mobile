// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SigninState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SigninState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SigninState()';
}


}

/// @nodoc
class $SigninStateCopyWith<$Res>  {
$SigninStateCopyWith(SigninState _, $Res Function(SigninState) __);
}


/// Adds pattern-matching-related methods to [SigninState].
extension SigninStatePatterns on SigninState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SigninInitial value)?  initial,TResult Function( SigninLoading value)?  loading,TResult Function( SigninSuccess value)?  success,TResult Function( SigninFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SigninInitial() when initial != null:
return initial(_that);case SigninLoading() when loading != null:
return loading(_that);case SigninSuccess() when success != null:
return success(_that);case SigninFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SigninInitial value)  initial,required TResult Function( SigninLoading value)  loading,required TResult Function( SigninSuccess value)  success,required TResult Function( SigninFailure value)  failure,}){
final _that = this;
switch (_that) {
case SigninInitial():
return initial(_that);case SigninLoading():
return loading(_that);case SigninSuccess():
return success(_that);case SigninFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SigninInitial value)?  initial,TResult? Function( SigninLoading value)?  loading,TResult? Function( SigninSuccess value)?  success,TResult? Function( SigninFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SigninInitial() when initial != null:
return initial(_that);case SigninLoading() when loading != null:
return loading(_that);case SigninSuccess() when success != null:
return success(_that);case SigninFailure() when failure != null:
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
case SigninInitial() when initial != null:
return initial();case SigninLoading() when loading != null:
return loading();case SigninSuccess() when success != null:
return success();case SigninFailure() when failure != null:
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
case SigninInitial():
return initial();case SigninLoading():
return loading();case SigninSuccess():
return success();case SigninFailure():
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
case SigninInitial() when initial != null:
return initial();case SigninLoading() when loading != null:
return loading();case SigninSuccess() when success != null:
return success();case SigninFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SigninInitial implements SigninState {
  const SigninInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SigninInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SigninState.initial()';
}


}




/// @nodoc


class SigninLoading implements SigninState {
  const SigninLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SigninLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SigninState.loading()';
}


}




/// @nodoc


class SigninSuccess implements SigninState {
  const SigninSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SigninSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SigninState.success()';
}


}




/// @nodoc


class SigninFailure implements SigninState {
  const SigninFailure({required this.message});
  

 final  String message;

/// Create a copy of SigninState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SigninFailureCopyWith<SigninFailure> get copyWith => _$SigninFailureCopyWithImpl<SigninFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SigninFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SigninState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $SigninFailureCopyWith<$Res> implements $SigninStateCopyWith<$Res> {
  factory $SigninFailureCopyWith(SigninFailure value, $Res Function(SigninFailure) _then) = _$SigninFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SigninFailureCopyWithImpl<$Res>
    implements $SigninFailureCopyWith<$Res> {
  _$SigninFailureCopyWithImpl(this._self, this._then);

  final SigninFailure _self;
  final $Res Function(SigninFailure) _then;

/// Create a copy of SigninState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SigninFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
