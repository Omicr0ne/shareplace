import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

enum StudentVerificationStatus {
  none,
  @JsonValue('self_declared')
  selfDeclared,
  verified,
  rejected,
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'auth_user_id') String? authUserId,
    String? phone,
    @JsonKey(name: 'postal_code') String? postalCode,
    @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
    @Default('') String description,
    @Default(StudentVerificationStatus.none)
    @JsonKey(name: 'student_verification_status')
    StudentVerificationStatus studentVerificationStatus,
    @JsonKey(name: 'student_email') String? studentEmail,
    @JsonKey(name: 'student_verified_at') DateTime? studentVerifiedAt,
    @JsonKey(name: 'student_verified_until') DateTime? studentVerifiedUntil,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'anonymized_at') DateTime? anonymizedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, Object?> json) =>
      _$UserProfileFromJson(json);
}
