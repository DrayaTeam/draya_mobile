// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_accounts_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PayoutAccountsState {

 CubitStatus get status; List<PayoutAccountModel> get accounts; bool get isActionLoading; String? get actionSuccessMessage; ApiErrorModel? get apiErrorModel;
/// Create a copy of PayoutAccountsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutAccountsStateCopyWith<PayoutAccountsState> get copyWith => _$PayoutAccountsStateCopyWithImpl<PayoutAccountsState>(this as PayoutAccountsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutAccountsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.accounts, accounts)&&(identical(other.isActionLoading, isActionLoading) || other.isActionLoading == isActionLoading)&&(identical(other.actionSuccessMessage, actionSuccessMessage) || other.actionSuccessMessage == actionSuccessMessage)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(accounts),isActionLoading,actionSuccessMessage,apiErrorModel);

@override
String toString() {
  return 'PayoutAccountsState(status: $status, accounts: $accounts, isActionLoading: $isActionLoading, actionSuccessMessage: $actionSuccessMessage, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class $PayoutAccountsStateCopyWith<$Res>  {
  factory $PayoutAccountsStateCopyWith(PayoutAccountsState value, $Res Function(PayoutAccountsState) _then) = _$PayoutAccountsStateCopyWithImpl;
@useResult
$Res call({
 CubitStatus status, List<PayoutAccountModel> accounts, bool isActionLoading, String? actionSuccessMessage, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class _$PayoutAccountsStateCopyWithImpl<$Res>
    implements $PayoutAccountsStateCopyWith<$Res> {
  _$PayoutAccountsStateCopyWithImpl(this._self, this._then);

  final PayoutAccountsState _self;
  final $Res Function(PayoutAccountsState) _then;

/// Create a copy of PayoutAccountsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? accounts = null,Object? isActionLoading = null,Object? actionSuccessMessage = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<PayoutAccountModel>,isActionLoading: null == isActionLoading ? _self.isActionLoading : isActionLoading // ignore: cast_nullable_to_non_nullable
as bool,actionSuccessMessage: freezed == actionSuccessMessage ? _self.actionSuccessMessage : actionSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutAccountsState].
extension PayoutAccountsStatePatterns on PayoutAccountsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutAccountsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutAccountsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutAccountsState value)  $default,){
final _that = this;
switch (_that) {
case _PayoutAccountsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutAccountsState value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutAccountsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitStatus status,  List<PayoutAccountModel> accounts,  bool isActionLoading,  String? actionSuccessMessage,  ApiErrorModel? apiErrorModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutAccountsState() when $default != null:
return $default(_that.status,_that.accounts,_that.isActionLoading,_that.actionSuccessMessage,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitStatus status,  List<PayoutAccountModel> accounts,  bool isActionLoading,  String? actionSuccessMessage,  ApiErrorModel? apiErrorModel)  $default,) {final _that = this;
switch (_that) {
case _PayoutAccountsState():
return $default(_that.status,_that.accounts,_that.isActionLoading,_that.actionSuccessMessage,_that.apiErrorModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitStatus status,  List<PayoutAccountModel> accounts,  bool isActionLoading,  String? actionSuccessMessage,  ApiErrorModel? apiErrorModel)?  $default,) {final _that = this;
switch (_that) {
case _PayoutAccountsState() when $default != null:
return $default(_that.status,_that.accounts,_that.isActionLoading,_that.actionSuccessMessage,_that.apiErrorModel);case _:
  return null;

}
}

}

/// @nodoc


class _PayoutAccountsState implements PayoutAccountsState {
  const _PayoutAccountsState({this.status = CubitStatus.initial, final  List<PayoutAccountModel> accounts = const [], this.isActionLoading = false, this.actionSuccessMessage, this.apiErrorModel}): _accounts = accounts;
  

@override@JsonKey() final  CubitStatus status;
 final  List<PayoutAccountModel> _accounts;
@override@JsonKey() List<PayoutAccountModel> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

@override@JsonKey() final  bool isActionLoading;
@override final  String? actionSuccessMessage;
@override final  ApiErrorModel? apiErrorModel;

/// Create a copy of PayoutAccountsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutAccountsStateCopyWith<_PayoutAccountsState> get copyWith => __$PayoutAccountsStateCopyWithImpl<_PayoutAccountsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutAccountsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&(identical(other.isActionLoading, isActionLoading) || other.isActionLoading == isActionLoading)&&(identical(other.actionSuccessMessage, actionSuccessMessage) || other.actionSuccessMessage == actionSuccessMessage)&&(identical(other.apiErrorModel, apiErrorModel) || other.apiErrorModel == apiErrorModel));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_accounts),isActionLoading,actionSuccessMessage,apiErrorModel);

@override
String toString() {
  return 'PayoutAccountsState(status: $status, accounts: $accounts, isActionLoading: $isActionLoading, actionSuccessMessage: $actionSuccessMessage, apiErrorModel: $apiErrorModel)';
}


}

/// @nodoc
abstract mixin class _$PayoutAccountsStateCopyWith<$Res> implements $PayoutAccountsStateCopyWith<$Res> {
  factory _$PayoutAccountsStateCopyWith(_PayoutAccountsState value, $Res Function(_PayoutAccountsState) _then) = __$PayoutAccountsStateCopyWithImpl;
@override @useResult
$Res call({
 CubitStatus status, List<PayoutAccountModel> accounts, bool isActionLoading, String? actionSuccessMessage, ApiErrorModel? apiErrorModel
});




}
/// @nodoc
class __$PayoutAccountsStateCopyWithImpl<$Res>
    implements _$PayoutAccountsStateCopyWith<$Res> {
  __$PayoutAccountsStateCopyWithImpl(this._self, this._then);

  final _PayoutAccountsState _self;
  final $Res Function(_PayoutAccountsState) _then;

/// Create a copy of PayoutAccountsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? accounts = null,Object? isActionLoading = null,Object? actionSuccessMessage = freezed,Object? apiErrorModel = freezed,}) {
  return _then(_PayoutAccountsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitStatus,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<PayoutAccountModel>,isActionLoading: null == isActionLoading ? _self.isActionLoading : isActionLoading // ignore: cast_nullable_to_non_nullable
as bool,actionSuccessMessage: freezed == actionSuccessMessage ? _self.actionSuccessMessage : actionSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,apiErrorModel: freezed == apiErrorModel ? _self.apiErrorModel : apiErrorModel // ignore: cast_nullable_to_non_nullable
as ApiErrorModel?,
  ));
}


}

// dart format on
