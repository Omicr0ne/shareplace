// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  authUserId: json['auth_user_id'] as String?,
  phone: json['phone'] as String?,
  postalCode: json['postal_code'] as String?,
  profilePictureUrl: json['profile_picture_url'] as String?,
  description: json['description'] as String? ?? '',
  studentVerificationStatus:
      $enumDecodeNullable(
        _$StudentVerificationStatusEnumMap,
        json['student_verification_status'],
      ) ??
      StudentVerificationStatus.none,
  studentEmail: json['student_email'] as String?,
  studentVerifiedAt: json['student_verified_at'] == null
      ? null
      : DateTime.parse(json['student_verified_at'] as String),
  studentVerifiedUntil: json['student_verified_until'] == null
      ? null
      : DateTime.parse(json['student_verified_until'] as String),
  lastLoginAt: json['last_login_at'] == null
      ? null
      : DateTime.parse(json['last_login_at'] as String),
  anonymizedAt: json['anonymized_at'] == null
      ? null
      : DateTime.parse(json['anonymized_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserProfileToJson(
  _UserProfile instance,
) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'auth_user_id': instance.authUserId,
  'phone': instance.phone,
  'postal_code': instance.postalCode,
  'profile_picture_url': instance.profilePictureUrl,
  'description': instance.description,
  'student_verification_status':
      _$StudentVerificationStatusEnumMap[instance.studentVerificationStatus]!,
  'student_email': instance.studentEmail,
  'student_verified_at': instance.studentVerifiedAt?.toIso8601String(),
  'student_verified_until': instance.studentVerifiedUntil?.toIso8601String(),
  'last_login_at': instance.lastLoginAt?.toIso8601String(),
  'anonymized_at': instance.anonymizedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$StudentVerificationStatusEnumMap = {
  StudentVerificationStatus.none: 'none',
  StudentVerificationStatus.selfDeclared: 'self_declared',
  StudentVerificationStatus.verified: 'verified',
  StudentVerificationStatus.rejected: 'rejected',
};
