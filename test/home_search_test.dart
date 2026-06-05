import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_application.dart';
import 'package:shareplace/features/deals/domain/entities/deal_search_filters.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_tag_repository.dart';
import 'package:shareplace/features/home/presentation/pages/home_page.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

void main() {
  testWidgets('searches open deals from Supabase using the home search text', (
    tester,
  ) async {
    final dealRepository = _FakeDealRepository(
      deals: [
        Deal(
          id: 'table-id',
          sellerProfileId: 'seller-id',
          title: 'Table basse',
          description: 'Table basse en bois massif.',
          postalCode: '69001',
          tags: const ['Maison', 'Bois'],
        ),
        Deal(
          id: 'lamp-id',
          sellerProfileId: 'seller-id',
          title: 'Lampe de bureau',
          description: 'Lampe fonctionnelle pour etudiant.',
          postalCode: '69002',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          profileRepository: const _FakeProfileRepository(),
          dealRepository: dealRepository,
          dealTagRepository: const _FakeDealTagRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('home-search-field')),
      'table',
    );
    await tester.tap(find.byKey(const Key('home-search-submit')));
    await tester.pumpAndSettle();

    expect(dealRepository.lastFilters?.query, 'table');
    expect(find.text('Table basse'), findsOneWidget);
    expect(find.text('Maison'), findsOneWidget);
    expect(find.text('Bois'), findsOneWidget);
    expect(find.text('Lampe de bureau'), findsNothing);
  });

  testWidgets('applies postal code, food and tag filters from the home page', (
    tester,
  ) async {
    final dealRepository = _FakeDealRepository(deals: const []);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          profileRepository: const _FakeProfileRepository(),
          dealRepository: dealRepository,
          dealTagRepository: const _FakeDealTagRepository(tags: ['Meuble']),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home-filter-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('home-postal-code-filter')),
      '69001',
    );
    await tester.tap(find.byKey(const Key('home-food-filter')));
    await tester.tap(find.text('Meuble'));
    await tester.tap(find.byKey(const Key('home-apply-filters')));
    await tester.pumpAndSettle();

    final filters = dealRepository.lastFilters;
    expect(filters?.postalCode, '69001');
    expect(filters?.isFoodSupply, isTrue);
    expect(filters?.tags, ['Meuble']);
  });
}

class _FakeProfileRepository implements ProfileRepository {
  const _FakeProfileRepository();

  @override
  Future<Profile> create(Profile profile) async => profile;

  @override
  Future<Profile?> getByAuthUserId(String authUserId) async =>
      getCurrentProfile();

  @override
  Future<Profile> getById(String id) async => (await getCurrentProfile())!;

  @override
  Future<Profile?> getCurrentProfile() async {
    return const Profile(
      id: 'current-profile-id',
      firstName: 'Lina',
      lastName: 'Martin',
    );
  }

  @override
  Future<Profile> update(Profile profile) async => profile;
}

class _FakeDealTagRepository implements DealTagRepository {
  const _FakeDealTagRepository({this.tags = const []});

  final List<String> tags;

  @override
  Future<List<String>> getAvailableTags() async => tags;

  @override
  Future<String> createTag({
    required String label,
    required String createdByProfileId,
  }) async => label;

  @override
  Future<void> setTagsForDeal(String dealId, List<String> tags) async {}
}

class _FakeDealRepository implements DealRepository {
  _FakeDealRepository({required this.deals});

  final List<Deal> deals;
  DealSearchFilters? lastFilters;

  @override
  Future<List<Deal>> searchOpenDeals(DealSearchFilters filters) async {
    lastFilters = filters;
    final normalizedQuery = filters.query?.toLowerCase();
    if (normalizedQuery == null || normalizedQuery.isEmpty) {
      return deals;
    }

    return deals
        .where(
          (deal) =>
              deal.title.toLowerCase().contains(normalizedQuery) ||
              deal.description.toLowerCase().contains(normalizedQuery) ||
              deal.postalCode.contains(normalizedQuery),
        )
        .toList(growable: false);
  }

  @override
  Future<void> addApplication({
    required String dealId,
    required String applicantProfileId,
    int quantity = 1,
  }) async {}

  @override
  Future<Deal> addImages({
    required Deal deal,
    required List<Uint8List> images,
  }) async => deal;

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
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  ) async => const [];

  @override
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  ) async => const [];

  @override
  Future<Deal> getById(String id) async => deals.first;

  @override
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId) async =>
      deals;

  @override
  Future<List<Deal>> getOpenDeals() async => deals;

  @override
  Future<bool> hasApplication({
    required String dealId,
    required String applicantProfileId,
  }) async => false;

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
