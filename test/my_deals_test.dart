import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/my_deal_summary.dart';
import 'package:shareplace/features/deals/presentation/pages/my_deals_page.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';

void main() {
  const longDescription =
      'Cette description volontairement très longue doit rester limitée à deux '
      'lignes dans la carte pour préserver la densité de la liste.';

  testWidgets('shows explicit deals and the empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyDealsPage(
          deals: [
            MyDealSummary(
              id: 'seller-pending',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Chaise',
              description: 'Chaise simple en bon état.',
              coverImageUrl: 'https://example.com/chair.png',
              interestedCount: 1,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Mes offres'), findsOneWidget);
    expect(find.text('Chaise'), findsOneWidget);
    expect(find.text('1 intéressé'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: MyDealsPage(deals: [])));

    expect(find.text('Aucune offre en cours'), findsOneWidget);
  });

  testWidgets('shows status labels for seller and interested deals', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyDealsPage(
          deals: [
            MyDealSummary(
              id: 'two-interested',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Lampe',
              description: 'Lampe de bureau fonctionnelle.',
              coverImageUrl: 'https://example.com/lamp.png',
              interestedCount: 2,
            ),
            MyDealSummary(
              id: 'seller-sold',
              role: MyDealRole.seller,
              progress: MyDealProgress.sold,
              title: 'Table',
              description: 'Table basse en bois.',
              coverImageUrl: 'https://example.com/table.png',
              counterpartPhone: '06 12 34 56 78',
            ),
            MyDealSummary(
              id: 'interested-pending',
              role: MyDealRole.interested,
              progress: MyDealProgress.pending,
              title: 'Micro-ondes',
              description: 'Micro-ondes fonctionnel.',
              coverImageUrl: 'https://example.com/microwave.png',
            ),
            MyDealSummary(
              id: 'interested-sold',
              role: MyDealRole.interested,
              progress: MyDealProgress.sold,
              title: 'Bureau',
              description: 'Bureau compact.',
              coverImageUrl: 'https://example.com/desk.png',
              counterpartPhone: '07 98 76 54 32',
            ),
          ],
        ),
      ),
    );

    expect(find.text('2 intéressés'), findsOneWidget);
    expect(find.text('Vendu'), findsOneWidget);
    expect(find.text('En attente'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Acquis'), 240);

    expect(find.text('Acquis'), findsOneWidget);
    expect(find.text('Acheteur : 06 12 34 56 78'), findsOneWidget);
    expect(find.text('Vendeur : 07 98 76 54 32'), findsOneWidget);
  });

  testWidgets('truncates long deal descriptions', (tester) async {
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
              coverImageUrl: 'https://example.com/long.png',
            ),
          ],
        ),
      ),
    );

    final description = tester.widget<Text>(find.text(longDescription));

    expect(description.maxLines, 2);
    expect(description.overflow, TextOverflow.ellipsis);
  });

  testWidgets('loads seller deals from injected repositories', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyDealsPage(
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'seller-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealRepository: _FakeDealRepository(
            deals: [
              Deal(
                id: 'deal-id',
                sellerProfileId: 'seller-id',
                title: 'Canapé convertible',
                description: 'Canapé deux places en bon état.',
                postalCode: '69001',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Canapé convertible'), findsOneWidget);
    expect(find.text('0 intéressé'), findsOneWidget);
  });

  testWidgets('loads interested deals from injected repositories', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyDealsPage(
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'buyer-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealRepository: _FakeDealRepository(
            deals: [
              Deal(
                id: 'interested-deal-id',
                sellerProfileId: 'seller-id',
                title: 'Bibliothèque',
                description: 'Bibliothèque solide en bois clair.',
                postalCode: '69001',
              ),
            ],
            applications: [
              DealApplicationRecord(
                id: 'application-id',
                dealId: 'interested-deal-id',
                applicantProfileId: 'buyer-id',
                status: DealApplicationStatus.pending,
                createdAt: DateTime(2026),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bibliothèque'), findsOneWidget);
    expect(find.text('En attente'), findsOneWidget);
  });

  testWidgets('opens deal details when tapping the deal image', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyDealsPage(
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'seller-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealRepository: _FakeDealRepository(
            deals: [
              Deal(
                id: 'deal-id',
                sellerProfileId: 'seller-id',
                title: 'Canapé convertible',
                description: 'Canapé deux places en bon état.',
                postalCode: '69001',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Image).first);
    await tester.pumpAndSettle();

    expect(find.text('Vous publiez cette annonce'), findsOneWidget);
  });
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

class _FakeDealRepository implements DealRepository {
  const _FakeDealRepository({
    required this.deals,
    this.applications = const [],
  });

  final List<Deal> deals;
  final List<DealApplicationRecord> applications;

  @override
  Future<void> addApplication({
    required String dealId,
    required String applicantProfileId,
    int quantity = 1,
  }) async {}

  @override
  Future<void> acceptApplication(String applicationId) async {}

  @override
  Future<void> cancel(String id) async {}

  @override
  Future<Map<String, int>> countApplicationsByDealIds(
    List<String> dealIds,
  ) async {
    return {for (final id in dealIds) id: 0};
  }

  @override
  Future<Deal> create(Deal deal) async => deal;

  @override
  Future<Deal> getById(String id) async => deals.firstWhere(
    (deal) => deal.id == id,
    orElse: () => deals.first,
  );

  @override
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  ) async {
    return applications
        .where(
          (application) => application.applicantProfileId == applicantProfileId,
        )
        .toList(growable: false);
  }

  @override
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  ) async {
    return applications
        .where((application) => dealIds.contains(application.dealId))
        .toList(growable: false);
  }

  @override
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId) async {
    return deals
        .where((deal) => deal.sellerProfileId == sellerProfileId)
        .toList(growable: false);
  }

  @override
  Future<List<Deal>> getOpenDeals() async => deals;

  @override
  Future<bool> hasApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {
    return false;
  }

  @override
  Future<void> rejectApplication(String applicationId) async {}

  @override
  Future<void> removeApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {}

  @override
  Future<Deal> update(Deal deal) async => deal;
}
