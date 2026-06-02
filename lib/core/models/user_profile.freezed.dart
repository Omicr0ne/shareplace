// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'auth_user_id') String? get authUserId; String? get phone;@JsonKey(name: 'postal_code') String? get postalCode;@JsonKey(name: 'profile_picture_url') String? get profilePictureUrl; String get description;@JsonKey(name: 'student_verification_status') StudentVerificationStatus get studentVerificationStatus;@JsonKey(name: 'student_email') String? get studentEmail;@JsonKey(name: 'student_verified_at') DateTime? get studentVerifiedAt;@JsonKey(name: 'student_verified_until') DateTime? get studentVerifiedUntil;@JsonKey(name: 'last_login_at') DateTime? get lastLoginAt;@JsonKey(name: 'anonymized_at') DateTime? get anonymizedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.studentVerificationStatus, studentVerificationStatus) || other.studentVerificationStatus == studentVerificationStatus)&&(identical(other.studentEmail, studentEmail) || other.studentEmail == studentEmail)&&(identical(other.studentVerifiedAt, studentVerifiedAt) || other.studentVerifiedAt == studentVerifiedAt)&&(identical(other.studentVerifiedUntil, studentVerifiedUntil) || other.studentVerifiedUntil == studentVerifiedUntil)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.anonymizedAt, anonymizedAt) || other.anonymizedAt == anonymizedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,authUserId,phone,postalCode,profilePictureUrl,description,studentVerificationStatus,studentEmail,studentVerifiedAt,studentVerifiedUntil,lastLoginAt,anonymizedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfile(id: $id, firstName: $firstName, lastName: $lastName, authUserId: $authUserId, phone: $phone, postalCode: $postalCode, profilePictureUrl: $profilePictureUrl, description: $description, studentVerificationStatus: $studentVerificationStatus, studentEmail: $studentEmail, studentVerifiedAt: $studentVerifiedAt, studentVerifiedUntil: $studentVerifiedUntil, lastLoginAt: $lastLoginAt, anonymizedAt: $anonymizedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'auth_user_id') String? authUserId, String? phone,@JsonKey(name: 'postal_code') String? postalCode,@JsonKey(name: 'profile_picture_url') String? profilePictureUrl, String description,@JsonKey(name: 'student_verification_status') StudentVerificationStatus studentVerificationStatus,@JsonKey(name: 'student_email') String? studentEmail,@JsonKey(name: 'student_verified_at') DateTime? studentVerifiedAt,@JsonKey(name: 'student_verified_until') DateTime? studentVerifiedUntil,@JsonKey(name: 'last_login_at') DateTime? lastLoginAt,@JsonKey(name: 'anonymized_at') DateTime? anonymizedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? authUserId = freezed,Object? phone = freezed,Object? postalCode = freezed,Object? profilePictureUrl = freezed,Object? description = null,Object? studentVerificationStatus = null,Object? studentEmail = freezed,Object? studentVerifiedAt = freezed,Object? studentVerifiedUntil = freezed,Object? lastLoginAt = freezed,Object? anonymizedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,authUserId: freezed == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,studentVerificationStatus: null == studentVerificationStatus ? _self.studentVerificationStatus : studentVerificationStatus // ignore: cast_nullable_to_non_nullable
as StudentVerificationStatus,studentEmail: freezed == studentEmail ? _self.studentEmail : studentEmail // ignore: cast_nullable_to_non_nullable
as String?,studentVerifiedAt: freezed == studentVerifiedAt ? _self.studentVerifiedAt : studentVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,studentVerifiedUntil: freezed == studentVerifiedUntil ? _self.studentVerifiedUntil : studentVerifiedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,anonymizedAt: freezed == anonymizedAt ? _self.anonymizedAt : anonymizedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'auth_user_id')  String? authUserId,  String? phone, @JsonKey(name: 'postal_code')  String? postalCode, @JsonKey(name: 'profile_picture_url')  String? profilePictureUrl,  String description, @JsonKey(name: 'student_verification_status')  StudentVerificationStatus studentVerificationStatus, @JsonKey(name: 'student_email')  String? studentEmail, @JsonKey(name: 'student_verified_at')  DateTime? studentVerifiedAt, @JsonKey(name: 'student_verified_until')  DateTime? studentVerifiedUntil, @JsonKey(name: 'last_login_at')  DateTime? lastLoginAt, @JsonKey(name: 'anonymized_at')  DateTime? anonymizedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.authUserId,_that.phone,_that.postalCode,_that.profilePictureUrl,_that.description,_that.studentVerificationStatus,_that.studentEmail,_that.studentVerifiedAt,_that.studentVerifiedUntil,_that.lastLoginAt,_that.anonymizedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'auth_user_id')  String? authUserId,  String? phone, @JsonKey(name: 'postal_code')  String? postalCode, @JsonKey(name: 'profile_picture_url')  String? profilePictureUrl,  String description, @JsonKey(name: 'student_verification_status')  StudentVerificationStatus studentVerificationStatus, @JsonKey(name: 'student_email')  String? studentEmail, @JsonKey(name: 'student_verified_at')  DateTime? studentVerifiedAt, @JsonKey(name: 'student_verified_until')  DateTime? studentVerifiedUntil, @JsonKey(name: 'last_login_at')  DateTime? lastLoginAt, @JsonKey(name: 'anonymized_at')  DateTime? anonymizedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.firstName,_that.lastName,_that.authUserId,_that.phone,_that.postalCode,_that.profilePictureUrl,_that.description,_that.studentVerificationStatus,_that.studentEmail,_that.studentVerifiedAt,_that.studentVerifiedUntil,_that.lastLoginAt,_that.anonymizedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'auth_user_id')  String? authUserId,  String? phone, @JsonKey(name: 'postal_code')  String? postalCode, @JsonKey(name: 'profile_picture_url')  String? profilePictureUrl,  String description, @JsonKey(name: 'student_verification_status')  StudentVerificationStatus studentVerificationStatus, @JsonKey(name: 'student_email')  String? studentEmail, @JsonKey(name: 'student_verified_at')  DateTime? studentVerifiedAt, @JsonKey(name: 'student_verified_until')  DateTime? studentVerifiedUntil, @JsonKey(name: 'last_login_at')  DateTime? lastLoginAt, @JsonKey(name: 'anonymized_at')  DateTime? anonymizedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.authUserId,_that.phone,_that.postalCode,_that.profilePictureUrl,_that.description,_that.studentVerificationStatus,_that.studentEmail,_that.studentVerifiedAt,_that.studentVerifiedUntil,_that.lastLoginAt,_that.anonymizedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, @JsonKey(name: 'auth_user_id') this.authUserId, this.phone, @JsonKey(name: 'postal_code') this.postalCode, @JsonKey(name: 'profile_picture_url') this.profilePictureUrl, this.description = '', @JsonKey(name: 'student_verification_status') this.studentVerificationStatus = StudentVerificationStatus.none, @JsonKey(name: 'student_email') this.studentEmail, @JsonKey(name: 'student_verified_at') this.studentVerifiedAt, @JsonKey(name: 'student_verified_until') this.studentVerifiedUntil, @JsonKey(name: 'last_login_at') this.lastLoginAt, @JsonKey(name: 'anonymized_at') this.anonymizedAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'auth_user_id') final  String? authUserId;
@override final  String? phone;
@override@JsonKey(name: 'postal_code') final  String? postalCode;
@override@JsonKey(name: 'profile_picture_url') final  String? profilePictureUrl;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'student_verification_status') final  StudentVerificationStatus studentVerificationStatus;
@override@JsonKey(name: 'student_email') final  String? studentEmail;
@override@JsonKey(name: 'student_verified_at') final  DateTime? studentVerifiedAt;
@override@JsonKey(name: 'student_verified_until') final  DateTime? studentVerifiedUntil;
@override@JsonKey(name: 'last_login_at') final  DateTime? lastLoginAt;
@override@JsonKey(name: 'anonymized_at') final  DateTime? anonymizedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.studentVerificationStatus, studentVerificationStatus) || other.studentVerificationStatus == studentVerificationStatus)&&(identical(other.studentEmail, studentEmail) || other.studentEmail == studentEmail)&&(identical(other.studentVerifiedAt, studentVerifiedAt) || other.studentVerifiedAt == studentVerifiedAt)&&(identical(other.studentVerifiedUntil, studentVerifiedUntil) || other.studentVerifiedUntil == studentVerifiedUntil)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.anonymizedAt, anonymizedAt) || other.anonymizedAt == anonymizedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,authUserId,phone,postalCode,profilePictureUrl,description,studentVerificationStatus,studentEmail,studentVerifiedAt,studentVerifiedUntil,lastLoginAt,anonymizedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfile(id: $id, firstName: $firstName, lastName: $lastName, authUserId: $authUserId, phone: $phone, postalCode: $postalCode, profilePictureUrl: $profilePictureUrl, description: $description, studentVerificationStatus: $studentVerificationStatus, studentEmail: $studentEmail, studentVerifiedAt: $studentVerifiedAt, studentVerifiedUntil: $studentVerifiedUntil, lastLoginAt: $lastLoginAt, anonymizedAt: $anonymizedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'auth_user_id') String? authUserId, String? phone,@JsonKey(name: 'postal_code') String? postalCode,@JsonKey(name: 'profile_picture_url') String? profilePictureUrl, String description,@JsonKey(name: 'student_verification_status') StudentVerificationStatus studentVerificationStatus,@JsonKey(name: 'student_email') String? studentEmail,@JsonKey(name: 'student_verified_at') DateTime? studentVerifiedAt,@JsonKey(name: 'student_verified_until') DateTime? studentVerifiedUntil,@JsonKey(name: 'last_login_at') DateTime? lastLoginAt,@JsonKey(name: 'anonymized_at') DateTime? anonymizedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? authUserId = freezed,Object? phone = freezed,Object? postalCode = freezed,Object? profilePictureUrl = freezed,Object? description = null,Object? studentVerificationStatus = null,Object? studentEmail = freezed,Object? studentVerifiedAt = freezed,Object? studentVerifiedUntil = freezed,Object? lastLoginAt = freezed,Object? anonymizedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,authUserId: freezed == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,studentVerificationStatus: null == studentVerificationStatus ? _self.studentVerificationStatus : studentVerificationStatus // ignore: cast_nullable_to_non_nullable
as StudentVerificationStatus,studentEmail: freezed == studentEmail ? _self.studentEmail : studentEmail // ignore: cast_nullable_to_non_nullable
as String?,studentVerifiedAt: freezed == studentVerifiedAt ? _self.studentVerifiedAt : studentVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,studentVerifiedUntil: freezed == studentVerifiedUntil ? _self.studentVerifiedUntil : studentVerifiedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,anonymizedAt: freezed == anonymizedAt ? _self.anonymizedAt : anonymizedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
