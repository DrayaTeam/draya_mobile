// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdrawals_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WithdrawalsState {

 CubitStatus get status; WithdrawalPagedResultModel? get withdrawalsResult; int get currentPage; bool get isPaginating; bool get isSubmittingWithdrawal; WithdrawalModel? get submittedWithdrawal; String? get actionSuccessMessage; ApiErrorModel? get apiErrorModel;
/// Create a copy of WithdrawalsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WithdrawalsStateCopyWith<WithdrawalsState> get copyWith => _$WithdrawalsStateCopyWithImpl<WithdrawalsState>(this as WithdrawalsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WithdrawalsState&&(identical(other.status, status) || other.status == status)&&(identical(other.withdrawalsResult, withdrawalsResult) || other.withdrawalsResult == withdrawalsResult)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isPaginating, isPaginating) || other.isPaginating == isPaginating)&&(identical(other.isSubmittingWithdrawal, isSubmittingWithdrawal) || other.isSubmittingWithdrawal == isSubmittingWithdrawal)&&(identical(other.submittedWithdrawal, submittedWithdrawal) || other.submittedWithdrawal == submittedWithdrawal)&&(identical(other.actionSuccessMessage, actionSuccessMessage) || other.actionSuccessMessage == actionSuccessMessage)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,withdrawalsResult,currentPage,isPaginating,isSubmittingWithdrawal,submittedWithdrawal,actionSuccessMessage,apiErrorModel);

@override
String toString() {
  return 'WithdrawalsState(status: $status, withdrawalsResult: $withdrawalsResult, currentPage: $currentPage, isPaginating: $isPaginating, isSubmittingWithdrawal: $isSubmittingWithdrawal, submittedWithdrawal: $submittedWithdrawal, actionSuccessMessage: $actionSuccessMessage, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $WithdrawalsStateCopyWith<$Res>  {
  factory $WithdrawalsStateCopyWith(WithdrawalsState value, $Res Function(WithdrawalsState) _then) = _$WithdrawalsStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, WithdrawalPagedResultModel? withdrawalsResult, int currentPage, bool isPaginating, bool isSubmittingWithdrawal, WithdrawalModel? submittedWithdrawal, String? actionSuccessMessage, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$WithdrawalsStateCopyWithImpl<$Res>
    implements $WithdrawalsStateCopyWith<$Res> {
  _$WithdrawalsStateCopyWithImpl(this._self, this._then);

  final WithdrawalsState _self;
  final $Res Function(WithdrawalsState) _then;

/// Create a copy of WithdrawalsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? withdrawalsResult = freezed,Object? currentPage = null,Object? isPaginating = null,Object? isSubmittingWithdrawal = null,Object? submittedWithdrawal = freezed,Object? actionSuccessMessage = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,withdrawalsResult: freezed == withdrawalsResult ? _self.withdrawalsResult : withdrawalsResult // ignore: cast_nullable_to_non_nullable
as WithdrawalPagedResultModel?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isPaginating: null == isPaginating ? _self.isPaginating : isPaginating // ignore: cast_nullable_to_non_nullable
as bool,isSubmittingWithdrawal: null == isSubmittingWithdrawal ? _self.isSubmittingWithdrawal : isSubmittingWithdrawal // ignore: cast_nullable_to_non_nullable
as bool,submittedWithdrawal: freezed == submittedWithdrawal ? _self.submittedWithdrawal : submittedWithdrawal // ignore: cast_nullable_to_non_nullable
as WithdrawalModel?,actionSuccessMessage: freezed == actionSuccessMessage ? _self.actionSuccessMessage : actionSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [WithdrawalsState].
extension WithdrawalsStatePatterns on WithdrawalsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WithdrawalsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WithdrawalsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WithdrawalsState value)  $default,){
final _that = this;
switch (_that) {
case _WithdrawalsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WithdrawalsState value)?  $default,){
final _that = this;
switch (_that) {
case _WithdrawalsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  WithdrawalPagedResultModel? withdrawalsResult,  int currentPage,  bool isPaginating,  bool isSubmittingWithdrawal,  WithdrawalModel? submittedWithdrawal,  String? actionSuccessMessage,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WithdrawalsState() when $default != null:
return $default(_that.status,_that.withdrawalsResult,_that.currentPage,_that.isPaginating,_that.isSubmittingWithdrawal,_that.submittedWithdrawal,_that.actionSuccessMessage,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  WithdrawalPagedResultModel? withdrawalsResult,  int currentPage,  bool isPaginating,  bool isSubmittingWithdrawal,  WithdrawalModel? submittedWithdrawal,  String? actionSuccessMessage,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _WithdrawalsState():
return $default(_that.status,_that.withdrawalsResult,_that.currentPage,_that.isPaginating,_that.isSubmittingWithdrawal,_that.submittedWithdrawal,_that.actionSuccessMessage,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  WithdrawalPagedResultModel? withdrawalsResult,  int currentPage,  bool isPaginating,  bool isSubmittingWithdrawal,  WithdrawalModel? submittedWithdrawal,  String? actionSuccessMessage,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _WithdrawalsState() when $default != null:
return $default(_that.status,_that.withdrawalsResult,_that.currentPage,_that.isPaginating,_that.isSubmittingWithdrawal,_that.submittedWithdrawal,_that.actionSuccessMessage,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _WithdrawalsState implements WithdrawalsState {
  const _WithdrawalsState({this.status = CubitStatus.initial, this.withdrawalsResult, this.currentPage = 1, this.isPaginating = false, this.isSubmittingWithdrawal = false, this.submittedWithdrawal, this.actionSuccessMessage, this.apiErrorModel});
  

@override@JsonKey() final  CubitStatus status;
@override final  WithdrawalPagedResultModel? withdrawalsResult;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool isPaginating;
@override@JsonKey() final  bool isSubmittingWithdrawal;
@override final  WithdrawalModel? submittedWithdrawal;
@override final  String? actionSuccessMessage;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of WithdrawalsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WithdrawalsStateCopyWith<_WithdrawalsState> get copyWith => __$WithdrawalsStateCopyWithImpl<_WithdrawalsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WithdrawalsState&&(identical(other.status, status) || other.status == status)&&(identical(other.withdrawalsResult, withdrawalsResult) || other.withdrawalsResult == withdrawalsResult)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isPaginating, isPaginating) || other.isPaginating == isPaginating)&&(identical(other.isSubmittingWithdrawal, isSubmittingWithdrawal) || other.isSubmittingWithdrawal == isSubmittingWithdrawal)&&(identical(other.submittedWithdrawal, submittedWithdrawal) || other.submittedWithdrawal == submittedWithdrawal)&&(identical(other.actionSuccessMessage, actionSuccessMessage) || other.actionSuccessMessage == actionSuccessMessage)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,withdrawalsResult,currentPage,isPaginating,isSubmittingWithdrawal,submittedWithdrawal,actionSuccessMessage,apiErrorModel);

@override
String toString() {
  return 'WithdrawalsState(status: $status, withdrawalsResult: $withdrawalsResult, currentPage: $currentPage, isPaginating: $isPaginating, isSubmittingWithdrawal: $isSubmittingWithdrawal, submittedWithdrawal: $submittedWithdrawal, actionSuccessMessage: $actionSuccessMessage, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$WithdrawalsStateCopyWith<$Res> implements $WithdrawalsStateCopyWith<$Res> {
  factory _$WithdrawalsStateCopyWith(_WithdrawalsState value, $Res Function(_WithdrawalsState) _then) = __$WithdrawalsStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, WithdrawalPagedResultModel? withdrawalsResult, int currentPage, bool isPaginating, bool isSubmittingWithdrawal, WithdrawalModel? submittedWithdrawal, String? actionSuccessMessage, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$WithdrawalsStateCopyWithImpl<$Res>
    implements _$WithdrawalsStateCopyWith<$Res> {
  __$WithdrawalsStateCopyWithImpl(this._self, this._then);

  final _WithdrawalsState _self;
  final $Res Function(_WithdrawalsState) _then;

/// Create a copy of WithdrawalsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? withdrawalsResult = freezed,Object? currentPage = null,Object? isPaginating = null,Object? isSubmittingWithdrawal = null,Object? submittedWithdrawal = freezed,Object? actionSuccessMessage = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_WithdrawalsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,withdrawalsResult: freezed == withdrawalsResult ? _self.withdrawalsResult : withdrawalsResult // ignore: cast_nullable_to_non_nullable
as WithdrawalPagedResultModel?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isPaginating: null == isPaginating ? _self.isPaginating : isPaginating // ignore: cast_nullable_to_non_nullable
as bool,isSubmittingWithdrawal: null == isSubmittingWithdrawal ? _self.isSubmittingWithdrawal : isSubmittingWithdrawal // ignore: cast_nullable_to_non_nullable
as bool,submittedWithdrawal: freezed == submittedWithdrawal ? _self.submittedWithdrawal : submittedWithdrawal // ignore: cast_nullable_to_non_nullable
as WithdrawalModel?,actionSuccessMessage: freezed == actionSuccessMessage ? _self.actionSuccessMessage : actionSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
