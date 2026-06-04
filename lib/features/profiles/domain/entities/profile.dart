enum StudentVerificationStatus {
  none,
  selfDeclared,
  verified,
  rejected,
}

class Profile {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.authUserId,
    this.phone,
    this.postalCode,
    this.profilePictureUrl,
    this.description = '',
    this.studentVerificationStatus = StudentVerificationStatus.none,
    this.studentEmail,
    this.studentVerifiedAt,
    this.studentVerifiedUntil,
    this.lastLoginAt,
    this.anonymizedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, Object?> json) {
    return Profile(
      id: json['id']! as String,
      firstName: json['first_name']! as String,
      lastName: json['last_name']! as String,
      authUserId: json['auth_user_id'] as String?,
      phone: json['phone'] as String?,
      postalCode: json['postal_code'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      description: json['description'] as String? ?? '',
      studentVerificationStatus: _studentVerificationStatusFromJson(
        json['student_verification_status'],
      ),
      studentEmail: json['student_email'] as String?,
      studentVerifiedAt: _dateTimeFromJson(json['student_verified_at']),
      studentVerifiedUntil: _dateTimeFromJson(
        json['student_verified_until'],
      ),
      lastLoginAt: _dateTimeFromJson(json['last_login_at']),
      anonymizedAt: _dateTimeFromJson(json['anonymized_at']),
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String? authUserId;
  final String? phone;
  final String? postalCode;
  final String? profilePictureUrl;
  final String description;
  final StudentVerificationStatus studentVerificationStatus;
  final String? studentEmail;
  final DateTime? studentVerifiedAt;
  final DateTime? studentVerifiedUntil;
  final DateTime? lastLoginAt;
  final DateTime? anonymizedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Object? authUserId = _unchanged,
    Object? phone = _unchanged,
    Object? postalCode = _unchanged,
    Object? profilePictureUrl = _unchanged,
    String? description,
    StudentVerificationStatus? studentVerificationStatus,
    Object? studentEmail = _unchanged,
    Object? studentVerifiedAt = _unchanged,
    Object? studentVerifiedUntil = _unchanged,
    Object? lastLoginAt = _unchanged,
    Object? anonymizedAt = _unchanged,
    Object? createdAt = _unchanged,
    Object? updatedAt = _unchanged,
  }) {
    return Profile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      authUserId: authUserId == _unchanged
          ? this.authUserId
          : authUserId as String?,
      phone: phone == _unchanged ? this.phone : phone as String?,
      postalCode: postalCode == _unchanged
          ? this.postalCode
          : postalCode as String?,
      profilePictureUrl: profilePictureUrl == _unchanged
          ? this.profilePictureUrl
          : profilePictureUrl as String?,
      description: description ?? this.description,
      studentVerificationStatus:
          studentVerificationStatus ?? this.studentVerificationStatus,
      studentEmail: studentEmail == _unchanged
          ? this.studentEmail
          : studentEmail as String?,
      studentVerifiedAt: studentVerifiedAt == _unchanged
          ? this.studentVerifiedAt
          : studentVerifiedAt as DateTime?,
      studentVerifiedUntil: studentVerifiedUntil == _unchanged
          ? this.studentVerifiedUntil
          : studentVerifiedUntil as DateTime?,
      lastLoginAt: lastLoginAt == _unchanged
          ? this.lastLoginAt
          : lastLoginAt as DateTime?,
      anonymizedAt: anonymizedAt == _unchanged
          ? this.anonymizedAt
          : anonymizedAt as DateTime?,
      createdAt: createdAt == _unchanged
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: updatedAt == _unchanged
          ? this.updatedAt
          : updatedAt as DateTime?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'postal_code': postalCode,
      'profile_picture_url': profilePictureUrl,
      'description': description,
      'student_verification_status': studentVerificationStatus.toJson(),
      'student_email': studentEmail,
      'student_verified_at': studentVerifiedAt?.toIso8601String(),
      'student_verified_until': studentVerifiedUntil?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'anonymized_at': anonymizedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

const _unchanged = Object();

extension StudentVerificationStatusJson on StudentVerificationStatus {
  String toJson() {
    return switch (this) {
      StudentVerificationStatus.none => 'none',
      StudentVerificationStatus.selfDeclared => 'self_declared',
      StudentVerificationStatus.verified => 'verified',
      StudentVerificationStatus.rejected => 'rejected',
    };
  }
}

StudentVerificationStatus _studentVerificationStatusFromJson(Object? value) {
  return switch (value as String? ?? 'none') {
    'self_declared' => StudentVerificationStatus.selfDeclared,
    'verified' => StudentVerificationStatus.verified,
    'rejected' => StudentVerificationStatus.rejected,
    _ => StudentVerificationStatus.none,
  };
}

DateTime? _dateTimeFromJson(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }

  return DateTime.parse(value as String);
}
