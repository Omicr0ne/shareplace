import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_application.dart';
import 'package:shareplace/features/deals/domain/entities/deal_search_filters.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_history_page.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

void main() {
  testWidgets('affiche l’image du deal dans l’historique quand disponible', (
    tester,
  ) async {
    const profileId = 'seller-1';
    final deal = Deal(
      id: 'deal-1',
      sellerProfileId: profileId,
      title: 'Canapé',
      description: 'Canapé 2 places en très bon état.',
      postalCode: '75001',
      state: DealState.closed,
      imageUrls: const ['https://example.com/canape.png'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HistoryPage(
          profileRepository: const _FakeProfileRepository(
            profile: Profile(id: profileId, firstName: 'A', lastName: 'B'),
          ),
          dealRepository: _FakeDealRepository(
            sellerDeals: [deal],
            dealsById: {deal.id: deal},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final imageWidget = tester.widget<Image>(find.byType(Image).first);
    expect(
      (imageWidget.image as NetworkImage).url,
      'https://example.com/canape.png',
    );
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
    required this.sellerDeals,
    required this.dealsById,
  });

  final List<Deal> sellerDeals;
  final Map<String, Deal> dealsById;

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
  ) async => const {};

  @override
  Future<Deal> create(Deal deal) async => deal;

  @override
  Future<Deal> getById(String id) async => dealsById[id] ?? sellerDeals.first;

  @override
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  ) async => const [];

  @override
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  ) async => const [];

  @override
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId) async {
    return sellerDeals
        .where((deal) => deal.sellerProfileId == sellerProfileId)
        .toList(growable: false);
  }

  @override
  Future<List<Deal>> getOpenDeals() async => const [];

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
  Future<List<Deal>> searchOpenDeals(DealSearchFilters filters) async =>
      const [];

  @override
  Future<Deal> update(Deal deal) async => deal;
}