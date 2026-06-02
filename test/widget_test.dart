import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/app/shareplace_app.dart';
import 'package:shareplace/core/models/user_profile.dart';
import 'package:shareplace/features/my_deals/domain/entities/my_deal_summary.dart';
import 'package:shareplace/features/my_deals/presentation/pages/my_deals_page.dart';
import 'package:shareplace/features/profile/presentation/pages/profile_page.dart';

void main() {
  const longDescription =
      'Cette description volontairement très longue doit rester limitée à deux '
      'lignes dans la carte pour préserver la densité de la liste.';

  test('defines the home route contract', () {
    expect(AppRoutes.home, '/home');
    expect(AppRoutes.profile, '/profile');
    expect(AppRoutes.login, '/login');
    expect(AppRoutes.profileVerification, '/profile-verification');
    expect(AppRoutes.myDeals, '/my-deals');
  });

  testWidgets('shows my deals placeholder list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyDealsPage()));

    expect(find.text('Mes offres'), findsOneWidget);
    expect(find.text('Canapé convertible'), findsOneWidget);
    expect(find.text('Table basse en bois'), findsOneWidget);
    expect(find.text('Micro-ondes étudiant'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Bureau compact'), 240);

    expect(find.text('Bureau compact'), findsOneWidget);
  });

  testWidgets('opens my deals page from initial web route', (tester) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        AppRoutes.myDeals;
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await tester.pumpWidget(const SharePlaceApp());

    expect(find.text('Mes offres'), findsOneWidget);
    expect(find.text('Profil'), findsNothing);
  });

  testWidgets('does not display explicit role badges', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyDealsPage()));

    expect(find.text('Vendeur'), findsNothing);
    expect(find.text('Intéressé'), findsNothing);
  });

  testWidgets('shows seller deal interest count and sold buyer phone', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MyDealsPage()));

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.text('3 intéressés'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Acheteur : 06 12 34 56 78'),
      240,
    );

    expect(find.byIcon(Icons.shopping_cart_outlined), findsWidgets);
    expect(find.text('Vendu'), findsWidgets);
    expect(find.text('Acheteur : 06 12 34 56 78'), findsOneWidget);
  });

  testWidgets('shows interested pending and sold seller phone', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyDealsPage()));

    await tester.scrollUntilVisible(find.text('Micro-ondes étudiant'), 240);

    expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
    expect(find.text('En attente'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Vendeur : 07 98 76 54 32'), 240);

    expect(find.text('Vendeur : 07 98 76 54 32'), findsOneWidget);
  });

  testWidgets('labels interested sold deals as acquired', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyDealsPage()));

    await tester.scrollUntilVisible(find.text('Bureau compact'), 240);

    expect(find.text('Acquis'), findsOneWidget);
  });

  testWidgets('pluralizes interested count only above one', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyDealsPage(
          deals: [
            MyDealSummary(
              id: 'one-interested',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Chaise',
              description: 'Chaise simple en bon état.',
              coverImageUrl: 'https://picsum.photos/seed/chair/240/160',
              interestedCount: 1,
            ),
            MyDealSummary(
              id: 'two-interested',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Lampe',
              description: 'Lampe de bureau fonctionnelle.',
              coverImageUrl: 'https://picsum.photos/seed/lamp/240/160',
              interestedCount: 2,
            ),
          ],
        ),
      ),
    );

    expect(find.text('1 intéressé'), findsOneWidget);
    expect(find.text('2 intéressés'), findsOneWidget);
  });

  testWidgets('centers deal status information in cards', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyDealsPage()));

    final statusAlign = tester.widget<Align>(
      find.byKey(const Key('my-deal-status-align')).first,
    );

    expect(statusAlign.alignment, Alignment.center);
  });

  testWidgets('shows empty state when no active deals exist', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyDealsPage(deals: [])));

    expect(find.text('Aucune offre en cours'), findsOneWidget);
  });

  testWidgets('my deal cards truncate long descriptions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyDealsPage(
          deals: [
            MyDealSummary(
              id: 'long-description',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Description longue',
              description: longDescription,
              coverImageUrl: 'https://picsum.photos/seed/long/240/160',
            ),
          ],
        ),
      ),
    );

    final description = tester.widget<Text>(
      find.text(longDescription),
    );

    expect(description.maxLines, 2);
    expect(description.overflow, TextOverflow.ellipsis);
  });

  testWidgets('shows the profile page', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
    );

    expect(find.text('Profil'), findsOneWidget);
    expect(find.byKey(const Key('app-header-back-button')), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byKey(const Key('profile-avatar')), findsOneWidget);
    expect(
      find.byKey(const Key('profile-verification-button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('profile-first-name-field')), findsOneWidget);
    expect(find.byKey(const Key('profile-last-name-field')), findsOneWidget);
    expect(find.byKey(const Key('profile-description-field')), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('opens profile picture actions when avatar is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
    );

    await tester.tap(find.byKey(const Key('profile-avatar')));
    await tester.pumpAndSettle();

    expect(find.text('Importer une photo'), findsOneWidget);
    expect(find.text('Supprimer la photo'), findsOneWidget);
  });

  testWidgets('allows editing the profile description', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
    );

    await tester.enterText(
      find.byKey(const Key('profile-description-field')),
      'Je partage des bons plans autour de chez moi.',
    );

    expect(
      find.text('Je partage des bons plans autour de chez moi.'),
      findsOneWidget,
    );
  });

  testWidgets('shows a verification CTA when profile is not verified', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
    );

    expect(find.text('Vérifier mon compte'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
  });

  testWidgets('redirects to profile verification from the CTA', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ProfilePage(),
        routes: {
          AppRoutes.profileVerification: (_) => const Scaffold(
            body: Text('Verification page'),
          ),
        },
      ),
    );

    await tester.tap(find.byKey(const Key('profile-verification-button')));
    await tester.pumpAndSettle();

    expect(find.text('Verification page'), findsOneWidget);
  });

  testWidgets('shows a green verified badge when profile is verified', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfilePage(
          initialProfile: UserProfile(
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
    final backgroundColor = button.style?.backgroundColor?.resolve({});

    expect(find.text('Compte vérifié'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
    expect(backgroundColor, Colors.green);
  });

  testWidgets('allows editing required identity fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
    );

    await tester.enterText(
      find.byKey(const Key('profile-first-name-field')),
      'Lina',
    );
    await tester.enterText(
      find.byKey(const Key('profile-last-name-field')),
      'Martin',
    );

    expect(find.text('Lina'), findsOneWidget);
    expect(find.text('Martin'), findsOneWidget);
  });

  testWidgets('rejects empty identity fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
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

  testWidgets('asks for confirmation before signing out', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('profile-logout-button')),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-logout-button')));
    await tester.pumpAndSettle();

    expect(find.text('Confirmer'), findsOneWidget);
    expect(find.text('Annuler'), findsOneWidget);
  });

  testWidgets('redirects to sign in after confirming sign out', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ProfilePage(),
        routes: {
          AppRoutes.login: (_) => const Scaffold(body: Text('Sign in page')),
        },
      ),
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('profile-logout-button')),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-logout-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmer'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in page'), findsOneWidget);
  });
}
