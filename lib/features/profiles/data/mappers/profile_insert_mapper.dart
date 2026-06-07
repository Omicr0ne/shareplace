import 'package:shareplace/features/profiles/domain/entities/profile.dart';

Map<String, Object?> profileInsertJson(Profile profile) {
  final json = profile.toJson();
  if (profile.id.isEmpty) {
    json.remove('id');
  }
  if (profile.createdAt == null) {
    json.remove('created_at');
  }
  if (profile.updatedAt == null) {
    json.remove('updated_at');
  }
  if (profile.anonymizedAt == null) {
    json.remove('anonymized_at');
  }
  if (profile.lastLoginAt == null) {
    json.remove('last_login_at');
  }
  if (profile.studentEmail == null) {
    json.remove('student_email');
  }
  if (profile.studentVerifiedAt == null) {
    json.remove('student_verified_at');
  }
  if (profile.studentVerifiedUntil == null) {
    json.remove('student_verified_until');
  }
  if (profile.postalCode == null) {
    json.remove('postal_code');
  }
  if (profile.profilePictureUrl == null) {
    json.remove('profile_picture_url');
  }

  return json;
}
