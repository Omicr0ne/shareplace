import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/data/repositories/deal_tag_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/presentation/pages/create_deal_page.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';

void main() {
  testWidgets('creates a deal with current profile as author and tags', (
    tester,
  ) async {
    final dealRepository = _FakeDealRepository();
    final tagRepository = _FakeDealTagRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: CreateDealPage(
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'current-profile-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealTagRepository: tagRepository,
          initialProductImages: [_transparentPng],
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, "Titre de l'offre"),
      'Canape convertible',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Canape deux places en bon etat.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code postal'),
      '69001',
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maison').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(dealRepository.createdDeal?.sellerProfileId, 'current-profile-id');
    expect(dealRepository.createdDeal?.title, 'Canape convertible');
    expect(tagRepository.createdDealId, 'created-deal-id');
    expect(tagRepository.createdTags, ['Maison']);
  });
}

final _transparentPng = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class _FakeProfileRepository implements ProfileRepository {
  const _FakeProfileRepository({required this.profile});

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
  Deal? createdDeal;

  @override
  Future<void> cancel(String id) async {}

  @override
  Future<Deal> create(Deal deal) async {
    createdDeal = deal;
    return deal.copyWith(id: 'created-deal-id');
  }

  @override
  Future<Deal> getById(String id) async => createdDeal!;

  @override
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId) async => [];

  @override
  Future<List<Deal>> getOpenDeals() async => [];

  @override
  Future<Deal> update(Deal deal) async => deal;
}

class _FakeDealTagRepository implements DealTagRepository {
  String? createdDealId;
  List<String>? createdTags;

  @override
  Future<void> setTagsForDeal(String dealId, List<String> tags) async {
    createdDealId = dealId;
    createdTags = List<String>.from(tags);
  }
}
