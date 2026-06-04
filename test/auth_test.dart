import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/core/config/supabase_config.dart';
import 'package:shareplace/features/auth/data/auth_error_messages.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';
import 'package:shareplace/features/auth/presentation/pages/sign_up_page.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseConfig', () {
    tearDown(dotenv.clean);

    test('reads Supabase credentials from dotenv', () {
      dotenv.loadFromString(
        envString: '''
SUPABASE_URL=https://example.supabase.co
SUPABASE_ANON_KEY=example-anon-key
''',
      );

      final config = SupabaseConfig.fromDotenv();

      expect(config.url, 'https://example.supabase.co');
      expect(config.anonKey, 'example-anon-key');
    });
  });

  group('authErrorMessage', () {
    test('explains Supabase email rate limit errors', () {
      const error = AuthException(
        'For security purposes, you can only request this after 60 seconds',
        statusCode: '429',
      );

      expect(
        authErrorMessage(error),
        'Trop de demandes ont été envoyées. Réessayez dans quelques minutes.',
      );
    });

    test('keeps the original message for unknown errors', () {
      expect(
        authErrorMessage(StateError('Unexpected')),
        contains('Unexpected'),
      );
    });
  });

  testWidgets('sign up creates auth user and profile row', (tester) async {
    final authService = _FakeAuthService(authUserId: 'auth-user-id');
    final profileRepository = _FakeProfileRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: SignUpPage(
          authService: authService,
          profileRepository: profileRepository,
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Prénom'),
      'Lina',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nom '),
      'Martin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'lina@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Numéro de téléphone'),
      '0612345678',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nouveau mot de passe'),
      'password123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirmer le mot de passe'),
      'password123',
    );

    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(authService.signedUpEmail, 'lina@example.com');
    expect(authService.signedUpPassword, 'password123');
    expect(profileRepository.createdProfile?.authUserId, 'auth-user-id');
    expect(profileRepository.createdProfile?.firstName, 'Lina');
    expect(profileRepository.createdProfile?.lastName, 'Martin');
    expect(profileRepository.createdProfile?.phone, '0612345678');
    expect(profileRepository.createdProfile?.createdAt, isNotNull);
    expect(profileRepository.createdProfile?.updatedAt, isNotNull);
  });
}

class _FakeAuthService extends AuthService {
  _FakeAuthService({required this.authUserId});

  final String authUserId;
  String? signedUpEmail;
  String? signedUpPassword;

  @override
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    signedUpEmail = email;
    signedUpPassword = password;

    return AuthResponse(
      user: User(
        id: authUserId,
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
        email: email,
        createdAt: DateTime.utc(2026).toIso8601String(),
      ),
    );
  }
}

class _FakeProfileRepository implements ProfileRepository {
  Profile? createdProfile;

  @override
  Future<Profile> create(Profile profile) async {
    createdProfile = profile;
    return profile.copyWith(id: 'profile-id');
  }

  @override
  Future<Profile?> getByAuthUserId(String authUserId) async => createdProfile;

  @override
  Future<Profile> getById(String id) async => createdProfile!;

  @override
  Future<Profile?> getCurrentProfile() async => createdProfile;

  @override
  Future<Profile> update(Profile profile) async => profile;
}
