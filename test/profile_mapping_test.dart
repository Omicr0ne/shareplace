import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/core/models/profile.dart';

void main() {
  group('Profile', () {
    test('maps Supabase json to Profile', () {
      final profile = Profile.fromJson({
        'id': 'profile-id',
        'auth_user_id': 'auth-id',
        'first_name': 'Lina',
        'last_name': 'Martin',
        'phone': '06 12 34 56 78',
        'postal_code': '69001',
        'profile_picture_url': 'https://example.com/avatar.png',
        'description': 'Profil étudiant',
        'student_verification_status': 'self_declared',
        'student_email': 'lina@example.edu',
        'student_verified_at': '2026-01-01T10:00:00.000Z',
        'student_verified_until': '2027-01-01T10:00:00.000Z',
        'last_login_at': '2026-01-02T10:00:00.000Z',
        'anonymized_at': null,
        'created_at': '2026-01-01T09:00:00.000Z',
        'updated_at': '2026-01-03T09:00:00.000Z',
      });

      expect(profile.id, 'profile-id');
      expect(profile.authUserId, 'auth-id');
      expect(profile.firstName, 'Lina');
      expect(profile.lastName, 'Martin');
      expect(
        profile.studentVerificationStatus,
        StudentVerificationStatus.selfDeclared,
      );
      expect(
        profile.studentVerifiedAt,
        DateTime.parse('2026-01-01T10:00:00.000Z'),
      );
    });

    test('maps Profile to Supabase json', () {
      final profile = Profile(
        id: 'profile-id',
        authUserId: 'auth-id',
        firstName: 'Lina',
        lastName: 'Martin',
        phone: '06 12 34 56 78',
        postalCode: '69001',
        profilePictureUrl: 'https://example.com/avatar.png',
        description: 'Profil étudiant',
        studentVerificationStatus: StudentVerificationStatus.verified,
        studentEmail: 'lina@example.edu',
        studentVerifiedAt: DateTime.parse('2026-01-01T10:00:00.000Z'),
        studentVerifiedUntil: DateTime.parse('2027-01-01T10:00:00.000Z'),
        lastLoginAt: DateTime.parse('2026-01-02T10:00:00.000Z'),
        createdAt: DateTime.parse('2026-01-01T09:00:00.000Z'),
        updatedAt: DateTime.parse('2026-01-03T09:00:00.000Z'),
      );

      expect(profile.toJson(), {
        'id': 'profile-id',
        'auth_user_id': 'auth-id',
        'first_name': 'Lina',
        'last_name': 'Martin',
        'phone': '06 12 34 56 78',
        'postal_code': '69001',
        'profile_picture_url': 'https://example.com/avatar.png',
        'description': 'Profil étudiant',
        'student_verification_status': 'verified',
        'student_email': 'lina@example.edu',
        'student_verified_at': '2026-01-01T10:00:00.000Z',
        'student_verified_until': '2027-01-01T10:00:00.000Z',
        'last_login_at': '2026-01-02T10:00:00.000Z',
        'anonymized_at': null,
        'created_at': '2026-01-01T09:00:00.000Z',
        'updated_at': '2026-01-03T09:00:00.000Z',
      });
    });
  });
}
