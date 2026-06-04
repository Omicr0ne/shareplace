import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/profile/presentation/pages/profile_page.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';

void main() {
  const testProfile = Profile(
    id: 'test-profile',
    firstName: 'Share',
    lastName: 'Place',
    description:
        'Décris ton profil pour aider les autres à mieux te connaître.',
  );

  testWidgets('shows the main profile actions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage(initialProfile: testProfile)),
    );

    expect(find.text('Profil'), findsOneWidget);
    expect(find.byKey(const Key('profile-avatar')), findsOneWidget);
    expect(
      find.byKey(const Key('profile-verification-button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('profile-first-name-field')), findsOneWidget);
    expect(find.byKey(const Key('profile-last-name-field')), findsOneWidget);
    expect(find.byKey(const Key('profile-description-field')), findsOneWidget);
  });

  testWidgets('opens profile picture actions when avatar is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage(initialProfile: testProfile)),
    );

    await tester.tap(find.byKey(const Key('profile-avatar')));
    await tester.pumpAndSettle();

    expect(find.text('Importer une photo'), findsOneWidget);
    expect(find.text('Supprimer la photo'), findsOneWidget);
  });

  testWidgets('shows validation errors for empty identity fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage(initialProfile: testProfile)),
    );

    await tester.enterText(
      find.byKey(const Key('profile-first-name-field')),
      '',
    );
    await tester.enterText(
      find.byKey(const Key('profile-last-name-field')),
      '',
    );
    await tester.pump();

    expect(find.text('Le prénom est obligatoire'), findsOneWidget);
    expect(find.text('Le nom est obligatoire'), findsOneWidget);
  });

  testWidgets('redirects to profile verification from the CTA', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ProfilePage(initialProfile: testProfile),
        routes: {
          AppRoutes.studentVerification: (_) => const Scaffold(
            body: Text('Verification page'),
          ),
        },
      ),
    );

    await tester.tap(find.byKey(const Key('profile-verification-button')));
    await tester.pumpAndSettle();

    expect(find.text('Verification page'), findsOneWidget);
  });

  testWidgets('shows a disabled verified badge when profile is verified', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfilePage(
          initialProfile: Profile(
            id: 'verified-profile',
            firstName: 'Lina',
            lastName: 'Martin',
            studentVerificationStatus: StudentVerificationStatus.verified,
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('profile-verification-button')),
    );

    expect(find.text('Compte vérifié'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
    expect(button.onPressed, isNull);
  });

  testWidgets('asks for confirmation before signing out', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage(initialProfile: testProfile)),
    );

    await _tapLogoutButton(tester);

    expect(find.text('Confirmer'), findsOneWidget);
    expect(find.text('Annuler'), findsOneWidget);
  });

  testWidgets('redirects to sign in after confirming sign out', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ProfilePage(initialProfile: testProfile),
        routes: {
          AppRoutes.signIn: (_) => const Scaffold(body: Text('Sign in page')),
        },
      ),
    );

    await _tapLogoutButton(tester);
    await tester.tap(find.text('Confirmer'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in page'), findsOneWidget);
  });

  testWidgets('redirects unauthenticated profile visitors to login', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ProfilePage(),
        routes: {
          AppRoutes.signIn: (_) => const Scaffold(body: Text('Sign in page')),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in page'), findsOneWidget);
  });

  testWidgets('loads the current profile from the injected repository', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfilePage(
          profileRepository: _FakeProfileRepository(profile: testProfile),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Place'), findsOneWidget);
  });
}

Future<void> _tapLogoutButton(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byKey(const Key('profile-logout-button')),
    240,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('profile-logout-button')));
  await tester.pumpAndSettle();
}

class _FakeProfileRepository implements ProfileRepository {
  const _FakeProfileRepository({this.profile});

  final Profile? profile;

  @override
  Future<Profile> create(Profile profile) async => profile;

  @override
  Future<Profile?> getByAuthUserId(String authUserId) async => profile;

  @override
  Future<Profile> getById(String id) async => profile!;

  @override
  Future<Profile?> getCurrentProfile() async => profile;

  @override
  Future<Profile> update(Profile profile) async => profile;
}
